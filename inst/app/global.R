# Andryas Waurzenczak                                 Andryaas@gmail.com
# Funções genéricas
# Generic functions
# ----------------------------------------------------------------------
# colnames(selic) <- c("Reunião", "Data da reunião",
#                      "Período de vigência", "Meta Selic % a.a",
#                      "Selic % a.a", "Período de vigência (Dias)")
#
# selic <- melt(selic, id.vars = c("Reunião", "Data da reunião",
#                                  "Período de vigência",
#                                  "Período de vigência (Dias)"))
#
#
# g <- ggplot(selic, aes(x = `Data da reunião`,
#                        y = value,
#                        group = variable,
#                        colour = variable)) +
#     geom_line() + labs(x = "", y = "%") +
#     theme(legend.title = element_blank())
