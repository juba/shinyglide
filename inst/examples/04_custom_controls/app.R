## shinyglide custom controls app

library(shiny)
library(shinyglide)

controls <- tags$div(
    tags$div(class="my-control prev-screen"),
    tags$div(class="my-control next-screen")
  )

css <- "
.container-fluid {
  max-width: 500px;
}
.shinyglide {
  border: 1px solid black;
}
.my-control {
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  line-height: 1;
  font-size: 2.5em;
  opacity: 0.8;
  cursor: pointer;
}
.my-control:hover {
  opacity: 1;
}
.disabled {
  opacity: 0.3;
  cursor: not-allowed;
}
.prev-screen {
  left: 10px;
}
.next-screen {
  right: 10px;
}
.glide__slides {
  margin: 0 4em;
}
"

ui <- fluidPage(
  tags$head(
    tags$style(css)
  ),
  titlePanel("shinyglide custom controls app"),

  fluidRow(
      glide(
        next_label = icon("circle-arrow-right", lib="glyphicon"),
        previous_label = icon("circle-arrow-left", lib="glyphicon"),
        loading_label = icon("hourglass", lib="glyphicon"),
        height = "300px",
        custom_controls = controls,

        screen(
          h3("Custom controls"),
          p(HTML("First screen"))
        ),

        screen(
          h3("Custom controls"),
          p(HTML("Second screen with loading")),
          checkboxInput("x", "x", value = FALSE)
        ),

        screenOutput("loading_screen"),

        screen(
          h3("Custom controls"),
          p(HTML("Final screen"))
        )

      )
  )
)


server <- function(input, output, session) {

  output$loading_screen <- renderUI({
    Sys.sleep(2)
    input$x
    list(
      h3("Custom controls"),
      p(HTML("Loaded screen"))
    )
  })

}

shinyApp(ui, server)
