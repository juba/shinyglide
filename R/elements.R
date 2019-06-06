#' glide component creation
#'
#' Insert a glide component in the current shiny app UI
#'
#' @param id optional HTML id of the glide root element.
#' @param next_label label to be used in the "next" control.
#' @param previous_label label to be used in the "back" control.
#' @param loading_label label to be used in the "next" control when the next
#'     screen is still loading.
#' @param loading_class class to add to the "next" control when the next
#'     screen is still loading.
#' @param disable_type either to "disable" or "hide" the next or back control
#'     when it is disabled by a condition.
#' @param height height of the glide (something like "400px" or "100\%").
#' @param custom_controls custom HTML or shiny tags to be used for the controls.
#'     If `NULL``, use the default ones.
#' @param controls_position either to place the default or custom controls on "top"
#'     or "bottom" of the glide.
#' @param ... content of the glide.
#'
#' @seealso screen nextButton prevButton firstButton lastButton
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fixedPage(
#'  h3("Simple shinyglide app"),
#'  glide(
#'     screen(
#'       p("First screen.")
#'     ),
#'     screen(
#'       p("Second screen."),
#'     )
#'   )
#' )
#'
#' server <- function(input, output, session) {
#' }
#'
#' shinyApp(ui, server)
#'
#' }
#'
#' @export
#' @import shiny

glide <- function(...,
  id = NULL,
  next_label = paste("Next", shiny::icon("chevron-right", lib = "glyphicon")),
  previous_label = paste(shiny::icon("chevron-left", lib = "glyphicon"), "Back"),
  loading_label = span(span(class="shinyglide-spinner"), span("Loading")),
  loading_class = "loading",
  disable_type = c("disable", "hide"),
  height = "100%",
  custom_controls = NULL,
  controls_position = c("bottom", "top")) {

  css <- paste0("height: ", height, ";")
  disable_type <- match.arg(disable_type)
  controls_position <- match.arg(controls_position)

  controls <- if(is.null(custom_controls)) {
    glideControls(previous_label, next_label)
  } else {
    custom_controls
  }

  tagList(
    tags$div(class = "shinyglide", id = id,
            `data-next-label` = HTML(as.character(next_label)),
            `data-prev-label` = HTML(as.character(previous_label)),
            `data-loading-label` = HTML(as.character(loading_label)),
            `data-loading-class` = loading_class,
            `data-disable-type` = disable_type,

      if (controls_position == "top") controls,

      tags$div(class = "glide__track", `data-glide-el` = "track",
        tags$ul(class = "glide__slides", style = css,
          list(...)
        )
      ),

      if (controls_position == "bottom") controls,

      glideDetectors()
    ),
    glideLib(),
    shinyglideLib()
  )

}





#' screen creation
#'
#' Insert a new screen into a glide component.
#'
#' This function inserts a new "screen" into an existing `glide` component. It
#' can only be used inside a `glide()` call, in a shiny app UI.
#'
#' @param next_label specific label of the "next" control for this screen. If `NULL`,
#' use the default one for the current glide.
#' @param prev_label specific label of the "back" control for this screen. If `NULL`,
#' use the default one for the current glide.
#' @param next_condition condition for the "next" control to be enabled. Same syntax
#' as `shiny::conditionalPanel`.
#' @param prev_condition condition for the "back" control to be enabled. Same syntax
#' as `shiny::conditionalPanel`.
#' @param class screen CSS classes. `glide__slide` is automatically added.
#' @param ... content of the screen.
#'
#' @seealso glide
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fixedPage(
#'  h3("Simple shinyglide app"),
#'  glide(
#'     screen(
#'       next_label = "Go next",
#'       next_condition = "input.x > 0",
#'       p("First screen."),
#'       numericInput("x", "x", value = 0)
#'     ),
#'     screen(
#'       p("Final screen."),
#'     )
#'   )
#' )
#'
#' server <- function(input, output, session) {
#' }
#'
#' shinyApp(ui, server)
#'
#' }
#'
#' @export

screen <- function(...,
  next_label = NULL,
  prev_label = NULL,
  next_condition = NULL,
  prev_condition = NULL,
  class = NULL) {

  class <- paste(union(class, "glide__slide"), collapse = " ")

  shiny::tag("li",
    list(
      class = class,
      `data-prev-label` = prev_label,
      `data-next-label` = next_label,
      `data-prev-condition` = prev_condition,
      `data-next-condition` = next_condition,
      list(...)
    )
  )
}


glideControls <- function(previous_label, next_label) {
  fluidRow(
    tags$div(class="col-xs-6",
      prevButton(previous_label)
    ),
    tags$div(class="col-xs-6 text-right",
      nextButton(next_label)
    )
  )
}


glideDetectors <- function() {
  tagList(
    tags$span(class = "shinyglide-detector next-detector"),
    tags$span(class = "shinyglide-detector prev-detector")
  )
}



#' Code for the default "next" control
#'
#' This generates the code of the default "next" control, and can be used in custom
#' controls.
#'
#' @param label control label.
#' @param class control CSS classes. `next-screen` is automatically added.
#'
#' @seealso prevButton firstButton lastButton
#'
#' @export

nextButton <- function(
    label = paste("Next", shiny::icon("chevron-right", lib = "glyphicon")),
    class = c("btn", "btn-primary")
  ) {

  class <- paste(union(class, "next-screen"), collapse = " ")

  tags$button(
    class = class,
    HTML(label)
  )
}


#' Code for the default "back" control
#'
#' This generates the code of the default "back" control, and can be used in custom
#' controls.
#'
#' @param label control label.
#' @param class control CSS classes. `prev-screen` is automatically added.
#'
#' @seealso nextButton firstButton lastButton
#'
#' @export

prevButton <- function(
    label = paste(shiny::icon("chevron-left", lib = "glyphicon"), "Back"),
    class = c("btn", "btn-default")
  ) {

  class <- paste(union(class, "prev-screen"), collapse = " ")

  tags$button(
    class = class,
    HTML(label)
  )
}

#' Code for the default "first" control
#'
#' This generates the code of the default "first" control, which is only displayed
#' on the first screen of a glkide, and can be used in custom controls.
#'
#' @param label control label.
#' @param class control CSS classes. `first-screen` is automatically added.
#'
#'
#' @seealso nextButton prevButton lastButton
#'
#' @export

firstButton <- function(label, class = c("btn", "btn-default")
  ) {

  class <- paste(union(class, "first-screen"), collapse = " ")

  tags$button(
    class = class,
    HTML(label)
  )
}

#' Code for the default "last" control
#'
#' This generates the code of the default "last" control, which is only displayed
#' on the last screen of a glide, and can be used in custom controls.
#'
#' @param label control label.
#' @param class control CSS classes. `last-screen` is automatically added.
#'
#' @seealso nextButton prevButton firstButton
#'
#' @export

lastButton <- function(label, class = c("btn", "btn-success")
  ) {

  class <- paste(union(class, "last-screen"), collapse = " ")

  tags$button(
    class = class,
    HTML(label)
  )
}




