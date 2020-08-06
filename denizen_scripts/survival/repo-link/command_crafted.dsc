craftable:
  type: command
  name: craftable
  debug: false
  script:
    - if <player.has_flag[craft_admin]>:
      - if <player.has_flag[crafted_confirm]> && <player.flag[crafted_confirm]> == <context.args.first||null>:
        - yaml id:crafted set whitelist:|:<player.flag[crafted_confirm]>
        - narrate "<&b><player.flag[crafted_confirm]> <&e>can now access crafted, based on name."
        - narrate "<&e>This is functionally no different."
        - narrate "<&e>It just allows players who have never connected to be whitelisted."
        - flag player crafted_confirm:!
        - stop
      - flag player crafted_confirm:!
      - define target <server.match_offline_player[<context.args.first>]||null>
      - if <[target]> == null:
        - narrate "<&c>Unknown Player<&co> <&e><context.args.first>"
        - narrate "<element[<&e>Click here to add the player by their name.].on_hover[<&e>Add player <&b><context.args.first> <&e>by name].on_click[/craftable <context.args.first>]>"
        - flag player crafted_confirm:<context.args.first> duration:2m
        - stop
      - if <yaml[crafted].read[whitelist].contains_any[<[target].uuid>|<[target].name>]>:
        - narrate "<&b><[target].name> <&c>already has access to the server."
        - stop
      - yaml id:crafted set whitelist:|:<[target].uuid>
      - yaml id:crafted savefile:data/crafted.yml
      - narrate "<&b><[target].name> <&e>now has access to <&6>Crafted<&e>."
      - adjust <[target]> show_entity:<server.flag[crafted_npc]>
    - else:
      - narrate "<&c>OOF. no."

uncraftable:
  type: command
  name: uncraftable
  debug: false
  script:
    - if <player.has_flag[craft_admin]>:
      - define target <server.match_offline_player[<context.args.first>]||<context.args.first.as_player||null>>
      - if <[target]> == null && !<yaml[crafted].read[whitelist].contains_any[<[target].uuid||null>|<[target].name||<context.args.first>>]>:
        - narrate "<&c>Unknown Player<&co> <&e><context.args.first>"
        - stop
      - if !<yaml[crafted].read[whitelist].contains_any[<[target].uuid||null>|<[target].name||<context.args.first>>]>:
        - narrate "<&b><[target].name> <&c>does not have access to the server."
        - stop
      - yaml id:crafted set whitelist:!|:<yaml[crafted].read[whitelist].exclude[<[target].uuid||null>|<[target].name||<context.args.first>>]>
      - yaml id:crafted savefile:data/crafted.yml
      - narrate "<&b><[target].name||<context.args.first>> <&e>no longer has access to <&6>Crafted<&e>."
      - if <[target]> != null:
        - adjust <[target]> hide_entity:<server.flag[crafted_npc]>
    - else:
      - narrate "<&c>OOF. no."

list_crafted:
  type: command
  name: list_crafted
  debug: false
  script:
    - if <player.has_flag[craft_admin]>:
      - foreach <yaml[crafted].read[whitelist].deduplicate> as:user:
        - if <[user].as_player.name||null> == null:
          - define name <[user]>
        - else:
          - define name <[user].as_player.name>
        - narrate "<&a>- <&e><element[<[name]>].on_hover[<&e>Click to remove player.].on_click[/uncraftable <[name]>]>"

craft_load:
  type: world
  debug: false
  events:
    on script reload:
      - yaml id:crafted load:data/crafted.yml
