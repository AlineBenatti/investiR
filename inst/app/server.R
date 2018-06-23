# Exemplo de uso para resetar ID

# Taxa Selic - Fun
source("/home/aw/Documentos/github/investiR/R/selic.R")

shinyServer(function(input, output, session) {



    # Output -----------------------------------------------------------
    output$taxa_selic <- renderPlot({
    })
})
