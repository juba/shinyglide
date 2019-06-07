## shinyglide custom controls app
## Live version at : https://data.nozav.org/app/shinyglide/04_custom_controls/

library(shiny)
library(shinyglide)

controls <- tags$div(
    tags$div(class="my-control prev-screen"),
    tags$div(class="my-control next-screen"),
    div(`data-glide-el`="controls",
      tags$a(
        class="my-control last-screen",
        `data-glide-dir` = "<<",
        icon("repeat", lib = "glyphicon")
      )
    )
  )

css <- "
.container-fluid {
  max-width: 700px;
  padding: 0 20px;
}
.shinyglide {
  border: 1px solid #888;
  box-shadow: 0px 0px 20px #888;
}
.my-control {
  display: block;
  position: absolute;
  top: 50%;
  transform: translateY(-50%);
  line-height: 1;
  font-size: 2.5em;
  color: #0055DD;
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
  left: 20px;
}
.next-screen,
.last-screen {
  right: 20px;
}
.glide__slides {
  margin: 0 7em;
}

@keyframes hourglass {
  from {
    transform: translateY(-50%) rotate(0deg);
  }
  50% {
    transform: translateY(-50%) rotate(359deg);
  }
  to {
    transform: translateY(-50%) rotate(360deg);
  }
}
.loading {
  font-size: 2em;
  animation: hourglass 1s linear infinite;
}
"

ui <- fluidPage(
  tags$head(
    tags$style(css)
  ),
  titlePanel("shinyglide custom controls app"),
  fluidRow(
    p("This simple app shows an example of completely custom controls."),
    p("Its source code is",
      tags$a(
        href = "https://github.com/juba/shinyglide/blob/master/inst/examples/04_custom_controls/app.R",
        "available on GitHub"
      )
    )
  ),
  fluidRow(
      glide(
        next_label = icon("chevron-right", lib="glyphicon"),
        previous_label = icon("chevron-left", lib="glyphicon"),
        loading_label = icon("hourglass", lib="glyphicon"),
        height = "300px",
        custom_controls = controls,

        screen(
          h3("First screen"),
          p("Click the arrow to go to next screen")
        ),

        screen(
          h3("Second screen"),
          p("Check the following checkbox to see the loading animation."),
          checkboxInput("x", "Such wow !", value = FALSE)
        ),

        screenOutput("loading_screen"),

        screen(
          h3("Final screen"),
            p("And... this is the end.")
          )
      )
  )
)


server <- function(input, output, session) {

  output$loading_screen <- renderUI({
    Sys.sleep(2)
    list(
      h3("Custom controls"),
      if(input$x) {
        p("Incredible, you checked the box !")
      } else {
        p("You unchecked the box, unbelievable !")
      }
    )
  })
  outputOptions(output, "loading_screen", suspendWhenHidden = FALSE)

}

shinyApp(ui, server)
