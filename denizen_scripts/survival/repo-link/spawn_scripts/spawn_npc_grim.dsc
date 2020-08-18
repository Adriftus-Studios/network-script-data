# Grim is the NPC for /back, but for death

# Grim Assignment
click_on_grim_assignment:
  type: assignment
  debug: false
  actions:
    on assignment:
    - trigger name:click state:true
    on click:
    - inventory open d:grim_death_menu
    - narrate "<&a>It seems that you have a question for me, <&2><player.display_name>"
  interact scripts:
  - 1 grim_interact_handler

# Interaction handler
grim_interact_handler:
  type: interact
  debug: false
  steps:
    1:
      Click trigger:
        script:
          - playsound <player> entity_wither_skeleton_step

# Grim Menu Main
grim_death_menu:
  type: inventory
  inventory: chest
  debug: false
  size: 27
  definitions:
    filler: <item[black_stained_glass_pane].with[display_name=<&e>;nbt=action/filler]>
    inventory_close: <item[barrier].with[display_name=<&c>Close;nbt=action/close]>
    death_location: <item[compass].with[display_name=<&e>Death<&sp>Location;nbt=action/location;lore=<&e>View<&sp>your<&sp>death<&sp>location<&sp><&e>before<&sp>teleporting<&sp>there.]>
    grim_contract: <item[writable_book].with[display_name=<&a>Contract;nbt=action/contract;lore=<&a>Sign<&sp>the<&sp>contract<&sp>for<&nl><&a>a<&sp>one<&sp>time<&sp>fee<&sp>of<&sp><&2>$1,000<&a><&sp>dollars<&nl><&nl><&a>This<&sp>will<&sp>start<&sp>the<&sp>process<&sp>of<&sp>moving<&sp>your<&sp><&nl><&a>spectral<&sp>soul<&sp>back<&sp>to<&sp>your<&sp>death<&sp>location<&sp>immediately!]>
    grim_head: <item[player_head].with[skull_skin=<npc.skull_skin>;display_name=<npc.name>;nbt=action/head;lore=<&c>By<&sp>signing<&sp>the<&sp>contract,<&sp>you<&sp>will<&sp>be<&sp>taken<&nl><&c>to<&sp>the<&sp>place<&sp>of<&sp>your<&sp>last<&sp>death.<&nl><&nl><&c>If<&sp>you<&sp>died<&sp>due<&sp>to<&sp>void,<&nl><&4>Grim<&c><&sp>will<&sp>not<&sp>show<&sp>you<&sp>where<&sp>you<&sp>died.]>
  slots:
  - [filler] [filler] [filler] [filler] [grim_head] [filler] [filler] [filler] [filler]
  - [filler] [] [grim_contract] [] [] [] [death_location] [] [filler]
  - [filler] [filler] [filler] [filler] [inventory_close] [filler] [filler] [filler] [filler]

grim_death_confirm:
  type: inventory
  inventory: chest
  debug: false
  size: 27
  definitions:
    filler: <item[black_stained_glass_pane].with[display_name=<&e>;nbt=action/filler]>
    inventory_close: <item[barrier].with[display_name=<&c>Close;nbt=action/close]>
    grim_contract: <item[writable_book].with[display_name=<&a>Contract;nbt=action/contract;lore=<&a>Sign<&sp>the<&sp>contract<&sp>for<&nl><&a>a<&sp>one<&sp>time<&sp>fee<&sp>of<&sp><&2>$1,000<&a><&sp>dollars]>
    grim_confirm: <item[lime_concrete].with[display_name=<&a>Accept;nbt=action/confirm;lore=<&a>You<&sp>will<&sp>be<&sp>teleported<&nl><&a>to<&sp>your<&sp>death<&sp>location]>
    grim_decline: <item[red_concrete].with[display_name=<&a>Decline;nbt=action/decline]>
  slots:
  - [filler] [filler] [filler] [filler] [grim_contract] [filler] [filler] [filler] [filler]
  - [filler] [] [grim_confirm] [] [] [] [grim_decline] [] [filler]
  - [filler] [filler] [filler] [filler] [inventory_close] [filler] [filler] [filler] [filler]

# Steal Prevention
grim_steal_prevention:
  type: world
  debug: false
  events:
    on player clicks item in grim_death_*:
    - if <context.item.has_nbt[action]>:
      - choose <context.item.nbt[action]>:
        - case close:
          - determine passively cancelled
          - playsound <player> sound:UI_BUTTON_CLICK
          - inventory close
        - case filler head:
          - determine cancelled
        - case location:
          - determine passively cancelled
          - playsound <player> sound:UI_BUTTON_CLICK
          - if <list[VOID|SUFFOCATION].contains[<player.flag[player_death_cause]>]>:
            - narrate "<&c>Your death location is unsafe. Do you want to die?"
            - inventory close
            - stop
          - else if !<player.has_flag[player_death_location]>:
            - narrate "<&c>Where do you think you're going?"
            - inventory close
          - else:
            - narrate "<&a>Your death location is <player.flag[player_death_location].as_location.simple.formatted>"
            - inventory close
            - teleport <player.flag[player_death_location].as_location.up[2]>
            - adjust <player> gamemode:spectator
            - adjust <player> fly_speed:0.0
            - flag player spectating_death
            - wait 5s
            - teleport grim_teleport
            - adjust <player> gamemode:adventure
            - adjust <player> fly_speed:0.2
            - flag player spectating_death:!
        - case contract:
          - determine passively cancelled
          - inventory open d:grim_death_confirm
          - playsound <player> sound:UI_BUTTON_CLICK
        - case confirm:
          - determine passively cancelled
          - if <list[VOID|SUFFOCATION].contains[<player.flag[player_death_cause]>]>:
            - narrate "<&c>Your death location is unsafe. Do you want to die?"
            - inventory close
            - stop
          - else if !<player.has_flag[player_death_location]>:
            - narrate "<&c>Where do you think you're going?"
            - playsound <player> sound:ENTITY_WITHER_SKELETON_AMBIENT
            - inventory close
          - else if <player.money> < 1000:
            - inventory close
            - narrate "<&c>Peasant, do you think I can afford free teleports?"
            - stop
          - else:
            - money take quantity:1000
            - narrate "<&a>Finally, someone who can pay up."
            - inventory close
            - playeffect at:<player.location.center.up[1]> effect:totem quantity:50
            - wait 1s
            - teleport <player.flag[player_death_location].as_location>
            - flag player player_death_location:!
        - case decline:
          - inventory close
          - narrate "<&a>You'll be back, <&2><player.display_name>"
          - playsound <player> sound:UI_BUTTON_CLICK
