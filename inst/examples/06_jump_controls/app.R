library(shinydashboard)
library(shinyglide)

controls <- glideControls(
  list(
    prevBtn("prev_screen_btn",  "Previous"),
    firstBtn("first_screen_btn", "First screen !")
  ),
  list(
    nextBtn("next_screen_btn", "Next"),
    lastBtn("last_screen_btn", "Last screen...")
  ),
  list(
    shiny::actionButton("jump_0_btn", "1", class = "jump-screen"),
    shiny::actionButton("jump_1_btn", "2", class = "jump-screen"),
    shiny::actionButton("jump_2_btn", "3", class = "jump-screen")
  )
)

screens <- list(
  shinyglide::screen(
    p("Please choose a value for n :"),
    numericInput("n", "n :", value = 100)
  ),
  shinyglide::screen(
    p("Here is your plot :"),
    plotOutput("plot")
  ),
  shinyglide::screen(
    p("3rd screen")
  )
)

screens$custom_controls <- controls

ui <- dashboardPage(
  dashboardHeader(title = "Example shinyglide app"),
  dashboardSidebar(
    sidebarMenu(
      id = "main_menu",
      menuItem("Welcome Page", tabName = "welcome_page"),
      menuItem("Menu 1", tabName = "menu1"),
      menuItem("Menu 2", tabName = "menu2"),
      menuItem("Menu 3", tabName = "menu3")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "welcome_page",
        box(width = 12,
            do.call(shinyglide::glide, screens)
        ),
        box(width = 12,
            h3("empty box")

        )
      ),
      tabItem(
        tabName = "menu1",
      ),
      tabItem(
        tabName = "menu2",
      ),
      tabItem(
        tabName = "menu3",
      )
    )
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    print(">>>>>> rendering plot")
    hist(rnorm(input$n), main = paste("n =", input$n))
  })
  observeEvent(input$next_screen_btn, {
    print(">>>>>> clicked next button")
  })
  observeEvent(input$next_screen_btn, {
    print(">>>>>> clicked next button")
  })
}

shinyApp(ui = ui, server = server)
