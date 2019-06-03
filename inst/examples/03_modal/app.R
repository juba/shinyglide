## shinyglide modal example app

library(shiny)
library(shinyglide)

ui <- fluidPage(

  titlePanel("shinyglide modal example app"),
  sidebarLayout(
    sidebarPanel(
      numericInput("mean", "Mean", value = 0),
      numericInput("sd", "Standard deviation", value = 1, min = 0),
      numericInput("n", "n", value = 100, min = 1)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )

)


server <- function(input, output, session) {

  glide_modal <- modalDialog(
    title = "Startup assistant",
    easyClose = FALSE,
    footer = NULL,
    glide(
      custom_controls = fluidRow(
        column(width = 6,
          prevButton(),
          tags$button(
            class = "btn btn-danger first-screen",
            `data-dismiss`="modal",
            "No, thanks !"
          )
        ),
        column(width = 6, class = "text-right",
          nextButton(),
          tags$button(
            class = "btn btn-success last-screen",
            `data-dismiss`="modal",
            "Done"
          )
        )
      ),
      screen(
        p("Let's initialize some values, would you ?")
      ),
      screen(
        p("First, please select a mean value"),
        numericInput("mean_modal", "Mean", value = 0)
      ),
      screen(
        p("Next, please select a standard deviation value"),
        numericInput("sd_modal", "Standard deviation", value = 1, min = 0)
      ),
      screen(
        p("Thanks, we're all set !")
      )
    )
  )

  showModal(glide_modal)

  output$plot <- renderPlot({
    hist(rnorm(req(input$n), req(input$mean), req(input$sd)),
      main = "Such wow",
      xlab = "Wonderful x values",
      ylab = "Incredible frequencies")
  })

  observe({
    updateNumericInput(session, "mean", value = input$mean_modal)
  })

  observe({
    updateNumericInput(session, "sd", value = input$sd_modal)
  })


}

shinyApp(ui, server)
