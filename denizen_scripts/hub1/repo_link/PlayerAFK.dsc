AFK_Functions:
  type: world
  debug: false
  events:
    on delta time minutely every:30:
    - define FlagNode AFKCheck.LastLocation
    - foreach <server.online_players> as:Player:
      - if <[Player].has_flag[FlagNode]> && ( <[Player].flag[<[FlagNode]>]> == <[Player].location> ) :
        - kick <[Player]> "reason: You were AFK for 30 minutes!"
      - flag <[Player]> <[FlagNode]>:<[Player].location>
    on player quit flagged:AFKCheck.LastLocation:
    - flag player AFKCheck.LastLocation:!
