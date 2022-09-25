fish_globe_handler:
  type: world
  debug: true
  events:
    on player right clicks block with:fish_globe:
      - determine passively cancelled
      - if <player.inventory.empty_slots> < <context.item.inventory_contents.size>:
        - narrate "<&c>You must have at least <&e><context.item.inventory_contents.size> <&c>open inventory slots to unpack this globe."
        - stop
      - if <player.has_flag[opening_fish_globe]>:
        - narrate "<&c>Please finish opening your current Fish Pack."
        - stop
      - else:
        - flag <player> opening_fish_globe duration:30s
        - take iteminhand
        - define fish_list <context.item.inventory_contents>
        - repeat <[fish_list].size>:
          - define fish <context.item.inventory_contents.get[<[value]>]>
          - give <[fish]>
          - narrate "<&6>You unpacked <&e><[fish].quantity||a> <[fish].display.if_null[<&f><[fish].material.name.to_titlecase>].replace_text[_].with[<&sp>].to_titlecase><&6>."
          - playsound <player> sound:block_sand_hit sound_category:master pitch:0.5
          - wait <util.random.int[8].to[15]>t
        - flag <player> opening_fish_globe:!
    on player right clicks item in inventory:
      - if <context.cursor_item.script.name||null> == fish_globe || <context.item.script.name||null> == fish_globe:
        - determine passively cancelled


fish_globe:
  type: item
  material: Bundle
  display name: <&6>Packed Fish Bundle
  mechanisms:
    custom_model_data: 1
