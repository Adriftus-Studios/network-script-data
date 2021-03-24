standard_back_button:
  type: item
  debug: false
  material: barrier
  display name: <&c>Back
  flags:
    action: back

standard_close_button:
  type: item
  debug: false
  material: barrier
  display name: <&c>Close Menu
  flags:
    action: close

standard_accept_button:
  type: item
  debug: false
  material: paper
  mechanisms:
    custom_model_data: 1
  display name: <&a>Accept
  flags:
    action: accept

standard_filler:
  type: item
  debug: false
  material: gray_stained_glass_pane
  mechanisms:
    custom_model_data: 1
  display name: <&a>
  flags:
    filler: filler
