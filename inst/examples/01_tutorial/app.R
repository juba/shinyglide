## shinyglide introduction app

library(shiny)
library(shinyglide)
library(glue)
library(styler)
library(highr)

format_code <- function(code) {
  out <- styler::style_text(code)
  ## Generated code syntax highlighting
  out <- paste(highr::hi_html(out), collapse = "\n")
  ## Final paste
  HTML(paste0("<pre class='r'><code class='r'>",out,"</code></pre>"))
}

controls <- fluidRow(
  column(width = 6,
    prevButton()
  ),
  column(width = 6, class = "text-right",
    nextButton(),
    tags$a(
      class="btn btn-success last-screen",
      style="display: none",
      href="https://github.com/juba/shinyglide",
      "Go to project website"
    )
  )
)

css <- "
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
    column(
      width = 8,
      offset = 2,

      glide(
        custom_controls = controls,

        screen(

          h3("shinyglide introduction app"),
          p(HTML("This is an introduction app to <code>shinyglide</code>, an R package to make carousel-like or assistant-like or younameit-like <a href='https://shiny.rstudio.com/'>shiny apps</a>.")),
          p("Did you already install a program on Windows ? Yup, this is the same thing."),
          p(HTML("To continue, click <em>Next</em>, use keyboard arrows, drag with your mouse, or swipe if you're on mobile."))
        ),

        screen(
          h3("Setup"),
          p(HTML("To create a <code>shinyglide</code> app, you just call the <code>glide()</code> function. There are a number of arguments to customize its behavior and appearence, most of them allow to modify the glide <em>controls</em>, the <em>Back</em> and <em>Next</em> buttons that you see below.")),
          format_code(
              'glide(
                next_label = "Go on",
                next_label_icon = icon("next"),
                previous_label = "Previous",
                height = "300px",

                ...

              )'
          ),
          p(HTML("You can embed this anywhere in an existing <code>shiny</code> application UI."))
        ),

        screen(
          h3("Screens"),
          p(HTML("Once your <code>glide</code> is created, you must add some <em>screens</em> to it with the <code>screen()</code> function&nbsp;:")),
          format_code(
            'glide(
              screen(
                p("This text is displayed on the first screen."),
                p("Click the next button to see the rest.")
              ),
              screen(
                p("This is the second and last screen of our app."),
                p("Click the back button to go back")
              )
            )'
          )
        ),

        screen(
          h3("Screens"),
          p(HTML("<code>screens</code> can contain anything you want, such as shiny <em>inputs</em> and <em>outputs</em>&nbsp;:")),
          format_code(
            'glide(
              screen(
                numericInput("x", "x value :", value = 100)
              ),
              screen(
                plotOutput("plot")
              )
            )'
          )
        ),


        screen(
          next_condition = "input.val > 0",

          h3("Conditional controls"),
          p(HTML("Sometimes you don't want your user to be able to go to the next screen if a certain condition is not met. You can provide a condition to the <code>next_condition</code> or <code>prev_condition</code> arguments of the <screen> function, with the same syntax as shiny's <code>conditionalPanel</code>&nbsp;")),
          format_code(
            'screen(
              next_condition = "input.val > 0",
              numericInput("val", "Value", value = 0)
            )'
          ),
          p(HTML("Here, the <em>Next</em> control gets a <em>disabled</em> status while the following input is 0 (you can choose to hide the control instead of disabling it with the <code>glide()</code> <code>disable_type</code> argument).")),
          numericInput("val", "Value", value = 0, min = 0)
        ),

        screen(

          h3("Screen output"),
          p(HTML("Screen output allows to generate <code>screens</code> based on server-side logic. For this you have to use a <code>screenOutput</code> in your UI and a <code>renderUI</code> in your server. If <code>renderUI</code> returns <code>NULL</code>, the screen is not displayed at all.")),
          p("In UI :"),
          format_code('screenOutput("test_screen")'),
          p("In server :"),
          format_code('output$test_screen <- renderUI({
              if (input$skip_this) return(NULL)
              p("This screen is not skipped")
            })
            outputOptions(output, "test_screen", suspendWhenHidden = FALSE)
            '
          ),
          p(HTML("For example, check the following checkbox to get a next screen with a GIF&nbsp;:")),
          checkboxInput("gif", "A GIF please !", value = FALSE)
        ),
        screenOutput("gif_screen"),

        screen(

          h3("Screen output"),
          p(HTML("When screen output computations takes long, the <em>Next</em> control is disabled and can show a loading label and a spinner. It comes back to its normal state when all the following screen outputs are updated.")),
          p(HTML("For example, when you check the following checkbox, an artificial two seconds loading time is taken to display the next screen (yes, with another GIF).")),
          checkboxInput("gif_loading", "Show me the spinner !", value = FALSE)
        ),
        screenOutput("gif_loading_screen"),

        screen(

          h3("In app controls"),
          p(HTML("You can add links or buttons inside your app that will act as a control to navigate between screens. Just enclose them in a <code>div</code> with <code>data-glide-el`=\"controls\"</code>, and add a <code>data-glide-dir</code> attribute following <a href='https://glidejs.com/docs/setup/#controls'>Glide conventions</a>.")),
          p(HTML("For example, the following link will go back one screen&nbsp;:")),
          format_code('div(`data-glide-el`="controls",
            a(`data-glide-dir`="<", href="#", "Go back")
            )'),
          div(`data-glide-el`="controls",
            a(`data-glide-dir`="<", href="#", "Go back")
          ),
          p(HTML("And this button will go back to the first screen&nbsp;:")),
          format_code('div(`data-glide-el`="controls",
            tags$button(`data-glide-dir`="<<", "Let\'s start again")
            )'),
          div(`data-glide-el`="controls",
            tags$button(`data-glide-dir`="<<", "Let's start again")
          )
        ),

        screen(
          h3("Custom controls"),
          p(HTML("Default controls are created when you setup a <code>glide</code>. You can customize them with the following arguments&nbsp:")),
          tags$ul(
            tags$li(HTML("<code>next_label</code>&nbsp;: next control label")),
            tags$li(HTML("<code>previous_label</code>&nbsp;: previous control label")),
            tags$li(HTML("<code>loading_label</code>, <code>loading_class</code>&nbsp;: next control label and class when in loading state")),
            tags$li(HTML('<code>disable_type</code>&nbsp;: wether to <code>"hide"</code> or <code>"disable"</code> a control when condition is not met')),
            tags$li(HTML('<code>controls_position</code>&nbsp;: wether to place controls on <code>"top"</code> or <code>"bottom"</code>'))
          )
        ),

        screen(
          h3("Custom controls"),
          p(HTML("You can also provide a completely custom HTML code for your controls with the <code>custom_controls</code> argument of <code>glide()</code>. The next control must have a <code>next-screen</code> class, and the previous control a <code>prev-screen</code> class.")),
          p(HTML("You can also use the <code>prevButton</code> and <code>nextButton</code> helper functions to generate the button codes with correct classes")),
          p(HTML("Here is an example&nbsp;:")),
          format_code('controls <- tagList(
            tags$button(class = "prev-screen", "Previous"),
            nextButton(label = "Next")
          )

          glide(
            custom_controls = controls,
            controls_position = "top",
            ...
          )')
        ),

        screen(
          next_label = paste("Next one please !", icon("arrow-right", lib="glyphicon")),
          prev_label = "Let\'s go back",

          h3("Customizing controls per screen"),
          p(HTML("You can also customize labels and icons of controls per screen with the <code>next_label</code>, <code>next_label_icon</code>, <code>prev_label</code>, and <code>prev_label_icon</code> arguments.")),
          p(HTML("You can see the result of the following code on the current screen&nbsp;:")),
          format_code('screen(
              next_label = "Next one please !",
              next_label_icon = icon("arrow-right", lib="glyphicon"),
              prev_label = "Let\'s go back",
              ...
            )'
          )



        ),


        screen(
          h3("First and last controls"),

          p(HTML("If you use custom controls, you can declare first and last controls which will only be displayed on the first and last screens. They must have the <code>first-screen</code> and <code>last-screen</code> class respectively.")),
          p(HTML("This can be used to replace the back control on the first screen and the next control on the last screen.")),
          p(HTML("The <code>firstButton</code> and <code>lastButton</code> helper functions can be used to generate buttons with the correct classes."))


        ),

        screen(
          h3("That's it !"),

          p(HTML("Thanks for your attention. Here are some useful links&nbsp;:")),
          tags$ul(
            tags$li(
              a(href="https://github.com/juba/shinyglide/", "shinyglide on GitHub")
            )
          )
        )



      )
    )
  )
)


server <- function(input, output, session) {

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
