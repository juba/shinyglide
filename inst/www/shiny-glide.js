$( document ).ready(function() {

  var glide, root, slides,
      next_label, prev_label, loading_label, disable_type,
      prev_control, next_control, first_control, last_control,
      prev_detector, next_detector;

  var busy_screens = [];


  function init(root) {

    slides = root.querySelectorAll(".glide__slide");
    next_label = root.getAttribute("data-next-label");
    prev_label = root.getAttribute("data-prev-label");
    loading_label = root.getAttribute("data-loading-label");
    disable_type = root.getAttribute("data-disable-type");

    prev_control = root.getElementsByClassName("prev-screen")[0];
    next_control = root.getElementsByClassName("next-screen")[0];

    // Hide previous control at startup
    $(prev_control).hide();

    first_control = root.getElementsByClassName("first-screen")[0];
    last_control = root.getElementsByClassName("last-screen")[0];

    prev_detector = root.getElementsByClassName("prev-detector")[0];
    next_detector = root.getElementsByClassName("next-detector")[0];

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

    glide = new Glide(root, {
      rewind: false,
      keyboard: false,
      swipeThreshold: false,
      dragThreshold: false
    }).mount();

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

  }

  function update_controls() {

    // default controls status
    $(prev_control).show();
    $(next_control).show();
    if (disable_type == "disable") {
      $(prev_control).removeClass("disabled");
      $(next_control).removeClass("disabled");
    }
    $(first_control).hide();
    $(last_control).hide();

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

	  var screen_next_label = slide.getAttribute('data-next-label');
	  var screen_prev_label = slide.getAttribute('data-prev-label');

    var next_label_span = $(next_control).find(".next-screen-label");
    var target = next_label_span.length > 0 ? next_label_span : $(next_control);
    if (screen_next_label !== null) {
      target.html(screen_next_label);
    }	else {
      target.html(next_label);
    }
    if (screen_prev_label !== null) {
      $(prev_control).html(screen_prev_label);
    }	else {
      $(prev_control).html(prev_label);
    }

    window.Shiny.shinyapp.$updateConditionals();

    if (glide.index == 0) {
      $(prev_control).hide();
      $(first_control).show();
    }
    if (glide.index == n_slides) {
      console.log(last_control);
      $(next_control).hide();
      $(last_control).show();
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

  // Source : https://stackoverflow.com/questions/38881301/observe-mutations-on-a-target-node-that-doesnt-exist-yet
  function waitForAddedNode(params) {
    new MutationObserver(function(mutations) {
        var el = document.getElementById(params.id);
        if (el) {
            this.disconnect();
            params.done(el);
        }
    }).observe(params.parent || document, {
        subtree: !!params.recursive,
        childList: true,
    });
  }


  root = document.getElementById("shinyglide");

  // If root doesn't exist yet, wait for it
  // Useful if glide is in a modal
  if (root === null) {

    waitForAddedNode({
      id: 'shinyglide',
      parent: document.querySelector('body'),
      recursive: false,
      done: function(el) {
        root = el;
        var modal = $(el).parents('#shiny-modal');
        if (modal.length > 0) {
          // If the glide is in a modal, wait for it to
          // be shown otherwise dimensions are incorrect
          modal.on("shown.bs.modal", () => {
            init(root);
            update_controls();
            modal.off("shown.bs.modal");
          })
        } else {
          init(root);
          update_controls();
        }
      }
    });

  } else {

    init(root);
    // Wait for shiny app to be started
    $(document).on("shiny:recalculated", '#shinyglide', () => {
      update_controls();
      $(document).off("shiny:recalculated", '#shinyglide');
    });

  }

});



