#' Create a screen output element
#'
#' Insert a screen output element in a shiny app UI. This must be used with a
#' `renderUI` reactive expression in the app server.
#'
#' **Important :** for this to work, you have to add a
#' `outputOptions(output, id, suspendWhenHidden = FALSE)` in your app
#' server. See example.
#'
#' @param outputId output variable to read the value from
#' @param next_label specific label of the "next" control for this screen. If `NULL`,
#' use the default one for the current glide.
#' @param prev_label specific label of the "back" control for this screen. If `NULL`,
#' use the default one for the current glide.
#' @param next_condition condition for the "next" control to be enabled. Same syntax
#' as `shiny::conditionalPanel`.
#' @param prev_condition condition for the "back" control to be enabled. Same syntax
#' as `shiny::conditionalPanel`.
#' @param class screen CSS classes. `glide__slide` is automatically added.
#' @param ... other arguments to pass to the container tag function.
#'
#' @examples
#' ## Only run examples in interactive R sessions
#' if (interactive()) {
#'
#' ui <- fixedPage(
#'  h3("Simple shinyglide app"),
#'  glide(
#'     screen(
#'       p("First screen."),
#'     ),
#'     screenOutput("screen"),
#'     screen(
#'       p("Final screen."),
#'     )
#'   )
#' )
#'
#' server <- function(input, output, session) {
#'
#'   output$screen <- renderUI({
#'     p("Second screen.")
#'   })
#'   outputOptions(output, "screen", suspendWhenHidden = FALSE)
#'
#' }
#'
#' shinyApp(ui, server)
#'
#' }
#'
#'
#' @export

screenOutput <- function (
  outputId,
  next_label = NULL,
  prev_label = NULL,
  next_condition = NULL,
  prev_condition = NULL,
  class = NULL,
  ...) {

  class <- paste(union(class, c("glide__slide", "shiny-html-output")), collapse = " ")

  shiny::tag("li",
    list(
      id = outputId,
      class = class,
      `data-prev-label` = prev_label,
      `data-next-label` = next_label,
      `data-prev-condition` = prev_condition,
      `data-next-condition` = next_condition,
      class = class,
      list(...)
    )
  )

}
