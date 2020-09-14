Thanksbill_Command:
  type: command
  debug: false
  name: thanksbill
  usage: /thanksbill
  description: thanks bill
  script:
    - if <player.has_flag[grass_fix]>:
      - flag <player> grass_fix:!
      - narrate "<&4>Ending Grass-Cuttery"
      - stop
    - flag <player> grass_fix
    - narrate "<aqua>Now fixing grass..."
    - while <player.has_flag[grass_fix]> && <player.is_online>:
      - define list <player.location.find.blocks[<material[brown_mushroom_block].with[faces=EAST|SOUTH|WEST|UP]>].within[64].filter[above.material.name.is[!=].to[air]]>
      - modifyblock <[list]> end_stone
      - if !<[list].is_empty>:
          - narrate "<gray>Replaced <[list].size> blocks."
      - wait 2s
    - flag <player> grass_fix:!
