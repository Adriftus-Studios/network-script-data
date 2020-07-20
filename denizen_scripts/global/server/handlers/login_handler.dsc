player_joins_event_display_name:
  type: data
  nothing:
#@  script:
#^
#^      #^- if !<yaml[global.player.<player.uuid>].list_keys.contains[display_name]>:
#^          #^- yaml id:global.player.<player.uuid> set Display_Name:<player.name>
#^    - if <server.has_file[data/players/<player.uuid>.yml]>:
#^      - ~yaml id:player.<player.uuid> load:data/players/<player.uuid>.yml
#^    - else:
#^      - yaml id:player.<player.uuid> create
#^      - yaml id:global.player.<player.uuid> set Display_Name:<player.name>
#^      - yaml id:global.player.<player.uuid> set Tab_Display_Name:<player.name>
#^      - ~yaml id:player.<player.uuid> savefile:data/players/<player.uuid>.yml

    #- if <yaml[global.player.<player.uuid>].list_keys.contains[Tab_Display_Name]>:
    #  - adjust <player> display_name:<yaml[global.player.<player.uuid>].read[Tab_Display_Name]>
    #- else:
    #  - yaml id:global.player.<player.uuid> set Tab_Display_Name:<player.name>

    #| Network Administrator ★ Joined on Survival ★ A lone tree
    #^- if <yaml[global.player.<player.uuid>].list_keys[].contains[Rank]>:
    #^  - define Rank <yaml[global.player.<player.uuid>].read[Rank]>
    #^  - bungeerun relay Player_Join_Message def:<player.name>|<bungee.server>|<player.uuid>|<[Rank]>
    #^- else:
    #^  - bungeerun relay Player_Join_Message def:<player.name>|<bungee.server>|<player.uuid>
    