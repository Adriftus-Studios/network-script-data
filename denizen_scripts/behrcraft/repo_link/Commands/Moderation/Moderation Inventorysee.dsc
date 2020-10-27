inventorysee_Command:
  type: command
  name: inventorysee
  debug: false
  description: Views another player's inventory
  usage: /inventorysee <&lt>Player<&gt>
  permission: behrry.moderation.inventorysee
  aliases:
    - invsee
    - inv
  tab complete:
    - if <player.groups.contains[Moderation]>:
      - inject Online_Player_Tabcomplete Instantly
  script:
  # % ██ [ Verify args ] ██
    - if <context.args.size> != 1
      - inject Command_syntax instantly

  # % ██ [ Verify player ] ██
    - define User <context.args.first>
    - inject Player_Verification_Offline
    
  # % ██ [ Verify usage ] ██
    - if <[User]> == <player>:
      - define Reason "You cannot edit your own inventory."
      - Inject Command_Error
    
  # % ██ [ Open inventory ] ██
    - inventory open d:<[User].inventory>
    - narrate "<&2>O<&a>pening <proc[User_Display_Simple].context[<[User]>]><proc[Colorize].context['s inventory.|green]>"
