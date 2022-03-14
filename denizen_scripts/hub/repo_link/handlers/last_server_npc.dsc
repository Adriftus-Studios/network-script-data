last_server_npc:
  type: assignment
  actions:
    on assignment:
    - trigger name:click state:true
    - trigger name:damage state:true
    on damage:
    - inventory open d:store_hub_cosmeticShop
    on click:
    - inventory open d:store_hub_cosmeticShop

last_server_handler:
  type: task
  debug: false
  script:
    - if <yaml[global.player.<player.uuid>].contains[adriftus.last_server]>:
      - adjust <player> send_to:<yaml[global.player.<player.uuid>].read[adriftus.last_server]>
    - else:
      - narrate "<&c>You have not played on any server yet!"