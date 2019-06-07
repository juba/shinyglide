## shinyglide simple example app

library(shiny)
library(shinyglide)

ui <- fixedPage(style = "max-width: 500px;",
  titlePanel("Simple shinyglide app"),

  glide(
    height = "350px",
    screen(
      p("This is a very simple shinyglide application."),
      p("It's source code is ",
        tags$a(href = "https://github.com/juba/shinyglide/blob/master/inst/examples/02_simple/app.R", "available on GitHub.")),
      p("Please click on Next to go to the next screen.")
    ),
    screen(
      p("Please choose a value."),
      numericInput("n", "n", value = 10, min = 10)
    ),
    screen(
      p("And here is the result."),
      plotOutput("plot")
    )
  )
)


server <- function(input, output, session) {

  output$plot <- renderPlot({
    hist(
      rnorm(input$n),
      main = paste("n =", input$n),
      xlab = ""
    )
  })

}

shinyApp(ui, server)
