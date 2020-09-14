# Cuboid Tool
cuboid_tool_item:
  type: item
  debug: false
  material: stick
  display name: <&a><&l>Selection Tool
  lore:
  - <&b>Usage<&co>
  - "<&a>Left Click - Save Position 1"
  - "<&a>Right Click - Save Position 2"

cuboid_wand_command:
  type: command
  debug: false
  name: wand
  description: Gives the WorldEdit wand
  usage: /wand
  permission: worldedit.wand
  script:
    - if <context.args.first||null> == null:
      - give cuboid_tool_item
      - determine fulfilled

# Command for cuboid
cuboid_command:
  type: command
  debug: false
  name: cube
  usage: /cube [save|schem|clear]
  description: Modifies cuboids created with the WE wand
  aliases:
    - cuboid
  permission: worldedit.command.cube
  tab complete:
    - if <context.args.is_empty>:
      - determine <list[save|schem|clear]>
  permission message: <&c>Sorry <player.name>, you can't perform that command.
  script:
    - if <context.args.first||null> == null:
      - narrate "<&c>Please select an area and choose a name."
    - else if <context.args.first> == clear:
      - note remove as:cuboid_selection_left_<player.uuid>
      - note remove as:cuboid_selection_right_<player.uuid>
      - narrate "<&a>Successfully removed your cuboid selection"
    - else if <context.args.first> == save:
      - if <context.args.get[2]||null> == null:
        - narrate "<&c>Please name your cuboid"
      - if <cuboid[<context.args.get[2]>]||invalid> != invalid:
        - if <player.has_flag[point1]> && <player.has_flag[point2]>:
          - note <player.flag[point1].to_cuboid[<player.flag[point2]>]> as:<context.args.get[2]>
          - narrate "<&6> - Your selection Has been saved as<&co> <&a><context.args.get[2]>"
        - else:
          - narrate "<&c>You have no selection made"
      - else:
        - narrate "<&c>You already have a cuboid named <&a><context.args.get[2]><&nl><&c>Remove it before continuing."
    - else if <context.args.first> == schem:
      - if <context.args.get[2]||null> == null:
        - narrate "<&c>Please use <&a>create<&c> to save your schematic"
      - if <context.arge.get[2]> == create:
        - if !<server.notables[cuboids].parse[note_name].contains[<context.args.get[3]>]>:
          - narrate "<&c>Your schematic name, and previous cuboid name must match."
        - else:
          - schematic create name:<context.args.get[3]> <context.args.get[3]> <player.location>
          - ~schematic save name:<context.args.get[3]>

cuboid_noting_locations:
  type: world
  debug: false
  events:
    on player left clicks block with:cuboid_tool_item:
      - determine passively cancelled
      - flag player point1:<context.location>
      - narrate "<&a>Selection made at <&b><context.location.simple>"
    on player right clicks block with:cuboid_tool_item:
      - determine passively cancelled
      - flag player point2:<context.location>
      - narrate "<&a>Selection made at <&b><context.location.simple>"

#note <[location1|location2]> as:cuboid

# Abuse Prevention
cuboid_tool_abuse_prevention:
    type: world
    debug: false
    events:
        on player drops cuboid_tool_item:
        - remove <context.entity>
        on player clicks in inventory with:cuboid_tool_item:
        - inject locally abuse_prevention_click
        on player drags cuboid_tool_item in inventory:
        - inject locally abuse_prevention_click
    abuse_prevention_click:
        - if <context.inventory.inventory_type> == player:
            - stop
        - if <context.inventory.inventory_type> == crafting:
            - if <context.raw_slot||<context.raw_slots.numerical.first>> >= 6:
                - stop
        - determine passively cancelled
        - inventory update
