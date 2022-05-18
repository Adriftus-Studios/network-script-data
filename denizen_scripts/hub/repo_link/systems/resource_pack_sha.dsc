resource_pack_sha:
  type: task
  debug: false
  definitions: sha
  script:
    - flag server rp_sha:<[sha]>

resource_pack_force:
  type: task
  debug: false
  events:
    after player joins:
      - if !<player.has_flag[RP_Enabled]> || <player.flag[RP_Enabled]> != <server.flag[rp_sha]>:
        - resourcepack targets:<player> url:http://www.adriftus.net:25581/resource_pack.zip hash:<server.flag[rp_sha]> forced if:<player.has_flag[rp_bypass].not>
    on resource pack status:
      - choose <context.status>:
        - case SUCCESSFULLY_LOADED:
          - flag <player> RP_Enabled:<server.flag[rp_sha]>
        - case FAILED_DOWNLOAD:
            - wait 10t
            - resourcepack targets:<player> url:http://www.adriftus.net:25581/resource_pack.zip hash:<server.flag[rp_sha]> forced
    on bungee player leaves network:
      - flag player rp_fail:!
      - flag player RP_Enabled:!
