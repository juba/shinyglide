
class ShinyGlide {

  constructor(root) {

    this.root = root;

    this.glide = null;

    this.slides = root.querySelectorAll(".glide__slide");
    this.next_label = root.getAttribute("data-next-label");
    this.prev_label = root.getAttribute("data-prev-label");
    this.loading_label = root.getAttribute("data-loading-label");
    this.loading_class = root.getAttribute("data-loading-class");
    this.disable_type = root.getAttribute("data-disable-type");
    this.keyboard = root.getAttribute("data-keyboard") != "FALSE";
    this.prev_control = root.getElementsByClassName("prev-screen")[0];
    this.next_control = root.getElementsByClassName("next-screen")[0];
    this.first_control = root.getElementsByClassName("first-screen")[0];
    this.last_control = root.getElementsByClassName("last-screen")[0];
    this.prev_detector = root.getElementsByClassName("prev-detector")[0];
    this.next_detector = root.getElementsByClassName("next-detector")[0];
    this.jump_control = root.querySelectorAll(".jump-screen");

    this.busy_screens = 0;

    this.init(root);

  }

    // Add observers to link detectors and controls
    init_detectors () {

      // Disable controls
      $(this.prev_detector).on('hide', () => {
        this.prev_control.setAttribute("disabled", "disabled");
        this.prev_control.classList.add("disabled");
      });
      $(this.prev_detector).on('show', () => {
        this.prev_control.removeAttribute("disabled");
        this.prev_control.classList.remove("disabled");
      });
      $(this.next_detector).on('hide', () => {
        this.next_control.setAttribute("disabled", "disabled");
        this.next_control.classList.add("disabled");
      });
      $(this.next_detector).on('show', () => {
        this.next_control.removeAttribute("disabled");
        this.next_control.classList.remove("disabled");
      });
      // Hide controls
      if (this.disable_type == "hide") {
          $(this.prev_detector).on('hide', () => { $(this.prev_control).hide(); });
          $(this.prev_detector).on('show', () => { $(this.prev_control).show(); });
          $(this.next_detector).on('hide', () => { $(this.next_control).hide(); });
          $(this.next_detector).on('show', () => { $(this.next_control).show(); });
      }
    }

