#' @export

glide <- function(...,
  next_label = "Next",
  previous_label = "Previous",
  disable_type = "hide") {

  tagList(
    tags$div(id = "shinyglide", class = "glide", `data-disable-type` = disable_type,
      tags$div(class = "glide__track", `data-glide-el` = "track",
        tags$ul(class = "glide__slides",
          list(...)
        ),
        glideControls(previous_label, next_label)
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

#' @export

nextButton <- function(label = "Next") {
  tags$a(
    class="btn btn-primary next-slide",
    HTML(paste(label, '<span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>'))
  )
}


#' @export

prevButton <- function(label = "Previous") {
  tags$a(
    class="btn btn-default prev-slide",
    HTML(paste('<span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span> ', label))
  )
}
