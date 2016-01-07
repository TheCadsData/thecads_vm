packages <- c(
    "caTools",
    "dplyr",
    "ggplot2",
    "hash",
    "httr",
    "knitr",
    "lubridate",
    "magrittr",
    "memoise",
    "nycflights13",
    "parallel",
    "png",
    "readr",
    "rvest",
    "sqldf",
    "stringr",
    "swirl",
    "tidyr"
)

for (p in packages) {
    if (p %in% rownames(installed.packages()) == TRUE) {
        print(p)
        next
    }

    install.packages(as.character(p), repos='http://cran.us.r-project.org')
}
