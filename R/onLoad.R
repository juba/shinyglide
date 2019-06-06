#' Adds the content of www to shinyglide/
#'
#' @importFrom shiny addResourcePath registerInputHandler
#'
#' @noRd

.onLoad <- function(...) {
  shiny::addResourcePath('shinyglide', system.file('www', package = 'shinyglide'))
}
