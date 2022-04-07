spawn_scroll:
  type: item
  material: feather
  display name: <&6>Spawn Scroll
  data:
    recipe_book_category: travel.scroll
  lore:
  - "<&a>-------------"
  - "<&e>Right Click while Holding"
  - "<&e>Returns you to Spawn"
  - "<&c>Incapable of crossing dimensions"
  - "<&a>-------------"
  flags:
    right_click_script: spawn_task
    type: scroll
  mechanisms:
    custom_model_data: 200
  recipes:
    1:
      type: shapeless
      input: ink_sac|papyrus|gold_ingot

spawn_crystal:
  type: item
  material: feather
  display name: <&6>Spawn Crystal
  data:
    recipe_book_category: travel.crystal
  lore:
  - "<&a>-------------"
  - "<&e>Right Click while Holding"
  - "<&e>Returns you to Spawn"
  - "<&a>-------------"
  flags:
    right_click_script: return_task
    type: crystal
  mechanisms:
    custom_model_data: 103
  recipes:
    1:
      type: shaped
      input:
      - magical_pylon|air|magical_pylon
      - air|gold_block|air
      - magical_pylon|air|magical_pylon

return_task:
  type: task
  debug: false
  script:
    - define type <context.item.flag[type]>
    - if <[type]> == scroll:
      - if <server.worlds.get[1]> != <player.location.world>:
        - narrate "<&c>This item lacks the power for cross dimensional travel"
        - stop
    - take iteminhand
    - run teleportation_animation_run def:<player.location.world.spawn_location>