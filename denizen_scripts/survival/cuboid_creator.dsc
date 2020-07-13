# Cuboid Tool
cuboid_tool_item:
  type: item
  material: stick
  display name: <&a><&l>Selection Tool
  lore:
  - "<&b>Usage<&co>"
  - "<&a>Left Click - Save Position 1"
  - "<&a>Right Click - Save Position 2"

cuboid_wand_command:
  type: command
  name: wand
  permission: worldedit.wand
  script:
    - if <context.args.get[1]||null> == null:
      - give cuboid_tool_item
      - determine fulfilled

# Command for cuboid
cuboid_command:
  type: command
  name: cube
  aliases:
    - cuboid
  permission: worldedit.command.cube
  tab complete:
    - if <context.args.size||0> == 0:
      - determine <list[save|schem|clear]>
  permission message: <&c>Sorry <player.name>, you can't perform that command.
  script:
    - if <context.args.get[1]||null> == null:
      - narrate "<&c>Please select an area, and choose a name."
    - else if <context.args.get[1]> == clear:
      - note remove as:cuboid_selection_left_<player.uuid>
      - note remove as:cuboid_selection_right_<player.uuid>
      - narrate "<&a>Successfully removed your Cube Selection"
    - else if <context.args.get[1]> == save:
      - if <context.args.get[2]||null> == null:
        - narrate "<&c>Please name your Cuboid"
      - if !<server.list_notables[cuboids].parse[notable_name].contains[<context.args.get[2]>]>:
        - if <player.has_flag[point1]> && <player.has_flag[point2]>:
          - note <cuboid[<player.flag[point1]>|<player.flag[point2]>]> as:<context.args.get[2]>
          - narrate "<&6> - Your selection Has been saved as<&co> <&a><context.args.get[2]>"
      - else:
        - narrate "<&c>You already have a cuboid named <&a><context.args.get[2]><&nl><&c>Remove it before continuing."
      # Thinking of adding a way to directly add the cube as a schematic from here...

cuboid_noting_locations:
  type: world
  events:
    on player left clicks block with cuboid_tool_item:
      - determine passively cancelled
      - flag player point1:<context.location>
      - narrate "<&a>Selection made at <&b><context.location.simple>"
    on player right clicks block with cuboid_tool_item:
      - determine passively cancelled
      - flag player point2:<context.location>
      - narrate "<&a>Selection made at <&b><context.location.simple>"

#note <[location1|location2]> as:cuboid

# Abuse Prevention
cuboid_tool_abuse_prevention:
    type: world
    events:
        on player drops cuboid_tool_item:
        - remove <context.entity>
        on player clicks in inventory with cuboid_tool_item:
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