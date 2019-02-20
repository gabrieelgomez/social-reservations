var container = document.querySelector("#mix-wrapper");
var config = {
  controls: {
    toggleDefault: "none"
  },
  animation: {
    duration: 250,
    nudge: true,
    reverseOut: false,
    effects: "fade translateZ(-100px)"
  },
  selectors: {
    target: ".mix-target",
    control: "[data-mixitup-control]"
  }
};
var mixer = mixitup(container, config);
