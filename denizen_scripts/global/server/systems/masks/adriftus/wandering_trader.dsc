mask_adriftus_wander_trader:
  type: data
  display_data:
    category: Adriftus
    material: lead
    display_name: <&6>Adriftus<&co> <&6>Wandering Trader
    description: "<&e>Wandering Trader Character"
  mask_data:
    permission: adriftus.admin
    id: adriftus_wander_trader
    on_equip_task: mask_adriftus_wander_trader_equip
    on_unequip_task: mask_adriftus_wander_trader_unequip
    display_name: <&6>Wandering Trader
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTY0NTk4MzIyMjIwNCwKICAicHJvZmlsZUlkIiA6ICI5MGQ1NDY0OGEzNWE0YmExYTI2Yjg1YTg4NTU4OGJlOSIsCiAgInByb2ZpbGVOYW1lIiA6ICJFdW4wbWlhIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2JiZjY5YTEzY2M5OTJiZmE4YTAwNTU0MzUwYThkZjM1YTI5YjAxNDY1MjkxMDA5YjQ3MTRiMWNhN2ZkZmI0NDkiCiAgICB9CiAgfQp9;dCD5BEDTC/BQCl0VDsyftpYlpxfoREV4vlNHTIaHGykoQn2DNMrc5FdMgA1VPZ3p5YRgLrKn4ytU+NljSLRucNka8Q48ZKTAoys1w9AJI3yc0gf3oCBW+l/lJLsbZWbNMbeqP7V1nOn1umeLSwIoecrb89cDA9L0Dh45qpzZDzatgZqcWJBWbc2VEeTkvE7YjsbqqUkDVq2IOueEVPlalUE7lS99UuGhgyK6r4di5haZGpS9H4i7+5kqKHKEVrzT45WAxrJpp/Vq1a2aE4PfpfiSjAMKLV7LKMEJENbC4DHRdayNLa/gYqXKK2c7fD8LWv5pFddYbz1EyWdnVeTFcJMiUH8WBhER7H9ib7DIaqhFxRxYoKRmf+ydS3W8VGe14tb8JUrZzu0tMegrlrLmH9TtRvlHOkpxsRRGYG62ZE9roYS77E0LjCk/Tji2DcDxpK/fPtAIl2VTGniDHkM0KEYxei6h1ula/VQ36JXfjjNSvLqTgxrNmkyn7z8GPQ7+sxN9MQ9trA9lrbZMKwxZqxqR+u7PKOEaaBS7j9wDTjqLRqotoFRiU8NuEwvFxTKtUhQeW0tj7drpesG6LFpT4I93/tyts0/U1FNnbxhGhdMGGpr1T/GMZ0rhiwXNmTaA6m7/P/nBfBSMZFbBUCJmznpPjWUDFj2/xwHuv812Obo=

mask_adriftus_wander_trader_equip:
  type: task
  debug: false
  script:
    - flag <player> no_damage

mask_adriftus_wander_trader_unequip:
  type: task
  debug: false
  script:
    - flag <player> no_damage:!