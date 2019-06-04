default_next_label <- paste('Next', shiny::icon("chevron-right", lib = "glyphicon"))
default_prev_label <- paste(shiny::icon("chevron-left", lib = "glyphicon"), 'Back')

#' @export

glide <- function(...,
  next_label = default_next_label,
  previous_label = default_prev_label,
  loading_label = "Loading",
  loading_class = "shinyglide-loader",
  disable_type = c("disable", "hide"),
  height = "100%",
  custom_controls = NULL) {

  css <- paste0("height: ", height, ";")
  disable_type <- match.arg(disable_type)

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

nextButton <- function(label = default_next_label) {
  tags$button(
    class="btn btn-primary next-screen",
    tags$span(class = "next-screen-spinner"),
    tags$span(class = "next-screen-label",
      HTML(label)
    )
  )
}


#' @export

prevButton <- function(label = default_prev_label) {
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




