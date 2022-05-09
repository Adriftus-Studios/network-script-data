## Global Scripts For Herocraft Server/World Handling

herocraft_set_world:
  type: task
  debug: false
  definitions: target|world
  script:
    - flag <[target]> current_world:<[world]>

herocraft_send_to_world:
  type: task
  debug: false
  definitions: world
  script:
    - if !<bungee.list_servers.contains[<[world]>]>:
      - narrate "<&c>Unable to complete this action right now..."
      - log error "SERVER<&co> <[world]> is not currently connected."
      - stop
    - bungeerun <[world]> set_inventory def:<player>|<player.inventory.map_slots>|<player.enderchest.map_slots>
    - if <[world]> == herocraft:
      - bungeerun herocraft herocraft_set_world def:<player>|!
    - else if <bungee.server> == herocraft:
      - flag <player> current_world:<[world]>
    - else:
      - bungeerun herocraft herocraft_set_world def:<player>|<[world]>
    - title title:<&color[#000000]><&font[adriftus:overlay]><&chr[0004]><&chr[F801]><&chr[0004]> fade_in:5t stay:10t fade_out:5t targets:<player>
    - wait 5t
    - adjust <player> send_to:<[world]>