#' @export

screenOutput <- function (
  outputId,
  next_condition = NULL,
  prev_condition = NULL,
  ...) {

  shiny::tag("li",
    list(
      id = outputId,
      `data-prev-condition` = prev_condition,
      `data-next-condition` = next_condition,
      class = "glide__slide shiny-html-output",
      list(...)
    )
  )

}
