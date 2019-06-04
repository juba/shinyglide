#' @export

glide <- function(...,
  next_label = "Next",
  next_label_icon = shiny::icon("chevron-right", lib = "glyphicon"),
  previous_label = "Back",
  previous_label_icon = shiny::icon("chevron-left", lib = "glyphicon"),
  loading_label = "Loading",
  loading_class = "shinyglide-loader",
  disable_type = c("disable", "hide"),
  height = "100%",
  custom_controls = NULL,
  controls_position = c("bottom", "top")) {

  css <- paste0("height: ", height, ";")
  disable_type <- match.arg(disable_type)
  controls_position <- match.arg(controls_position)

  next_label <- paste(next_label, next_label_icon)
  previous_label <- paste(previous_label_icon, previous_label)

  controls <- if(is.null(custom_controls)) {
    glideControls(previous_label, next_label)
  } else {
    custom_controls
  }

  tagList(
    tags$div(id = "shinyglide", class = "glide",
            `data-next-label` = next_label,
            `data-prev-label` = previous_label,
            `data-loading-label` = loading_label,
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



#' @export

screen <- function(...,
  next_label = NULL,
  next_label_icon = NULL,
  prev_label = NULL,
  prev_label_icon = NULL,
  next_condition = NULL,
  prev_condition = NULL) {

  next_label <- paste(next_label, next_label_icon)
  prev_label <- paste(prev_label_icon, prev_label)

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

nextButton <- function(
  label = "Next",
  label_icon = shiny::icon("chevron-right", lib = "glyphicon")) {

  label <- paste(label, label_icon)

  tags$button(
    class="btn btn-primary next-screen",
    tags$span(class = "next-screen-spinner"),
    tags$span(class = "next-screen-label",
      HTML(label)
    )
  )
}


#' @export

prevButton <- function(
  label = "Back",
  label_icon = shiny::icon("chevron-left", lib = "glyphicon")) {

  label <- paste(label_icon, label)

  tags$button(
    class="btn btn-default prev-screen",
    style="display: none",
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
      class="btn btn-success last-screen",
      style="display: none",
      ...
    )
  )
}




