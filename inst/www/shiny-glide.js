$( document ).ready(function() {

  var root = document.querySelector("#shinyglide");
  var glide = new Glide(root, {
    rewind: false,
    keyboard: false,
    swipeThreshold: false,
    dragThreshold: false
  }).mount();

  var slides = root.querySelectorAll(".glide__slide");
  var next_label = root.getAttribute("data-next-label");
  var previous_label = root.getAttribute("data-previous-label");
  var loading_label = root.getAttribute("data-loading-label");
  var disable_type = root.getAttribute("data-disable-type");
  var prev_control = root.querySelector(".prev-screen");
  var next_control = root.querySelector(".next-screen");

  var prev_detector = root.querySelector(".prev-detector");
  var next_detector = root.querySelector(".next-detector");

  next_control.addEventListener("click", event => glide.go(">"));
  prev_control.addEventListener("click", event => glide.go("<"));

  if (disable_type == "disable") {
    $(prev_detector).on('hide', () => {
      prev_control.setAttribute("disabled", "disabled");
      $(prev_control).addClass("disabled");
    })
    $(prev_detector).on('show', () => {
      prev_control.removeAttribute("disabled");
      $(prev_control).removeClass("disabled");
    })
    $(next_detector).on('hide', () => {
      next_control.setAttribute("disabled", "disabled");
      $(next_control).addClass("disabled");
    })
    $(next_detector).on('show', () => {
      next_control.removeAttribute("disabled");
      $(next_control).removeClass("disabled");
    })

  }
  if (disable_type == "hide") {
    $(prev_detector).on('hide', () => {
      $(prev_control).hide();
    })
    $(prev_detector).on('show', () => {
      $(prev_control).show();
    })
    $(next_detector).on('hide', () => {
      $(next_control).hide();
    })
    $(next_detector).on('show', () => {
      $(next_control).show();
    })
  }

  var busy_screens = [];


  function update_controls() {

    $(prev_control).show();
    $(next_control).show();
    if (disable_type == "disable") {
      $(prev_control).removeClass("disabled");
      $(next_control).removeClass("disabled");
    }

    var visible_slides = $(slides).not('.shinyglide-hidden');
    var slide = visible_slides[glide.index];
    var n_slides = visible_slides.length - 1;

	  var next_condition = slide.getAttribute('data-next-condition');
	  var prev_condition = slide.getAttribute('data-prev-condition');

    $(prev_detector).data("data-display-if-func", null);
    $(next_detector).data("data-display-if-func", null);
    if(prev_condition === null) {
      prev_detector.setAttribute("data-display-if", "true");
    } else {
      prev_detector.setAttribute("data-display-if", prev_condition);
    }
    if(next_condition === null) {
      next_detector.setAttribute("data-display-if", "true");
    } else {
      next_detector.setAttribute("data-display-if", next_condition);
    }

    window.Shiny.shinyapp.$updateConditionals();

    if (glide.index == 0) {
      $(prev_control).hide();
    }
    if (glide.index == n_slides) {
      $(next_control).hide();
    }

    busy_screens = [];
    var next_screenoutputs = $(slide).find("~ li.glide__slide");
    var index = next_screenoutputs
              .toArray()
              .findIndex(element => !$(element).hasClass("shiny-html-output"));
    if (index == -1) {index = 0};
    next_screenoutputs = next_screenoutputs.toArray().slice(0, index);

    $(document).off('shiny:outputinvalidated', '#shinyglide');
    $(document).off('shiny:value', '#shinyglide');
    $(document).on('shiny:outputinvalidated', '#shinyglide', event => {
      if($.inArray(event.target, next_screenoutputs) != -1) {
        busy_screens.push(event.target);
      }
      if (busy_screens.length > 0) {
        next_control.setAttribute("disabled", "disabled");
        $(next_control).find(".next-screen-spinner").addClass("shinyglide-loader");
        $(next_control).find(".next-screen-label").html(loading_label);
      }
    });
    $(document).on('shiny:value', '#shinyglide', event => {
      if($.inArray(event.target, next_screenoutputs) != -1) {
        busy_screens = busy_screens.filter(elem => {elem != event.target});
      }
      if (busy_screens.length == 0) {
        if (!$(next_control).hasClass("disabled")) {
          next_control.removeAttribute("disabled");
        }
        $(next_control).find(".next-screen-spinner").removeClass("shinyglide-loader");
        $(next_control).find(".next-screen-label").html(next_label);
      }
    });

  }

  glide.on('run.before', move => {
    slides.forEach(slide => {
      if (slide.innerHTML == "") {
        $(slide).addClass("shinyglide-hidden");
      } else {
        $(slide).removeClass("shinyglide-hidden");
      }
    })
  })

  glide.on('run.after', move => {
    update_controls();
  });

  // Wait for shiny app to be started
  var wait_ready = function() {
    if (window.Shiny.shinyapp === undefined) {
      var timeout = window.setTimeout(wait_ready, 100);
    } else {
      window.clearTimeout(timeout);
      update_controls();
    }
  }
  wait_ready();

});



