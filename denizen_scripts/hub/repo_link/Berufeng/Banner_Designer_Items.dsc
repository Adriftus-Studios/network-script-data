#=====================================================================#
#   ITEMS                                                             #
#=====================================================================#
Banner_Token_Test:
  type: item
  debug: false
  material: gold_nugget
  display name: <dark_gray><bold>[Banner Token: Test]
  lore:
  - Insert in a Banner Designer to enable Testing Mode.

Banner_Token_Town:
  type: item
  debug: false
  material: iron_nugget
  mechanisms:
    custom_model_data: 32
  display name: <blue><bold>[Banner Token: Town]
  lore:
  - Insert in a Banner Designer to edit your town's flag.

Banner_Token_Nation:
  type: item
  debug: false
  material: iron_nugget
  mechanisms:
    custom_model_data: 33
  display name: <gold><bold>[Banner Token: Nation]
  lore:
  - Insert in a Banner Designer to edit your nation's flag.

Banner_Token_Personal:
  type: item
  debug: false
  material: iron_nugget
  mechanisms:
    custom_model_data: 31
  display name: <red><bold>[Banner Token: Personal]
  lore:
  - Insert in a Banner Designer to design your Personal Emblem.

Banner_Token_Single:
  type: item
  debug: false
  material: iron_nugget
  mechanisms:
    custom_model_data: 30
  display name: <dark_gray><bold>[Banner Token: Single Use]
  lore:
  - Insert in a Banner Designer to create a single custom banner.

Banner_Item_Town:
  type: item
  debug: false
  material: light_blue_banner
  display name: <blue><bold>[Town Flag Banner]
  mechanisms:
    hides: ALL
    patterns: blue/STRIPE_TOP|blue/STRIPE_CENTER|light_blue/TRIANGLES_BOTTOM|light_blue/BORDER|light_blue/GRADIENT|blue/GRADIENT_UP
  lore:
  - Use: Place a Town Flag anywhere in your town!

Banner_Item_Nation:
  type: item
  debug: false
  material: orange_banner
  display name: <gold><bold>[National Flag Banner]
  mechanisms:
    hides: ALL
    patterns: yellow/STRIPE_LEFT|yellow/STRIPE_RIGHT|yellow/STRIPE_DOWNRIGHT|orange/TRIANGLES_TOP|orange/TRIANGLES_BOTTOM|orange/BORDER|yellow/GRADIENT_UP
  lore:
  - Use: Place a National Flag anywhere in your nation!

Banner_Item_Personal:
  type: item
  debug: false
  material: red_banner
  display name: <red><bold>[Personal Emblem Banner]
  mechanisms:
    hides: ALL
    patterns: orange/STRIPE_TOP|orange/STRIPE_MIDDLE|orange/STRIPE_RIGHT|red/HALF_HORIZONTAL_MIRROR|orange/STRIPE_LEFT|red/TRIANGLES_TOP|red/TRIANGLES_BOTTOM|red/BORDER|red/GRADIENT_UP
  lore:
  - Use: Place on the ground to display your Personal Emblem!

#=====================================================================#
#    UI ELEMENTS                                                      #
#=====================================================================#
Banner_Designer_Complete_Button:
  type: item
  debug: false
  material: paper
  mechanisms:
    custom_model_data: 1
  display name: <green>Complete

Banner_Designer_Reset_Button:
  type: item
  debug: false
  material: paper
  mechanisms:
    custom_model_data: 5
  display name: <yellow>Reset

Banner_Designer_Exit_Button:
  type: item
  debug: false
  material: barrier
  display name: <dark_red>Exit

Banner_Designer_Arrow_Green:
  type: item
  debug: false
  material: paper
  mechanisms:
    custom_model_data: 6

Banner_Designer_Arrow_Blue:
  type: item
  debug: false
  material: paper
  mechanisms:
    custom_model_data: 7