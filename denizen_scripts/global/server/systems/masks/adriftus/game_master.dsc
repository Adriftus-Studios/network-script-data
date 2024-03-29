mask_adriftus_game_master:
  type: data
  display_data:
    category: Adriftus
    material: stick[custom_model_data=210]
    display_name: <&6>Adriftus<&co> Game Master
    description: "<&d>It's time to play the game."
  mask_data:
    id: adriftus_game_master
    on_equip_task: mask_adriftus_game_master_equip
    on_unequip_task: mask_adriftus_game_master_unequip
    attachments:
      helmet: stick[custom_model_data=210]
      mainhand: stick[custom_model_data=300]
    display_name: <&f><&chr[6917]> <&6>Game Master
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTY0ODEzNDExODY3OSwKICAicHJvZmlsZUlkIiA6ICI0NDAzZGM1NDc1YmM0YjE1YTU0OGNmZGE2YjBlYjdkOSIsCiAgInByb2ZpbGVOYW1lIiA6ICJDaGFvc0NvbXB1dHJDbHViIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzkwMzFmODQ5ZTc3MWY3ZTUxYTUwNjJlYThiMGVmMjEwMjk3NDFiNTc3MDc1MzRlZjc2YTgzMWFkNmMzYzNmODMiLAogICAgICAibWV0YWRhdGEiIDogewogICAgICAgICJtb2RlbCIgOiAic2xpbSIKICAgICAgfQogICAgfQogIH0KfQ==;mZUWo2e5XCMXg3GUYqWK2sKJlqHSaKyoZq9jqL5ZRC/wCGWy1H37eTSI30BiPffxiIYLGSCgEU26UORk5Me4XfY+iCCoBMN9BaAGZz8OLLnBOCP4P15ruvt5NYapHmoNPDCKXicuZ44jX6+tomTijKnNM0rt2zwI3RgH+iOTfdbTA4KwFPk5LFlOGNvBuPe+bsAzMi2rSk9DwoP2Plgw45iUPNlFc9JlPp0rLvz4z4fiwHvbt1+RHGG6geLs3JPVjljDRbQl9I3njSXixj2XzGcNj1IRisg34YE5EvNqowqwNpcxLGuXlzjY8gjnEnjINVA/x49WFFiwEB68yny6M35DjX0SIba4mc1QOdjHtTNHafBX/7Kh+frRbXcq8JMw+njPpIxiVE4fOYcHpS7oWsRgrNURPv1ZAitwq+8cwugCbaHctuH5m1Hefaxl2QMdP+QHnYygrbyk1JGRcstA/0PCiK71t8sAiAHHDR3ftaHZPaKdux1PIKOltK2diS+6quUGEdF36PbZGvbXiUNq5Qrd6qnZfaFkLlfhqFzsyEguXVxrtbSxwQEGC934gUOsoH1xdufDkT5CYCJmT2EdUc4pxMEowfojtVZyCTkJylKYxos9P6xlq+hfgyWb4BzsubEipMdCBANOe5n17+Lemtgf8U4zmvTnxAY94rgKFPE=
    particle:
      rate: 5
      effect: soul_fire_flame
      quantity: 2
      offset: 0.5

mask_adriftus_game_master_equip:
  type: task
  debug: false
  script:
    - flag player admin_mask.location:<player.location>
    - flag player admin_mask.health:<player.health>
    - flag player admin_mask.hunger:<player.food_level>
    - heal
    - feed
    - flag player on_hunger_change:->:cancel
    - flag player on_damaged:->:cancel
    - run SAVED_INVENTORY_LOAD def:game_master
    - wait 10t
    - adjust player can_fly:true

mask_adriftus_game_master_unequip:
  type: task
  debug: false
  script:
    - flag player on_hunger_change:<-:cancel
    - flag player on_damaged:<-:cancel
    - adjust player can_fly:false
    - adjust <player> health:<player.flag[admin_mask.health]>
    - adjust <player> food_level:<player.flag[admin_mask.hunger]>
    - adjust <player> location:<player.flag[admin_mask.location]>
    - flag player admin_mask.health:!
    - flag player admin_mask.hunger:!
    - flag player admin_mask.location:!
    - run SAVED_INVENTORY_LOAD def:default
