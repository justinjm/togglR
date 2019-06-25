#' Get Toggl Time Entries Data
#'
#' @param api_token
#' @param workspace_id
#' @param client_ids
#' @param since
#' @param until
#' @param user_agent
#'
#' @return a dataframe of Toggl Time entries
get_toggl_entries <- function(api_token,
                              workspace_id,
                              client_ids,
                              since,
                              until,
                              user_agent = NULL) {

  message("[-] ", Sys.time(),"> ","starting to get data from toggl...")
  message("[?] ", Sys.time(),"> ", "from: ", since)
  message("[?] ", Sys.time(),"> ", "to: ", until)

  full_url_total <- sprintf(
    "https://toggl.com/reports/api/v2/details?workspace_id=%s&client_ids=%s&since=%s&until=%s&user_agent=api_test",
    workspace_id,
    paste(unlist(client_ids), collapse = ','),
    format(since, "%Y-%m-%d"),
    format(until, "%Y-%m-%d")
  )

  message("[?] ", Sys.time(),"> ","fetching total count of entires...")

  response_total <- content(GET(full_url_total,
                                # verbose(),
                                authenticate(api_token, "api_token"),
                                encode = "json"))

  message("[?] ", Sys.time(),"> ","total time entries: ", response_total$total_count)


  base_url_data <- sprintf(
    "https://toggl.com/reports/api/v2/details?workspace_id=%s&client_ids=%s&since=%s&until=%s&user_agent=api_test",
    workspace_id,
    paste( unlist(client_ids), collapse = ','),
    format(since, "%Y-%m-%d"),
    format(until, "%Y-%m-%d")
  )

  page_size = 50

  total_entries <- response_total$total_count

  num_pages <- ceiling((total_entries / page_size) + 1)

  message("[?] ", Sys.time(),"> ","fetching ", num_pages, " pages...")

  data_all <- data.frame()

  for (i in 1:num_pages){
    full_url_data <- sprintf("%s&per_page=%s&page=%s",
                             base_url_data,
                             page_size,
                             i)

    message("[?] ", Sys.time(),"> ","Getting page ", i, " of ", num_pages)

    response_data <- content(GET(full_url_data,
                                 # verbose(),
                                 authenticate(api_token, "api_token"),
                                 encode = "json"))

    jsonlite:::simplify(response_data$data, simplifyDataFrame = TRUE) -> out
    # out <- simplify(response_data$data, simplifyDataFrame = TRUE)

    data_all <- bind_rows(data_all, out)

  }

  message("[?] ", Sys.time(),"> ","All ", num_pages, " pages fetched")
  message("[x] ", Sys.time(),"> ","All ", total_entries, " time entries fetched")

  ## convert ISO 8061 time fields to datetime fields, convert milliseconds to decimal hours
  data_all %>%
    mutate(hours = dur / 3600000,
           endDateTime = as.POSIXct(strptime(end, "%Y-%m-%dT%H:%M:%S",tz = "UTC")),
           endDate = as.Date(endDateTime),
           updated = as.Date(updated))

}
