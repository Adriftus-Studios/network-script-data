resource_pack_sha:
  type: task
  debug: false
  definitions: sha
  script:
    - flag server rp_sha:<[sha]>

resource_pack_force:
  type: world
  debug: false
  events:
    on player joins:
      - resourcepack targets:<player> url:http://www.adriftus.net:25581/resource_pack.zip hash:<server.flag[rp_sha]> forced