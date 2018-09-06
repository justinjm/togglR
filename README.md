# togglR
A simple R wrapper for [Toggl Reports API v2](https://github.com/toggl/toggl_api_docs/blob/master/reports.md) to build simple reports and dashboards for personal productivity (utilization and distribution).

This R package does 3 things:
1. authenticates with [toggl](https://github.com/toggl/toggl_api_docs/blob/master/chapters/authentication.md)
2. export toggl [clients](https://github.com/toggl/toggl_api_docs/blob/master/chapters/clients.md) 
3. export toggl [time entries](https://github.com/toggl/toggl_api_docs/blob/master/reports/detailed.md)

to extract time entries data. Used to build simple reports and dashboards 

## Installation



```R
if (!requireNamespace("devtools")){install.packages("devtools")}
devtools::install_github("justinjm/togglR")
```
