Door_Closer:
  type: world
  debug: false
  events:
    after player right clicks *door|*_gate priority:2:
      - if <player.has_flag[DoorsStay]>:
        - stop
      - if !<context.location.material.switched>:
        - stop
      - wait 2s
      - waituntil <context.location.find.entities[player].within[3].size.is[==].to[0]>
      - if <context.location.material.switched>:
        - switch <context.location> state:off
        - choose <context.location.material.name.after_last[_]>:
          - case door:
            - playsound <context.location> BLOCK_WOODEN_DOOR_CLOSE
          - case trapdoor:
            - playsound <context.location> BLOCK_WOODEN_TRAPDOOR_CLOSE
          - case gate:
            - playsound <context.location> BLOCK_FENCE_GATE_CLOSE

dont_close_doors:
  type: command
  debug: false
  name: doorcloser
  description: flags the player to keep doors open
  usage: /doorcloser
  aliases:
    - closedoor
    - opendoors
  script:
  - if <player.has_flag[DoorsStay]>:
    - flag player DoorsStay:!
    - narrate "<&6>Now closing <&e>doors <&6>behind you."
  - else:
    - flag player DoorsStay
    - narrate "<&6>Now allowing you to leave <&e>doors <&6>wide open."
