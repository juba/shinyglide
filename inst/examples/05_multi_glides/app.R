## shinyglide multi-glides example app

library(shiny)
library(shinyglide)

ui <- fluidPage(
  titlePanel("Multi-glides shinyglide app"),
  fluidRow(
    column(6,
      h3("First glide"),
      glide(
        screen(
          p("This is a very simple shinyglide application."),
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
    ),
    column(6,
      h3("Second glide"),
      glide(
        screen(
          p("This is another very simple shinyglide application.")
        ),
        screen(
          p("Please choose a value."),
          numericInput("n2", "n2", value = 10, min = 10)
        ),
        screen(
          p("And here is the result."),
          plotOutput("plot2")
        )
      )
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

  output$plot2 <- renderPlot({
    hist(
      runif(input$n2),
      main = paste("n =", input$n2),
      xlab = ""
    )
  })

}

shinyApp(ui, server)
