## shinyglide full example app

library(shiny)
library(shinyglide)

ui <- fluidPage(

  glide(

    default_controls = TRUE,
    screen(
      numericInput("x", "x", value = 10, min = 10)
    ),
    screen(
      plotOutput("plot")
    )
  )

)


server <- function(input, output, session) {

  output$plot <- renderPlot({
    hist(rnorm(input$x))
  })

}

shinyApp(ui, server)
