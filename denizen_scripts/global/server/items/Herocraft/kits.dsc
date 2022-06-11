iron_armor_pack:
  type: item
  material: feather
  display name: <&f>Iron Kit
  flags:
    right_click_script: iron_armor_pack_give
  mechanisms:
    custom_model_data: 13

iron_armor_pack_give:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - stop if:<bungee.server.equals[hub]<
    - wait 1t
    - take iteminhand
    - give iron_helmet|iron_chestplate|iron_leggings|iron_boots|iron_sword

diamond_armor_pack:
  type: item
  material: feather
  display name: <&b>Diamond Kit
  flags:
    right_click_script: diamond_armor_pack_give
  mechanisms:
    custom_model_data: 14

diamond_armor_pack_give:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - stop if:<bungee.server.equals[hub]>
    - wait 1t
    - take iteminhand
    - give diamond_helmet|diamond_chestplate|diamond_leggings|diamond_boots|diamond_sword
