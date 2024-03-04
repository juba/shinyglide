## shinyglide modal example app

library(shiny)
library(shinyglide)

ui <- fixedPage(
  titlePanel("shinyglide modal example"),
  sidebarLayout(
    sidebarPanel(
      numericInput("mean", "Mean", value = 0),
      numericInput("sd", "Standard deviation", value = 1, min = 0),
      numericInput("n", "n", value = 100, min = 1),
      p(
        tags$a(
          href = "https://github.com/juba/shinyglide/blob/master/inst/examples/03_modal/app.R",
          "Source code on GitHub"
        )
      )
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)


server <- function(input, output, session) {
  modal_controls <- glideControls(
    list(
      prevButton(),
      firstButton(
        class = "btn btn-danger",
        `data-dismiss` = "modal",
        "No, thanks !"
      )
    ),
    list(
      nextButton(),
      lastButton(
        class = "btn btn-success",
        `data-dismiss` = "modal",
        "Done"
      )
    )
  )

  glide_modal <- modalDialog(
    title = "Startup assistant",
    easyClose = FALSE,
    footer = NULL,
    glide(
      custom_controls = modal_controls,
      screen(
        next_label = 'Yes, please ! <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>',
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
      ylab = "Incredible frequencies"
    )
  })

  observe({
    updateNumericInput(session, "mean", value = input$mean_modal)
  })

  observe({
    updateNumericInput(session, "sd", value = input$sd_modal)
  })
}

shinyApp(ui, server)
