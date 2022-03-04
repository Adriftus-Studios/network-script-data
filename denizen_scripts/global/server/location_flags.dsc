block_properties:
  type: world
  debug: true
  events:
    on player places block location_flagged:no_build:
      - determine cancelled
    on player breaks block location_flagged:on_break:
      - inject <context.location.flag[on_break]>
    on player steps on block location_flagged:on_step:
      - inject <context.location.flag[on_step]>
    on player right clicks chest location_flagged:infinite_chest:
      - if <player.has_permission[adriftus.admin]> && <player.is_sneaking>:
        - narrate "<&a>Bypassing Infinite Chest Restriction With Admin Permissions."
      - else:
        - determine passively cancelled
        - inventory open d:generic[title=<context.location.flag[infinite_chest]>;size=36;contents=<context.location.inventory.list_contents>]