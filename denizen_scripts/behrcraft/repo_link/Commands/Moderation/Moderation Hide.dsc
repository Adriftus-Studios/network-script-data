Hide_Command:
  type: command
  name: hide
  debug: false
  description: Hides you from players.
  usage: /hide (on/off)
  permission: behrry.moderation.hide
  script:
# % ██ [ Check for args ] ██
    - if !<list[0|1].contains[<context.args.size>]>:
      - inject Command_Syntax Instantly
    
# % ██ [ Define definitions ] ██
    - define Arg <context.args.first||null>
    - define ModeFlag "behrry.moderation.hide"
    - define ModeName "Invisibility mode"
    - inject Activation_Arg Instantly
    - define Moderators <server.online_players.filter[in_group[Moderation]]>

    - if <player.has_flag[behrry.moderation.hide]>:
      - execute as_server "dynmap:dynmap hide <player.name>"
      - inject Chat_Event_Messages path:Quit_Event
      - foreach <server.online_players.exclude[<[Moderators]>]> as:Player:
        - adjust <[Player]> hide_entity:<player>
      - run Invisible def:<player>|<[Moderators].escaped>|true|HiddenModerators
      - while <player.is_online> && <player.has_flag[behrry.moderation.hide]>:
        - actionbar "<&7>You are hidden from players."
        - wait 5s
        - while next
    - else:
      - adjust <player> show_to_players
      - execute as_server "dynmap:dynmap show <player.name>"
      - inject Chat_Event_Messages path:Join_Event
      - run Invisible def:<player>|<[Moderators].escaped>|false|HiddenModerators
    - repeat 3:
      - playsound <player.location> sound:ENTITY_BLAZE_AMBIENT
      - playeffect effect:EXPLOSION_NORMAL at:<player.location.add[0,1,0]> visibility:50 quantity:10 offset:0.5
      - playeffect effect:EXPLOSION_LARGE at:<player.location.add[0,1,0]> visibility:50 quantity:1 offset:0.5

Hide_Handler:
  type: world
  debug: false
  events:
    on player damages entity:
      - if <player.has_flag[behrry.moderation.hide]>:
        - determine passively cancelled
        - narrate format:Colorize_Red "You cannot attack while hidden."
    on player logs in:
      - define HiddenModerators <server.online_players.filter[has_flag[behrry.moderation.hide]]>
      - if <[HiddenModerators].size> > 0:
        - foreach <[HiddenModerators]> as:Mod:
          - if <player.in_group[Moderation]>:
            - team name:HiddenModerator add:<player>
          - else:
            - adjust <player> hide_entity:<[Mod]>
                
  # % ██ [ Check if a hidden mod ] ██
      - if <player.has_flag[behrry.moderation.hide]>:
        - execute as_server "dynmap:dynmap hide <player.name>"
        - inject Chat_Event_Messages path:Quit_Event
        - foreach <server.online_players.exclude[<[Moderators]>]> as:Player:
          - adjust <[Player]> hide_entity:<player>
        - run Invisible def:<player>|<[Moderators].escaped>|true|HiddenModerators
        - while <player.is_online> && <player.has_flag[behrry.moderation.hide]>:
          - actionbar "<&7>You are hidden from players."
          - wait 5s
          - while next

Invisible:
  type: task
  definitions: User|Players|Toggle|ID
  script:
 # % ██ [ Unescape Definitions ] ██
    - define Players <[Players].unescaped>
    - if <[Toggle]>:
      - cast <[User]> invisibility power:1 duration:9999
      - team name:<[ID]> add:<[Players].include[<[User]>]>
    - else:
      - cast <[User]> invisibility remove
      - team name:<[ID]> remove:<[Players].include[<[User]>]>
