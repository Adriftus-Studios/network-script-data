resource_pack_sha:
  type: task
  debug: false
  definitions: sha|staff_sha
  script:
    - flag server rp_sha:<[sha]>
    - flag server rp_staff_sha:<[staff_sha]>

resource_pack_force:
  type: world
  debug: false
  events:
    after player joins:
      - if !<player.has_permission[adriftus.staff]>:
        - if !<player.has_flag[RP_Enabled]> || <player.flag[RP_Enabled]> != <server.flag[rp_sha]>:
          - resourcepack targets:<player> url:http://<server.flag[ip]>:25581/resource_pack.zip hash:<server.flag[rp_sha]> forced if:<player.has_flag[rp_bypass].not>
      - else:
        - if !<player.has_flag[RP_Enabled]> || <player.flag[RP_Enabled]> != <server.flag[rp_staff_sha]>:
          - resourcepack targets:<player> url:http://<server.flag[ip]>:25581/resource_pack_staff.zip hash:<server.flag[rp_staff_sha]> forced if:<player.has_flag[rp_bypass].not>
    on resource pack status:
      - choose <context.status>:
        - case SUCCESSFULLY_LOADED:
          - if !<player.has_permission[adriftus.staff]>:
            - flag <player> RP_Enabled:<server.flag[rp_sha]>
          - else:
            - flag <player> RP_Enabled:<server.flag[rp_staff_sha]>
          - customevent id:resource_pack_loaded
        - case FAILED_DOWNLOAD:
            - wait 1s
            - if !<player.has_permission[adriftus.staff]>:
              - if !<player.has_flag[RP_Enabled]> || <player.flag[RP_Enabled]> != <server.flag[rp_sha]>:
                - resourcepack targets:<player> url:http://<server.flag[ip]>:25581/resource_pack.zip hash:<server.flag[rp_sha]> forced if:<player.has_flag[rp_bypass].not>
            - else:
              - if !<player.has_flag[RP_Enabled]> || <player.flag[RP_Enabled]> != <server.flag[rp_staff_sha]>:
                - resourcepack targets:<player> url:http://<server.flag[ip]>:25581/resource_pack_staff.zip hash:<server.flag[rp_staff_sha]> forced if:<player.has_flag[rp_bypass].not>
    on bungee player leaves network:
      - flag player rp_fail:!
      - flag player RP_Enabled:!
