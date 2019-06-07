## shinyglide multi-glides example app
## Live version at : https://data.nozav.org/app/shinyglide/05_multi_glides/

library(shiny)
library(shinyglide)


css <- "
.container-fluid {
  padding: 0 30px;
}
.shinyglide {
  border: 1px solid #888;
  box-shadow: 0px 0px 10px #888;
  padding: 1em;
}
"

ui <- fluidPage(
  tags$head(
    tags$style(css)
  ),
  titlePanel("Multi-glides shinyglide app"),
  fluidRow(
    p("The source code of this app is",
      tags$a(
        href = "https://github.com/juba/shinyglide/blob/master/inst/examples/05_multi_glides/app.R",
        "available on GitHub."
      )
    )
  ),
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
