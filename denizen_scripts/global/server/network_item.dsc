network_item:
  type: item
  material: player_head
  display name: <&b>Menu
  mechanisms:
    skull_skin: GoOnReportMe

hub_server_item:
  type: item
  material: player_head
  display name: <&a>Servers
  lore:
    - "<&a>Choose a server to play on!"
  mechanisms:
    skull_skin: Dipicrylamine
    

hub_warp_item:
  type: item
  material: player_head
  display name: <&b>Warps
  lore:
    - "<&a>Warp around!"
  mechanisms:
    skull_skin: Wutt

hub_cosmetics_item:
  type: item
  material: player_head
  display name: <&5>Cosmetics
  lore:
    - "<&c>Not Yet Implemented!"
  mechanisms:
    skull_skin: Aa

hub_settings_item:
  type: item
  material: player_head
  display name: <&7>Settings
  lore:
    - "<&c>Not Yet Implemented!"
  mechanisms:
    skull_skin: Aa


network_item_events:
  type: world
  debug: false
  events:
    on player right clicks with:network_item:
      - determine passively cancelled
      - inventory open d:network_item_inventory
    on player joins:
      - if <bungee.server> == hub1:
        - wait 1t
        - inventory set d:<player.inventory> slot:5 o:<item[network_item]>
        - adjust <player> item_slot:5
    on player clicks network_item in inventory:
      - determine cancelled
    on player drops network_item:
      - determine cancelled

network_item_inventory:
  type: inventory
  inventory: chest
  title: <&a>Play Menu
  definitions:
    filler: <item[white_stained_glass_pane]>
    this_player_head: <item[player_head].with[skull_skin=<player.name>;display_name=<player.name>]>
    server_item: <item[hub_server_item].with[nbt=item/server]>
    warp_item: <item[hub_warp_item].with[nbt=item/warp]>
    cosmetics_item: <item[hub_cosmetics_item].with[nbt=item/cosmetics]>
    settings_item: <item[hub_settings_item].with[nbt=item/settings]>
  slots:
    - [filler] [filler] [filler] [filler] [this_player_head] [filler] [filler] [filler] [filler]
    - [filler] [server_item] [filler] [warp_item] [filler] [cosmetics_item] [filler] [settings_item] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]

network_item_inventory_events:
  type: world
  debug: false
  events:
    on player clicks item in network_item_inventory:
      - determine passively cancelled
      - if <context.item.has_nbt[item]>:
        - choose <context.item.nbt[item]>:
          - case server:
            - inventory open d:command_play_inventory
          - case warp:
            # TODO
            - narrate "<&c>Work in Progress."
          - case settings:
            # TODO
            - narrate "<&c>Not Yet Implemented."
          - case cosmetics:
            # TODO
            - narrate "<&c>Not Yet Implemented."
