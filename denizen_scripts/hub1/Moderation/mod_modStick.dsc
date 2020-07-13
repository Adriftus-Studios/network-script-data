#Moderator Stick
command_mod_stick:
  type: item
  debug: false
  material: <item[stick]>
  display name: <&b>Moderator<&sp>Stick<&sp><&8>(Right-Click)
  lore:
    - "<&e>Right-Click to open up the Moderator Panel."
  enchantments:
    - ARROW_INFINITE:1
  mechanisms:
    flags: HIDE_ATTRIBUTES|HIDE_ENCHANTS

command_mod_stick_events:
  type: world
  debug: false
  events:
    on player right clicks player with command_mod_stick:
      - if !<player.has_permission[mod.staff]>:
        - narrate "<&e>Your Hamon training is useless!"
        - narrate "<&e>Useless! Useless! Useless! Useless!"
        - stop
      - else if <context.entity||null> != null && <context.entity.is_player||false>:
        - if <player.has_flag[modStick]>:
          - actionbar "<&c>You are on cooldown from using the Moderator Stick."
          - stop
        - else:
          - define permission:<player.has_permission[mod.staff]> player:<context.entity>
          - if <[permission]>:
            - narrate "<&c>You cannot perform actions on other staff members."
            - flag player modStick:true duration:10s
            - wait 10s
            - narrate "<&b>You may now use the Moderator Stick."
          - else:
            - narrate "<&b>Moderating <&e><context.entity.name>."
            - run command_mod_refresh def:<context.entity.uuid>
            - inventory open d:<inventory[command_mod_gui_panel]>

#Command
command_mod_stick_command:
  type: command
  debug: false
  permission: mod.helper
  name: modstick
  script:
    - if <player.has_permission[mod.helper]>:
      - give <item[command_mod_stick]>