mushroom_home:
  type: item
  debug: false
  material: red_mushroom
  display name: <&a>Miraculous Mushroom

mushroom_home_give:
  type: task
  script:
    - give <item[mushroom_home].with[nbt=owner/<player.uuid>]>

miraculous_mushroom_events:
  type: world
  debug: false
  events:
    on player right clicks block with:mushroom_home bukkit_priority:HIGHEST:
      - determine passively cancelled
      - if <context.relative||null> == null:
        - stop
      - define build_loc <context.relative.center.with_pitch[0].with_yaw[<player.location.yaw.round_to_precision[90]>]>
      - define lever_loc <[build_loc].above[7].backward>
      - define top <yaml[mushroom_config].parsed_key[mushroom_relatives.cuboids.top.a].to_cuboid[<yaml[mushroom_config].parsed_key[mushroom_relatives.cuboids.top.b]>]>
      - define stem <yaml[mushroom_config].parsed_key[mushroom_relatives.cuboids.stem.a].to_cuboid[<yaml[mushroom_config].parsed_key[mushroom_relatives.cuboids.stem.b]>]>
      - if <[top].blocks.include[<[stem].blocks>].size> != <[top].blocks[air].include[<[stem].blocks[air]>].size>:
        - narrate "<&c>Not enough room to place."
        - stop
      - if !<context.relative.below.material.is_solid>:
        - narrate "<&c>Unstable location."
        - stop
      - if <player.item_in_hand.script.name> != mushroom_home:
        - stop
      - take <context.item>
      - showfake red_mushroom <context.relative> players:<context.relative.find.players.within[30]> duration:10t
      - repeat 10:
        - playeffect happy_villager at:<context.relative.center.above[.1]> quantity:5 offset:0.25
        - wait 1t
      - schematic paste name:mushroom_home_<[build_loc].yaw> <[build_loc].backward> noair
      - modifyblock <[lever_loc].below> oak_trapdoor[direction=<[lever_loc].material.direction>;half=bottom;switched=false]
      - note <[lever_loc]> as:mushroom_home~<player.uuid>.<util.random.uuid>
      - foreach <yaml[mushroom_config].list_keys[mushroom_relatives.saves]> as:key:
        - if <context.item.has_nbt[<[key]>]> && <context.item.nbt[<[key]>].as_list.size> > 0:
          - inventory set o:<context.item.nbt[<[key]>]> d:<yaml[mushroom_config].parsed_key[mushroom_relatives.saves.<[key]>].inventory>
    on player clicks lever:
      - if <context.location.note_name.starts_with[mushroom_home]||false>:
        - determine passively cancelled
      - wait 1t
      - if <context.location.note_name.starts_with[mushroom_home~<player.uuid>]||false>:
        - define lever_loc <context.location.center.with_pitch[0].with_yaw[<yaml[mushroom_config].read[directional_converter.direction.<context.location.material.direction>]>]>
        - define cuboid <yaml[mushroom_config].parsed_key[mushroom_relatives.cuboids.whole.a].to_cuboid[<yaml[mushroom_config].parsed_key[mushroom_relatives.cuboids.whole.b]>]>
        - foreach <yaml[mushroom_config].list_keys[mushroom_relatives.checks]> as:material:
          - foreach <yaml[mushroom_config].parsed_key[mushroom_relatives.checks.<[material]>]> as:location:
            - if <[location].material.name> != <[material]>:
              - narrate "<&c>The structure has been damaged, and cannot be re-packed."
              - narrate "<&b>Missing<&co> <[material]>"
              - repeat 20:
                - playeffect happy_villager at:<[location].center> quantity:5 offset:0.1
                - wait 4t
              - stop
        - foreach <yaml[mushroom_config].list_keys[mushroom_relatives.counts]> as:material:
          - if <yaml[mushroom_config].read[mushroom_relatives.counts.<[material]>]> != <[cuboid].blocks[<[material]>].size>:
              - narrate "<&c>The structure has been damaged, and cannot be re-packed."
              - narrate "<&b>Missing<&co> <[material]>"
              - stop
        - foreach <yaml[mushroom_config].parsed_key[mushroom_relatives.air_check]> as:location:
          - if <[location].material.name> != air:
            - narrate "<&c>Foreign objects are interfering with packaging."
            - narrate "<&b>Obstructing Material<&co> <[location].material.name>"
            - stop
        - foreach <yaml[mushroom_config].list_keys[mushroom_relatives.saves]> as:key:
          - define nbt:|:<[key]>/<yaml[mushroom_config].parsed_key[mushroom_relatives.saves.<[key]>].inventory.list_contents.escaped||air>
        - note remove as:<context.location.note_name>
        - define top <yaml[mushroom_config].parsed_key[mushroom_relatives.cuboids.top.a].to_cuboid[<yaml[mushroom_config].parsed_key[mushroom_relatives.cuboids.top.b]>]>
        - define stem <yaml[mushroom_config].parsed_key[mushroom_relatives.cuboids.stem.a].to_cuboid[<yaml[mushroom_config].parsed_key[mushroom_relatives.cuboids.stem.b]>]>
        - modifyblock <[stem].blocks[ladder]> air no_physics
        - modifyblock <[top].blocks[lever|wall_torch|chest|furnace]> air no_physics
        - modifyblock <[top].blocks> air
        - modifyblock <[stem].blocks> air
        - flag player no_next_fall duration:5s
        - wait 2t
        - if <[nbt]||null> != null:
          - give <item[mushroom_home].with[nbt=<[nbt].include[owner/<player.uuid>]>]>
        - else:
          - give <item[mushroom_home]>
    on player picks up mushroom_home:
      - if <context.item.nbt[owner]> != <player.uuid>:
        - determine cancelled

mushroom_home_config_manager:
  type: world
  load:
    - ~yaml id:mushroom_config load:data/mushroom_config.yml
    - if <schematic.list.filter[starts_with[mushroom_home]].is_empty>:
      - schematic load name:mushroom_home_0
      - schematic load name:mushroom_home_90
      - schematic load name:mushroom_home_180
      - schematic load name:mushroom_home_270
      - schematic load name:mushroom_home_360
  events:
    on server start:
      - inject locally load
    on script reload:
      - inject locally load
