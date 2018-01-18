#' Get Toggl Clients
#'
#' @param api_token
#' @param workspace_id
#' @param user_agent
#' @return a data frame of Toggl clients
#'
get_toggl_clients <- function(api_token,
                              workspace_id,
                              user_agent = "api_test") {

  # browser()
  full_url <- sprintf("https://www.toggl.com/api/v8/workspaces/%s/clients",
    workspace_id)

  response <- content(GET(full_url,
                          # verbose(),
                          authenticate(api_token, "api_token"),
                          encode = "json"))

  out <- jsonlite:::simplify(response, simplifyDataFrame = TRUE)

  return(out)

}
