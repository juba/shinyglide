library(shinydashboard)
library(shinyjs)
if (!require(shinyglide))
  remotes::install_github("juba/shinyglide")

controls <- glideControls(
  list(
    shiny::actionButton("prev_screen_btn", "Next", class = "prev-screen"),
    shiny::actionButton("first_screen_btn", "First screen !", class = "btn-danger first-screen")
  ),
  list(
    shiny::actionButton("next_screen_btn", "Next", class = "next-screen"),
    shiny::actionButton("last_screen_btn", "Last screen...",
                        class = "btn-success last-screen", icon = icon("ok", lib = "glyphicon"))
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

for (i in 1:length(screens)) {
  screens[[i]]$attribs$id <- paste0("screen_", i)
}

screens$custom_controls <- controls

jsCode <- "shinyjs.activeScreen = function(params) {Shiny.setInputValue('activeScreen', $('.glide__slide.glide__slide--active').attr('id'));}"

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
    tags$head(
      shinyjs::useShinyjs(),
      shinyjs::extendShinyjs(text = jsCode, functions = "activeScreen")
    ),
    tabItems(
      tabItem(
        tabName = "welcome_page",
        box(width = 12,
            do.call(shinyglide::glide, screens)
        ),
        box(width = 12,
            tags$div(id = "glide2"),
            actionButton("mountGlide", "Mount")

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
}

shinyApp(ui = ui, server = server)