    // Init glide object
    init_glide() {
      var glide = new Glide(this.root, {
        rewind: false,
        keyboard: this.keyboard,
        dragThreshold: false
      }).mount();

      glide.on('run.before', move => {

        // Don't move if control is disabled
        if (this.next_control.hasAttribute("disabled")) {
          if (move.direction == ">") {
            move.direction = null;
          }
        }
        if (this.prev_control.hasAttribute("disabled")) {
          if (move.direction == "<") {
            move.direction = null;
          }
        }

        this.slides.forEach(slide => {
          if (slide.innerHTML == "") {
            slide.classList.add("shinyglide-hidden");
          } else {
            slide.classList.remove("shinyglide-hidden");
          }
        });
      });

      glide.on('run.after', move => {
        this.update_controls();
      });

      // Resize glides each time a bootstrap tab is shown
      $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        glide._c.Sizes.setupWrapper();
        glide._c.Sizes.setupSlides();
      });


      this.glide = glide;
    }


    // Global init
    init() {

      $(this.prev_control).hide();
      $(this.last_control).hide();

      this.update_labels(this.slides[0]);

      this.next_control.addEventListener("click", event => {
          if (!this.next_control.hasAttribute("disabled")) { this.glide.go(">"); };
      });
      this.prev_control.addEventListener("click", event => {
          if (!this.prev_control.hasAttribute("disabled")) { this.glide.go("<"); };
      });

      this.jump_control.forEach(slide => {
        slide.addEventListener("click", event => {
          var screen_nr = slide.getAttribute("screen") - 1; // starts from 0
          this.glide.go("=" + screen_nr);
        });
      });

      this.init_detectors();
      this.init_glide();

      // Wait for shiny app to be started
      $(document).on("shiny:sessioninitialized", this.root, () => {
        this.update_controls();
        $(document).off("shiny:sessioninitialized", this.root);
      });


    }

    // Update controls enabling conditions
    update_conditions(slide) {

      var next_condition = slide.getAttribute('data-next-condition');
      var prev_condition = slide.getAttribute('data-prev-condition');

      $(this.prev_detector).data("data-display-if-func", null);
      $(this.next_detector).data("data-display-if-func", null);
      if (prev_condition === null) {
        this.prev_detector.setAttribute("data-display-if", "true");
      } else {
        this.prev_detector.setAttribute("data-display-if", prev_condition);
      }
      if (next_condition === null) {
        this.next_detector.setAttribute("data-display-if", "true");
      } else {
        this.next_detector.setAttribute("data-display-if", next_condition);
      }

      window.Shiny.shinyapp.$updateConditionals();
    }

    // Get current slide next label
    slide_next_label(slide) {
      var screen_next_label = slide.getAttribute('data-next-label');
      var label = screen_next_label !== null ? screen_next_label : this.next_label;
      return(label);
    }

    // Get current slide prev label
    slide_prev_label(slide) {
      var screen_prev_label = slide.getAttribute('data-prev-label');
      var label = screen_prev_label !== null ? screen_prev_label : this.prev_label;
      return(label);
    }


    // Update controls labels
    update_labels(slide) {

      $(this.next_control).html(this.slide_next_label(slide));
      $(this.prev_control).html(this.slide_prev_label(slide));

    }


    // Update loading status of next control
    update_loading_control(slide) {

      if (this.busy_screens > 0) {
        this.next_control.setAttribute("disabled", "disabled");
        this.next_control.classList.add("disabled");
        $(this.next_control).addClass(this.loading_class);
        $(this.next_control).html(this.loading_label);
      }

      if (this.busy_screens == 0) {
        if (!($(this.next_detector).css("display") == "none")) {
          this.next_control.removeAttribute("disabled");
          this.next_control.classList.remove("disabled");
        }
        $(this.next_control).removeClass(this.loading_class);
        $(this.next_control).html(this.slide_next_label(slide));
        $(document).off('shiny:outputinvalidated', this.root);
        $(document).off('shiny:value', this.root);
      }

    }


    // Manage list of loading screen siblings
    update_loading_screens(slide) {

      this.busy_screens = 0;

      var next_screenoutputs = $(slide).find("~ li.glide__slide");
      var index = next_screenoutputs
                  .toArray()
                  .findIndex(element => !$(element).hasClass("shiny-html-output"));
      if (index == -1) { index = 0 }
      next_screenoutputs = next_screenoutputs.toArray().slice(0, index);

      if (next_screenoutputs.length > 0) {
        $(document).on('shiny:outputinvalidated', this.root, event => {
          if ($.inArray(event.target, next_screenoutputs) != -1) {
            this.busy_screens += 1;
          }
          this.update_loading_control(slide);
        });
        $(document).on('shiny:value', this.root, event => {
          if ($.inArray(event.target, next_screenoutputs) != -1) {
            if(this.busy_screens > 0) this.busy_screens -= 1;
          }
          this.update_loading_control(slide);
        });
      }

    }


    // Update controls after each slide change
    update_controls() {

      // default controls status
      $(this.prev_control).show();
      $(this.next_control).show();
      if (this.disable_type == "disable") {
        this.prev_control.classList.remove("disabled");
        this.next_control.classList.remove("disabled");
      }
      $(this.first_control).hide();
      $(this.last_control).hide();

      var visible_slides = $(this.slides).not('.shinyglide-hidden');
      var slide = visible_slides[this.glide.index];
      var n_slides = visible_slides.length - 1;

      this.update_conditions(slide);
      this.update_labels(slide);

      if (this.glide.index == 0) {
        $(this.prev_control).hide();
        $(this.first_control).show();
      }
      if (this.glide.index == n_slides) {
        $(this.next_control).hide();
        $(this.last_control).show();
      }

      this.update_loading_screens(slide);

    }

  }

// Only run setup once
var shinyglide_setup_has_run = false;


function setup() {

    if (shinyglide_setup_has_run) { return; }

    $(".shinyglide").each(function(index) {
	new ShinyGlide(this);
    });

    // If the glide is in a shiny modal and it is not shown yet,
    // wait for it to be shown otherwise dimensions are incorrect
    $(document).on('shiny:idle', e => {
	var modal_wrapper = document.getElementById('shiny-modal-wrapper');
	var shiny_modal = $(modal_wrapper).find("#shiny-modal");
	shiny_modal.on("shown.bs.modal", () => {
	    shiny_modal.find('.shinyglide').each(function(i, el)  {
		new ShinyGlide(el);
	    });
	});
    });

    shinyglide_setup_has_run = true;
    $(document).off("shiny:message");
}


// When an observer is running, the "ready" event is not fired when
// this JavaScript is run, so we add a listener to shiny:message and
// keep whichever comes first

$(document).on("shiny:message", e => {
    setup();
});

$(function () {
    setup();
});



