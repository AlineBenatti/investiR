library(shiny)
library(shinydashboard)

dashboardPage(skin = "green",
    dashboardHeader(title = "InvestiR"),
  dashboardSidebar(
      # tags$head(tags$script(jscode)),
      sidebarMenu(id = "tabs",
                  menuItem("Tesouro Direto", tabName = "td"))
  ),
  dashboardBody(
      tabItems(
          tabItem(tabName = "td",
                  box(title = "Configurações", width = 4))
      )
  )
)
