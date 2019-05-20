$( document ).ready(function() {

  var root = document.querySelector("#shinyglide");
  var glide = new Glide(root, {
    rewind: false,
    keyboard: false
  }).mount();

  var slides = root.querySelectorAll(".glide__slide");
  var disable_type = root.getAttribute("data-disable-type");
  var prev_control = root.querySelector(".prev-slide");
  var next_control = root.querySelector(".next-slide");

  next_control.addEventListener("click", event => glide.go(">"));
  prev_control.addEventListener("click", event => glide.go("<"));

  function update_controls() {

    $(prev_control).show();
    $(next_control).show();
    var slide = slides[glide.index];

	  var next_condition = slide.getAttribute('data-next-condition');
	  var prev_condition = slide.getAttribute('data-prev-condition');
	  if (prev_condition !== null) {
	    $(prev_control).data("data-display-if-func", null);
      prev_control.setAttribute("data-display-if", prev_condition);
	  }
	  if (next_condition !== null) {
	    $(next_control).data("data-display-if-func", null);
      next_control.setAttribute("data-display-if", next_condition);
	  }
	  if (prev_condition !== null || next_condition !== null) {
      window.Shiny.shinyapp.$updateConditionals();
	  }

    function update_disable_status(el) {
      var shown = $(el).attr("style") !== "display: none;";
	    if (shown) {
	      $(el).removeClass("disabled");
	    } else {
	      $(el).show();
	      $(el).addClass("disabled");
	    }
    }

	  if (disable_type == "disable") {
	    $(next_control).addClass("always-shown");
	    $(prev_control).addClass("always-shown");
	    update_disable_status(next_control);
	    update_disable_status(prev_control);
	    $(document).off('shiny:conditional');
	    $(document).on('shiny:conditional', () => {
	       if (glide.index < (slides.length - 1)) {
	        update_disable_status(next_control);
	       }
	       if (glide.index > 0) {
	        update_disable_status(prev_control);
	       }
	    })
	  }

    if (glide.index == 0) {
      $(prev_control).removeClass("always-shown");
      $(prev_control).hide();
    }
    if (glide.index == (slides.length - 1)) {
      $(next_control).removeClass("always-shown");
      $(next_control).hide();
    }
  }

  glide.on('run.after', function () {
    update_controls();
  });

  $(prev_control).hide();

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



