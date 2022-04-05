return_scroll:
  type: item
  material: feather
  display name: <&6>Scroll of Returning
  data:
    recipe_book_category: travel.scroll
  lore:
  - "<&a>-------------"
  - "<&e>Right Click while Holding"
  - "<&e>Saves location when crafted"
  - "<&c>Incapable of long distances"
  - "<&a>-------------"
  flags:
    right_click_script: return_task
    type: scroll
  mechanisms:
    custom_model_data: 200
  recipes:
    1:
      type: shapeless
      input: ink_sac|papyrus|lapis_lazuli

return_crystal:
  type: item
  material: feather
  display name: <&6>Return Crystal
  data:
    recipe_book_category: travel.crystal
  lore:
  - "<&a>-------------"
  - "<&e>Right Click while Holding"
  - "<&e>Saves location when crafted"
  - "<&a>-------------"
  flags:
    right_click_script: return_task
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


return_events:
  type: world
  debug: false
  events:
    on return_scroll|return_crystal recipe formed:
      - define lore "<context.item.lore.include[<&b>Location<&co> <player.location.simple>]>"
      - determine passively <item[return_scroll].with[flag=destination:<player.location>;lore=<[lore]>]>

return_task:
  type: task
  debug: false
  script:
    - define type <context.item.flag[type]>
    - if <[type]> == scroll:
      - if <context.item.flag[destination].world> != <player.location.world>:
        - narrate "<&c>This item lacks the power for cross dimensional travel"
        - stop
      - if <context.item.flag[destination].distance[<player.location>]> > 2000:
        - narrate "<&c>This item lacks the power for distances grater than 2000 blocks"
        - stop
    - take iteminhand
    - run teleportation_animation_run def:<context.item.flag[destination]>