return_scroll:
  type: item
  material: feather
  display name: <&6>Return Scroll
  data:
    recipe_book_category: travel.scroll
  lore:
    - <&a><&l>Consumed on Use
    - <&a>-------------
    - <&e>Right Click while Holding
    - <&e>Left Click Saves Location
    - <&c>Incapable of long distances
    - <&a>-------------
  flags:
    right_click_script: return_task
    left_click_script: return_crystal_save_location
    type: scroll
  mechanisms:
    custom_model_data: 200
  recipes:
    1:
      type: shapeless
      input: ink_sac|papyrus|lapis_lazuli
    2:
      type: shapeless
      input: glow_ink_sac|papyrus|lapis_lazuli

return_crystal:
  type: item
  material: feather
  display name: <&6>Return Crystal
  data:
    recipe_book_category: travel.crystal
  lore:
    - <&a><&l>Consumed on Use
    - <&a>-------------
    - <&e>Right Click while Holding
    - <&e>Left Click Saves Location
    - <&a>-------------
  flags:
    right_click_script: return_task
    left_click_script: return_crystal_save_location
    type: crystal
  mechanisms:
    custom_model_data: 101
  recipes:
    1:
      type: shaped
      input:
      - magical_pylon|air|magical_pylon
      - air|lapis_block|air
      - magical_pylon|air|magical_pylon

return_task:
  type: task
  debug: false
  script:
    - if <player.has_flag[pvp]>:
      - narrate "<&c>You cannot teleport when in PvP."
      - stop
    - define type <context.item.flag[type]>
    - if !<context.item.has_flag[tpa_destination]>:
      - narrate "<&c>This item has no saved location!"
      - stop
    - if <bungee.server> != <context.item.flag[server].if_null[herocraft]>:
      - narrate "<&c>The item lacks the ability to cross the multi-verse..."
      - stop
    - if <[type]> == scroll:
      - if <context.item.flag[tpa_destination].world> != <player.location.world>:
        - narrate "<&c>This item lacks the power for cross dimensional travel"
        - stop
      - if <context.item.flag[tpa_destination].distance[<player.location>]> > 2000:
        - narrate "<&c>This item lacks the power for distances greater than 2000 blocks"
        - stop
    - take iteminhand
    - if <[type]> == crystal:
      - run totem_test def:101
    - wait 2s
    - run teleportation_animation_run def:<context.item.flag[tpa_destination]>

return_crystal_save_location:
  type: task
  debug: false
  script:
    - wait 1t
    - if <context.item.has_flag[tpa_destination]> && !<player.has_flag[overwrite_destination]>:
      - flag <player> overwrite_destination:<context.item.flag[tpa_destination]>
      - narrate "<&c>This item has a destination already!"
      - narrate "<&e>Left click again to overwrite."
      - flag player overwrite_destination:<context.item.flag[tpa_destination]> expire:10s
      - stop
    - if <player.has_flag[overwrite_destination]> && <player.flag[overwrite_destination]> != <context.item.flag[tpa_destination]>:
      - narrate "<&c>This item has a destination already!"
      - narrate "<&e>Left click again to overwrite."
      - flag player overwrite_destination:<context.item.flag[tpa_destination]> expire:10s
      - stop
    - inventory flag tpa_destination:<player.location> slot:hand
    - narrate "<&a>Crystal Destination set to<&co> <player.location.simple>"
    - inventory adjust slot:hand "lore:<context.item.script.parsed_key[lore].include[<&a>Location<&co> <player.location.simple>]>" o:<player.inventory>