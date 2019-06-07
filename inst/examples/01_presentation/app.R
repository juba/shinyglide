## shinyglide presentation app
## Live version at : https://data.nozav.org/app/shinyglide/01_presentation/

library(shiny)
library(shinyglide)

controls <- glideControls(
  prevButton(),
  list(
    nextButton(),
    lastButton(
      class="btn btn-success",
      href="https://juba.github.io/shinyglide",
      "Go to project website"
    )
  )
)

css <- "
body {
  background-color: #E0E0E0;
}
.container-fluid {
  max-width: 700px;
  padding: 20px;
}
.glide-wrapper {
  border: 1px solid #888;
  box-shadow: 0px 0px 20px #888;
  background-color: #FFF;
  padding: 1em 2em 2em 2em;
}

.glide__slide img {
  max-width: 100%;
}

.bg-info {
  margin-top: 2em;
  padding: 5px;
  text-align: center;
}

span.hl.str { color: #d14;}
span.hl.kwa { color: #099;}
span.hl.num { color: #099;}
span.hl.kwd { color: #333; font-weight: bold;}
span.hl.com { color: #888; font-style: italic;}
"

ui <- fluidPage(
  tags$head(
    tags$style(css)
  ),
  fluidRow(
    div(class="glide-wrapper",
      glide(
        custom_controls = controls,

        screen(

          h3("shinyglide presentation app"),
          p(HTML("This is an presentation app of <code>shinyglide</code>, an R package to make carousel-like or assistant-like or younameit-like <a href='https://shiny.rstudio.com/'>shiny apps</a>.")),
          p("Did you already install a program on Windows ? Yup, this is the same thing."),
          p(HTML("To continue, click <em>Next</em>, use keyboard arrows, drag with your mouse, or swipe if you're on mobile."))
        ),


        screen(
          h3("Screens"),
          p(HTML("A <code>glide</code> component can be integrated into any shiny application. It is divided in screens. Each screen can contain anything you want, such as shiny inputs :")),
          numericInput("n", "n value :", value = 100)
        ),

        screen(
          h3("Screens"),
          p(HTML("Or outputs :")),
          plotOutput("plot")
        ),


        screen(
          next_condition = "input.val > 0",

          h3("Conditional controls"),
          p(HTML("Sometimes you don't want your user to be able to go to the next screen if a certain condition is not met. You can provide such a condition for the <em>Back</em> or the <em>Next</em> control.")),
          p(HTML("Here, the <em>Next</em> control gets a <em>disabled</em> status while the following input is 0 (you can choose to hide the control instead of disabling it).")),
          numericInput("val", "Value", value = 0, min = 0)
        ),

        screen(
          h3("Screen output"),
          p(HTML("Sometimes you want to generate a screen and to show it depending of user inputs. This is possible in `shinyglide` thanks to the `screenOutput` function."),
          p(HTML("For example, check the following checkbox to get a next screen with a GIF&nbsp;:")),
          div(class="bg-info",
            checkboxInput("gif", "A GIF please !", value = FALSE)
          )
        ),
        screenOutput("gif_screen"),

        screen(

          h3("Screen output"),
          p(HTML("When screen output computations takes long, the <em>Next</em> control is disabled and can show a loading label and a spinner. It comes back to its normal state when all the following screen outputs are updated.")),
          p(HTML("For example, when you check the following checkbox, an artificial two seconds loading time is taken to display the next screen (yes, with another GIF).")),
          div(class="bg-info",
            checkboxInput("gif_loading", "Show me the spinner !", value = FALSE)
          )
        ),

        screenOutput("gif_loading_screen"),

        screen(
          h3("In app controls"),
          p(HTML("You can add links or buttons inside your app that will act as a control to navigate between screens.")),
          p(HTML("For example, the following link will go back one screen&nbsp;:")),
          p(`data-glide-el`="controls",
            a(`data-glide-dir`="<", href="#", "Go back")
          ),
          p(HTML("And this link will go back all the way to the first screen&nbsp;:")),
          p(`data-glide-el`="controls",
            a(`data-glide-dir`="<<", href="#", "Let's start again")
          )
        ),

        screen(
          next_label = paste("Next one please !", icon("arrow-right", lib="glyphicon")),
          previous_label = "Let\'s go back",

          h3("Custom controls"),
          p(HTML("Default controls are created when you setup a <code>glide</code>. You can customize them by changing their label, either at glide or screen level.")),
          p(HTML("Here, this screen has different labels than the other screens."))
        ),

        screen(
          h3("Custom controls"),
          p(HTML("You can also provide a completely custom code for your controls, either manually or with some helpers functions.")),
          p(HTML("The following app gives you an example of custom controls&nbsp;:")),
          tags$a(href="https://data.nozav.org/app/shinyglide/04_custom_controls/", "Sample custom controls app")
        ),


        screen(
          h3("That's about it !"),

          p(HTML("Thanks for your attention. If you want to learn more and see other example apps, you can go to the "), a(href="https://github.com/juba/shinyglide/", "project website.")),
          p(HTML("You can also take a look at ", a(href="https://github.com/juba/shinyglide/blob/master/inst/examples/01_presentation/app.R", "this application source code.")))
      )
    )
  )
 )
)
)


server <- function(input, output, session) {

  output$plot <- renderPlot({
    hist(rnorm(input$n), main = paste("n =", input$n), xlab = "x")
  })

  output$gif_screen <- renderUI({
    if(!(input$gif)) return(NULL)
    list(
      h3("Here is your GIF"),
      div(class = "text-center",
        tags$img(src="https://media.giphy.com/media/5wWf7GW1AzV6pF3MaVW/giphy.gif")
      )
    )
  })
  outputOptions(output, "gif_screen", suspendWhenHidden = FALSE)

  output$gif_loading_screen <- renderUI({
    Sys.sleep(2)
    if(!(input$gif_loading)) return(NULL)
    list(
      h3("Here is another GIF"),
      div(class = "text-center",
        tags$img(src="https://media.giphy.com/media/rq6c5xD7leHW8/giphy.gif")
      )
    )
  })
  outputOptions(output, "gif_loading_screen", suspendWhenHidden = FALSE)





}

shinyApp(ui, server)
