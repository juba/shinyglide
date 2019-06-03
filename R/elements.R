#' @export

glide <- function(...,
  next_label = 'Next <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>',
  previous_label = '<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span> Back',
  loading_label = "Loading",
  loading_class = "shinyglide-loader",
  disable_type = c("disable", "hide"),
  height = "100%",
  custom_controls = NULL) {

  css <- paste0("height: ", height, ";")

  tagList(
    tags$div(id = "shinyglide", class = "glide",
            `data-next-label` = next_label,
            `data-prev-label` = previous_label,
            `data-loading-label` = loading_label,
            `data-disable-type` = disable_type,
      tags$div(class = "glide__track", `data-glide-el` = "track",
        tags$ul(class = "glide__slides", style = css,
          list(...)
        ),
        if(is.null(custom_controls)) {
          glideControls(previous_label, next_label)
        } else {
          custom_controls
        },
        glideDetectors()
      )
    ),
    glideLib(),
    shinyglideLib()
  )

}



#' @export

screen <- function(...,
  next_label = NULL,
  prev_label = NULL,
  next_condition = NULL,
  prev_condition = NULL) {

  shiny::tag("li",
    list(
      class = "glide__slide",
      `data-prev-label` = prev_label,
      `data-next-label` = next_label,
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


#' @export

glideDetectors <- function() {
  tagList(
    tags$span(class = "shinyglide-detector next-detector"),
    tags$span(class = "shinyglide-detector prev-detector")
  )
}


#' @export

nextButton <- function(label = 'Next <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>') {
  tags$button(
    class="btn btn-primary next-screen",
    tags$span(class = "next-screen-spinner"),
    tags$span(class = "next-screen-label",
      HTML(label)
    )
  )
}


#' @export

prevButton <- function(label = '<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span> Back') {
  tags$button(
    class="btn btn-default prev-screen",
    HTML(label)
  )
}


#' @export

firstButton <- function(...) {
  shiny::tag("button",
    list(
      class="btn btn-default first-screen",
      ...
    )
  )
}


#' @export

lastButton <- function(...) {
  shiny::tag("button",
    list(
      class="btn btn-default last-screen",
      ...
    )
  )
}




