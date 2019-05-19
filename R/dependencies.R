glideLib <- function() {
  htmltools::htmlDependency(
    name = "glide",
    version = "3.3.0",
    src = c(href = "shinyglide/glide"),
    stylesheet = "dist/css/glide.core.min.css",
    script = "dist/glide.min.js"
  )
}

shinyglideLib <- function() {
  htmltools::htmlDependency(
    name = "shinyglide",
    version = "0.1",
    src = c(href = "shinyglide"),
    script = "shiny-glide.js",
    stylesheet = "shiny-glide.css"
  )
}

