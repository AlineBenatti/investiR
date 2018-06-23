library(dplyr)
library(lubridate)
library(stringr)

selic <- function(from = NULL, to = NULL) {
    if (is.null(from)) from <- as.Date("1996-06-01")
    if (is.null(to)) to <- Sys.Date()

    if (!is.Date(as.Date(from)) | !is.Date(as.Date(to))) {
        stop("A data deve ser especificada no formato yyyy-mm-dd")
    }

    link <- "https://www.bcb.gov.br/Pec/Copom/Port/taxaSelic.asp"

    while (TRUE) {
        x <- suppressWarnings(
            suppressMessages(
                try(htmltab::htmltab(link), silent = TRUE)
        ))
        if (exists("x")) {
            if (colnames(x)[1] != "V1" & class(x) != "try-error") {
                break
            }
        }
    }

    x <- x[, c(1:4, 6)]
    colnames(x) <- c("reu", "dtreu", "pervig", "metaselic", "selicaa")

    selic <- x %>%
        mutate(reu = as.integer(gsub("[[:punct:]]|[ª]|[A-z]", "", reu)),
               dtreu = as.Date(dtreu, "%d/%m/%Y"),
               metaselic = as.numeric(gsub("[,]", ".", metaselic)),
               selicaa = as.numeric(gsub("[,]", ".", selicaa))) %>%
        filter(dtreu >= from & dtreu <= to)

    selic$qtpervig <- difftime(
        as.Date(trimws(str_extract(selic$pervig,
                                   " [0-9]{2}/[0-9]{2}/[0-9]{4}")),
                "%d/%m/%Y"),
        as.Date(str_extract(selic$pervig,
                            "[0-9]{2}/[0-9]{2}/[0-9]{4}"),
                "%d/%m/%Y"))

    colnames(selic) <- c("reuniao", "dt_reuniao", "periodo_vigencia",
                         "metaselic", "selic", "periodo_vigencia_dias")

    selic <- selic[, c(1:3, 6, 4:5)]

    selic
}
