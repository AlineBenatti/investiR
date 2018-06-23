library(dplyr)
library(rvest)
library(lubridate)
library(stringr)

selic <- function(from = NULL, to = NULL) {
    if (is.null(from)) from <- as.Date("1996-06-01")
    if (is.null(to)) to <- Sys.Date()

    if (!is.Date(as.Date(from)) | !is.Date(as.Date(to))) {
        stop("A data deve ser especificada no formato yyyy-mm-dd")
    }

    # Taxa Selic Diaria
    link1 <- "http://api.bcb.gov.br/dados/serie/bcdata.sgs.11/dados?formato=csv"
    tsd <- read.csv2(link1)
    tsd$data <- as.Date(tsd$data, "%d/%m/%Y")
    tsd$Y <- format(tsd$data, "%Y")
    tsd$YM <- format(tsd$data, "%m-%Y")

    # Historico da Taxa Selic
    link2 <- "https://www.bcb.gov.br/Pec/Copom/Port/taxaSelic.asp"

    hts <- read_html(link2)
    hts <- html_table(html_nodes(hts, "table")[[1]], fill = TRUE,
                      header = FALSE)

    colnames(hts) <- c("reuniao", "data_reuniao","ex1",
                       "periodo_vigencia", "meta_selic_aa", "ex2",
                       "ex3", "selic_aa")

    hts <- hts[, c(1:2, 4:5, 8)]
    hts <- hts[-c(1, 2), ]

    hts <- hts %>%
        mutate(reuniao = as.integer(gsub("[[:punct:]]|[ª]|[A-z]", "",
                                         reuniao)),
               data_reuniao = as.Date(data_reuniao, "%d/%m/%Y"),
               meta_selic_aa = as.numeric(gsub("[,]", ".", meta_selic_aa)),
               selic_aa = as.numeric(gsub("[,]", ".", selic_aa))) %>%
        filter(data_reuniao >= from & data_reuniao <= to)

    hts$periodo_vigencia_dias <- difftime(
        as.Date(trimws(str_extract(hts$periodo_vigencia,
                                   " [0-9]{2}/[0-9]{2}/[0-9]{4}")),
                "%d/%m/%Y"),
        as.Date(str_extract(hts$periodo_vigencia,
                            "[0-9]{2}/[0-9]{2}/[0-9]{4}"),
                "%d/%m/%Y"))

    list(selic = tsd,
         historico = hts)
}


x <- selic()

names(x)

head(x$selic)

head(x$historico)
