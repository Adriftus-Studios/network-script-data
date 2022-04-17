back_crystal:
  type: item
  material: feather
  display name: <&c>Back Crystal
  data:
    recipe_book_category:  travel.crystal
  lore:
    - "<&e>--------------------"
    - "<&e>Return to your last location"
    - "<&e>--------------------"
  flags:
    right_click_script:
      - back_execute
    callback: back_execute
    type: crystal
  mechanisms:
    custom_model_data: 100
  recipes:
    1:
      type: shaped
      input:
      - magical_pylon|air|magical_pylon
      - air|redstone_block|air
      - magical_pylon|air|magical_pylon

back_scroll:
  type: item
  material: feather
  display name: <&c>Back Scroll
  data:
    recipe_book_category: travel.scroll
  lore:
    - "<&e>--------------------"
    - "<&e>Return to your last location"
    - "<&c>Incapable of long distances"
    - "<&e>--------------------"
  flags:
    right_click_script:
      - back_execute
    callback: back_execute
    type: scroll
  mechanisms:
    custom_model_data: 201
  recipes:
    1:
      type: shapeless
      input: ink_sac|papyrus|redstone_block

back_item_tracker:
  type: world
  debug: false
  events:
    # Disabled due to teleportation animations
    #on player teleports bukkit_priority:MONITOR:
      #- flag <player> last_location:<context.origin>
    on player dies bukkit_priority:MONITOR:
      - flag <player> last_location:<player.location>

back_execute:
  type: task
  debug: false
  script:
    - if !<player.has_flag[last_location]>:
      - narrate "<&c>You have no location to return to"
      - stop
    - define type <context.item.flag[type]>
    - if <[type]> == scroll:
      - if <player.flag[last_location].world> != <player.location.world>:
        - narrate "<&c>This item lacks the power for cross dimensional travel"
        - stop
      - if <player.flag[last_location].distance[<player.location>]> > 2000:
        - narrate "<&c>This item lacks the power for distances grater than 2000 blocks"
        - stop
    - take iteminhand
    - run totem_test def:101
    - wait 2s
    - ~run teleportation_animation_run def:<player.flag[last_location]>
    - wait 1t
    - flag <player> last_location:!