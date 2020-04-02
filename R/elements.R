#' Glide component creation
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
#' @param keyboard set this to FALSE to disable keyboard navigation.
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
#'       p("Second screen.")
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
  keyboard = TRUE,
  custom_controls = NULL,
  controls_position = c("bottom", "top")) {

  css <- paste0("height: ", height, ";")
  disable_type <- match.arg(disable_type)
  controls_position <- match.arg(controls_position)

  previous_label <- HTML(as.character(previous_label))
  next_label <- HTML(as.character(next_label))
  loading_label <- HTML(as.character(loading_label))

  controls <- if(is.null(custom_controls)) {
    glideControls(
      prevButton(),
      nextButton()
    )
  } else {
    custom_controls
  }

  tagList(
    tags$div(class = "shinyglide", id = id,
            `data-keyboard` = keyboard,
            `data-next-label` = next_label,
            `data-prev-label` = previous_label,
            `data-loading-label` = loading_label,
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





#' Screen creation
#'
#' Insert a new screen into a glide component.
#'
#' This function inserts a new "screen" into an existing `glide` component. It
#' can only be used inside a `glide()` call, in a shiny app UI.
#'
#' @param next_label specific label of the "next" control for this screen. If `NULL`,
#' use the default one for the current glide.
#' @param previous_label specific label of the "back" control for this screen. If `NULL`,
#' use the default one for the current glide.
#' @param next_condition condition for the "next" control to be enabled. Same syntax
#' as `shiny::conditionalPanel`.
#' @param previous_condition condition for the "back" control to be enabled. Same syntax
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
  previous_label = NULL,
  next_condition = NULL,
  previous_condition = NULL,
  class = NULL) {

  class <- paste(union(class, "glide__slide"), collapse = " ")

  shiny::tag("li",
    list(
      class = class,
      `data-prev-label` = previous_label,
      `data-next-label` = next_label,
      `data-prev-condition` = previous_condition,
      `data-next-condition` = next_condition,
      list(...)
    )
  )
}




#' Default controls layout
#'
#' Creates an horizontal layout with both "previous" and "next" contents
#' side by side.
#'
#' @param previous_content Content of the "previous" (left) zone.
#' @param next_content Content of the "next" (right) zone.
#'
#' @export
#'
#' @examples
#' glideControls(
#'   prevButton("Back"),
#'   list(
#'     lastButton(href = "https://example.com", "Go to website"),
#'     nextButton("Next")
#'   )
#' )

glideControls <- function(previous_content, next_content, jump_content = NULL) {
  if (is.null(jump_content)) {
    fluidRow(
      tags$div(class="col-xs-6",
               previous_content
      ),
      tags$div(class="col-xs-6 text-right",
               next_content
      )
    )
  } else {
    for (i in 1:length(jump_content)) {
      jump_content[[i]]$attribs$screen = i
    }

    fluidRow(
      tags$div(class="col-xs-3",
               previous_content
      ),
      tags$div(class="col-xs-6 text-middle",
               jump_content
      ),
      tags$div(class="col-xs-3 text-right",
               next_content
      )
    )
  }
}


glideDetectors <- function() {
  tagList(
    tags$span(class = "shinyglide-detector next-detector"),
    tags$span(class = "shinyglide-detector prev-detector")
  )
}



#' Code for the default controls
#'
#' This generates the code of the default controls, and can be used in custom
#' controls.
#'
#' @details
#' `prevButton` is hidden on the first screen, while `nextButton` is hidden on
#' the last one.
#' The buttons labels are set with the `next_label` and `previous_label`
#' arguments of `glide()`.
#'
#' @param class control CSS classes. The needed class is automatically added.
#'
#' @seealso glide
#'
#' @export

nextButton <- function(class = c("btn", "btn-primary")) {

  class <- paste(union(class, "next-screen"), collapse = " ")

  tags$button(class = class)
}

#' @rdname nextButton
#' @export
nextBtn <- function(inputId, label, icon = NULL, width = NULL, ...) {
  btn <- shiny::actionButton(inputId, label, icon, width, ...)
  btn$attribs$class <- paste(union(btn$attribs$class, "btn-primary next-screen"), collapse = " ")
  btn
}

#' @rdname nextButton
#' @export
prevButton <- function(class = c("btn", "btn-default")) {

  class <- paste(union(class, "prev-screen"), collapse = " ")

  tags$button(class = class)

}

#' @rdname nextButton
#' @export
prevBtn <- function(inputId, label, icon = NULL, width = NULL, ...) {
  btn <- shiny::actionButton(inputId, label, icon, width, ...)
  btn$attribs$class <- paste(union(btn$attribs$class, "btn-default prev-screen"), collapse = " ")
  btn
}

#' Create a glide control only shown on first or last screen
#'
#' @param class CSS classes of the control. The needed class is automatically added.
#' @param ... content of the control
#'
#' @details
#' These controls generate an `<a>` tag, so you can use `href` attributes.
#'
#' `firstButton``is only shown on the first screen of the app, and `finalButton` only
#' on the last screen.
#'
#' @examples
#' firstButton("Go to website", href = "https://example.com", class = "btn btn-primary")
#'
#' @export

firstButton <- function(class = c("btn", "btn-default"), ...) {

  class <- paste(union(class, "first-screen"), collapse = " ")

  shiny::tag("a",
    list(
      class = class,
      ...
    )
  )
}

#' @rdname firstButton
#' @export
firstBtn <- function(inputId, label, icon = NULL, width = NULL, ...) {
  btn <- shiny::actionButton(inputId, label, icon, width, ...)
  btn$attribs$class <- paste(union(btn$attribs$class, "btn-default first-screen"), collapse = " ")
  btn
}


#' @rdname firstButton
#' @export
lastButton <- function(class = c("btn", "btn-success"), ...) {

  class <- paste(union(class, "last-screen"), collapse = " ")

  shiny::tag("a",
    list(
      class = class,
      ...
    )
  )
}

#' @rdname firstButton
#' @export
lastBtn <- function(inputId, label, icon = icon("ok", lib = "glyphicon"), width = NULL, ...) {
  btn <- shiny::actionButton(inputId, label, icon, width, ...)
  btn$attribs$class <- paste(union(btn$attribs$class, "btn-success last-screen"), collapse = " ")
  btn
}
