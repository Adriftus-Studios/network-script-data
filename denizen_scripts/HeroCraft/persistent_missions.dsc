missions_persistent_herocraft:
  type: task
  debug: false
  data:
    mission_icons:
      1: mission_1_icon
      2: mission_2_icon
      3: mission_3_icon
  script:
    - determine <list[mission_<player.flag[missions.active.persistent]>_icon]>

mission_1_icon:
  type: item
  debug: false
  material: feather
  display name: <&6>Create a Campsite
  lore:
    - <&e>Place your Campfire
    - <&e>Create a Campsite!
    - <&a>Campsites are temporary claims.

herocraft_mission_1:
  type: task
  debug: false
  script:
    - give tpa_crystal|campfire|cooked_beef[quantity=24]

mission_2_icon:
  type: item
  debug: false
  material: feather
  display name: <&6>Craft Return Scroll
  lore:
    - <&e>Craft a <&b>Return Scroll
    - <&a>Check The Main Menu For Recipes!
    - <&7>Use your <&keybind[key.inventory]> key!

herocraft_mission_2:
  type: task
  debug: false
  script:
    - give papyrus|lapis_lazuli|glow_ink_sac

mission_3_icon:
  type: item
  debug: false
  material: feather
  display name: <&6>Complete Daily/Weekly/Monthly
  lore:
    - <&e>Complete a Mission!
    - <&a>Get Paid!
    - <&7>Let's goooo!

herocraft_mission_3:
  type: task
  debug: false
  script:
    - give leather_helmet|leather_chestplate|leather_leggings|leather_boots|stone_sword|stone_pickaxe|stone_axe|stone_hoe
