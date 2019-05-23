#' @export

glide <- function(...,
  next_label = 'Next <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>',
  previous_label = '<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span> Previous',
  loading_label = "Loading",
  disable_type = c("hide", "disable"),
  height = "100%",
  controls = TRUE) {

  css <- paste0("height: ", height, ";")

  tagList(
    tags$div(id = "shinyglide", class = "glide",
            `data-next-label` = next_label,
            `data-previous-label` = previous_label,
            `data-loading-label` = loading_label,
            `data-disable-type` = disable_type,
      tags$div(class = "glide__track", `data-glide-el` = "track",
        tags$ul(class = "glide__slides", style = css,
          list(...)
        ),
        if (controls) glideControls(previous_label, next_label),
        glideDetectors()
      )
    ),
    glideLib(),
    shinyglideLib()
  )

}



#' @export

screen <- function(...,
  next_condition = NULL,
  prev_condition = NULL) {

  shiny::tag("li",
    list(
      class = "glide__slide",
      `data-prev-condition` = prev_condition,
      `data-next-condition` = next_condition,
      list(...)
    )
  )
}


#' @export

glideControls <- function(previous_label, next_label) {
  fluidRow(
    column(width = 6,
      prevButton(previous_label)
    ),
    column(width = 6, class = "text-right",
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

#' @export

nextButton <- function(label = 'Next <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>') {
  tags$button(
    class="btn btn-lg btn-primary next-screen",
    span(class = "next-screen-spinner"),
    span(class = "next-screen-label",
      HTML(label)
    )
  )
}


#' @export

prevButton <- function(label = '<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span> Previous') {
  tags$button(
    class="btn btn-lg btn-default prev-screen",
    HTML(label)
  )
}
