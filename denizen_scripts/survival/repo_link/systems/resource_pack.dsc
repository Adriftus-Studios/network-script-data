resource_pack_sha_grabber:
  type: world
  debug: false
  events:
    # Not valid - need proper checking SHA of the RP zip itself
    # on script reload:
      #- ~webget view-source:https://github.com/Adriftus-Studios/adriftus-resources save:github
      #- define sha <entry[github].result.after[/Adriftus-Studios/adriftus-resources/tree-commit/].before["]>
      #- flag server sha:<[sha]>
    after player joins:
      - adjust <player> resource_pack:https://github.com/Adriftus-Studios/adriftus-resources/raw/master/adriftus-resources.zip
    on resource pack status:
      - if <context.status> == DECLINED:
        - flag player no_move:resource_pack
        - narrate "<&a>Please accept the resource pack to play on this server."
        - narrate "<&e>If you were not prompted, check your settings for resource packs."
        - narrate "<&e>Use <&b>/rp<&e> to be re-prompted with the resource pack."
      - if <context.status> == FAILED_DOWNLOAD:
        - flag player no_move:resource_pack
        - narrate "<&c>There was an error downloading the resource pack."
        - narrate "<&e>Use <&b>/rp<&e> to be re-prompted."
        - narrate "<&b>If this error persists, contact an administrator."
      - else:
        - if <player.has_flag[no_move]> && <player.flag[no_move]> == resource_pack:
          - flag player no_move:!

resource_pack_command:
  type: command
  name: rp
  debug: false
  script:
    - adjust <player> resource_pack:https://github.com/Adriftus-Studios/adriftus-resources/raw/master/adriftus-resources.zip
    