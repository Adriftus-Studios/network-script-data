town_return_crystal:
  type: item
  material: feather
  display name: <&c>Town Crystal
  data:
    recipe_book_category:  travel.crystal
  lore:
    - "<&e>--------------------"
    - "<&e>Teleport to Town Spawn"
    - "<&e>--------------------"
  flags:
    right_click_script:
      - town_return_execute
    type: crystal
  mechanisms:
    custom_model_data: 103
  recipes:
    1:
      type: shaped
      input:
      - magical_pylon|air|magical_pylon
      - air|iron_block|air
      - magical_pylon|air|magical_pylon

town_return_scroll:
  type: item
  material: feather
  display name: <&c>Town Scroll
  data:
    recipe_book_category: travel.scroll
  lore:
    - "<&e>--------------------"
    - "<&e>Teleport to Town Spawn"
    - "<&c>Incapable of long distances"
    - "<&e>--------------------"
  flags:
    right_click_script:
      - town_return_execute
    type: scroll
  mechanisms:
    custom_model_data: 200
  recipes:
    1:
      type: shapeless
      input: ink_sac|papyrus|iron_ingot

town_return_events:
  type: world
  debug: false
  events:
    on town_return_scroll|town_return_crystal recipe formed:
      - determine cancelled if:<player.has_town.not>
      - define lore "<context.item.lore.include[<&b>Town<&co> <player.town.name>]>"
      - determine passively <context.item.with[flag=town:<player.town>;lore=<[lore]>]>

town_return_execute:
  type: task
  debug: false
  script:
    - define type <context.item.flag[type]>
    - if !<context.item.has_flag[town]> || !<context.item.flag[town].spawn.exists>:
      - narrate "<&c>This <[type]> appears to be broken..."
      - determine cancelled
    - if <[type]> == scroll:
      - if <context.item.flag[town].spawn.world> != <player.location.world>:
        - narrate "<&c>This item lacks the power for cross dimensional travel"
        - stop
      - if <context.item.flag[town].spawn.distance[<player.location>]> > 2000:
        - narrate "<&c>This item lacks the power for distances grater than 2000 blocks"
        - stop
    - take iteminhand
    - if <[type]> == crystal:
      - run totem_test def:103
      - wait 2s
    - run teleportation_animation_run def:<context.item.flag[town].spawn>