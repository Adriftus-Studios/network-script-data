Orc_spawn_task:
  Type: world
  Debug: false
  Events:
    On delta time minutely every:15:
      - if <server.online_players.size> > 0:
        - define count <server.online_players.size.div[5].round_up>
        - define select_few <server.online_players.random[<[count]>]>
        - foreach <[select_few]> as:poor_soul:
          - if !<list[adventure|survival].contains_any[<[poor_soul].gamemode>]> || <[poor_soul].location.town||notown> == notown:
            - foreach next
        #  - choose <[poor_soul].location.biome>:
            #- case *desert:
             # - define type Orc
          #  - case default:
          - define type Orc
          - mythicspawn <[type]>Party <[poor_soul].location.with_pose[0,<util.random.int[0].to[359]>].forward[20].find_spawnable_blocks_within[10].random>

