# shinyglide (development version)

- Fix regression on conditional controls not updated when glide inserted with `InsertUI` (#36, @JulianoAtto)
- New `start_at` argument to `glide()` to allow to start at a specific glide (#43, @analytichealth)

# shinyglide 0.1.4

- Fix issue with glides not working in modals (#39, @analytichealth)
- Fix conditional controls not updated when glide inserted with `InsertUI` (#36, @JulianoAtto)
- Resize glides when parent is resized (#30, @ismirsehregal)
- Add `swipe` option to `glide` function to disable swiping navigation
- Fix issue when slide reloaded from renderUI (thanks @ChristianKahmann)
- Migrate development to packer
- Update Glide.js to 3.6.0

# shinyglide 0.1.3

- Add current index Shiny input (thanks @gueyenono)
- Style default controls layout with flex instead of bootstrap
- Add fix for collapsible sidebar in shinydashboard (thanks @nklepeis)
- Add `keyboard` option to `glide` function to disable keyboard navigation
- Fix incorrect glides dimensions in tabs (thanks @LeonhardBakker)
- Limit tab key navigation to the current visible slide (thanks @Chaskelr)

# shinyglide 0.1.2

- Fix typo which prevented left arrow disabling when prev_condition is not met
- Fix conflict with slickR (thanks @JonP-16)

# shinyglide 0.1.1

- First version
