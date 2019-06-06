#' @export

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

nextButton <- function(
    label = paste("Next", shiny::icon("chevron-right", lib = "glyphicon"))
  ) {

  tags$button(
    class="btn btn-primary next-screen",
    HTML(label)
  )
}


#' @export

prevButton <- function(
    label = paste(shiny::icon("chevron-left", lib = "glyphicon"), "Back")
  ) {

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
      class="btn btn-success last-screen",
      style="display: none",
      ...
    )
  )
}




