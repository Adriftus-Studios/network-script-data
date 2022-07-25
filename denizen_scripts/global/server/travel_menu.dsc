travel_menu_open:
  type: task
  debug: false
  data:
    hub_slots:
      spawn: 20|21|22
      crates: 24|25|26
      towny: 29|30|31
      shops: 33|34|35
      mail_run: 48
      fishing: 50
    herocraft:
      waystones:
        - 26
        - 27
        - 35
        - 36
      gui_waystone: 54
      items:
        multiverse_dust: 20
        return_scroll: 38
        back_scroll: 39
        town_return_scroll: 40
        tpa_crystal: 41
        return_crystal: 42
        back_crystal: 43
        town_return_crystal: 44
    calipolis:
      items:
        Home:
          - 23
        Lore:
          - 39
          - 40
        Warp:
          - 42
          - 43
    inactive_slots:
      - 40
      - 41
      - 42
    title_data:
      hub:
       active: <&chr[5004]>
       inactive: <&chr[5005]>
      herocraft:
       active: <&chr[1003]>
       inactive: <&chr[1004]>
      calipolis:
       active: <&chr[1998]>
       inactive: <&chr[1999]>
      build:
       active: <&chr[5002]>
       inactive: <&chr[5003]>
      test:
       active: <&chr[5000]>
       inactive: <&chr[5001]>
  definitions: tab
  script:
    - define tab <bungee.server> if:<[tab].exists.not>
    - define inventory <inventory[travel_menu_inventory]>
    - foreach <yaml[bungee_config].list_keys[servers]> as:server:
      - if !<yaml[bungee_config].contains[servers.<[server]>.show_in_play_menu]> || !<yaml[bungee_config].read[servers.<[server]>.show_in_play_menu]>:
        - foreach next
      - if <yaml[bungee_config].read[servers.<[server]>.restricted]||true> && !<player.has_permission[bungeecord.server.<[server]>]>:
        - foreach next
      - define display <yaml[bungee_config].parsed_key[servers.<[server]>.display_name]>
      - define lore <yaml[bungee_config].parsed_key[servers.<[server]>.description]>
      - define item <item[<yaml[bungee_config].read[servers.<[server]>.material]>]>
      - define slot <yaml[bungee_config].read[servers.<[server]>.travel_menu_slot]>
      - inventory set slot:<[slot]> o:<[item].with[hides=all;display=<[display]>;lore=<[lore]>;flag=run_script:travel_menu_open_tab;flag=server:<[server]>;flag=slot:<[slot]>]> d:<[inventory]>
    # Active Server Tab, or not
    - if <[tab]> == <bungee.server>:
      - define type active
    - else:
      - define type inactive
    # Inventory title Overlays
    - adjust <[inventory]> title:<&f><&font[adriftus:travel_menu]><&chr[F808]><&chr[1001]><&chr[F703]><script.parsed_key[data.title_data.<[tab]>.<[type]>]>
    # If inactive, build "travel to server" buttons
    - if <[type]> == inactive:
      - foreach <script.data_key[data.inactive_slots]>:
        - inventory set slot:<[value]> "o:feather[custom_model_data=3;display=<&a>Travel To Server;flag=run_script:travel_menu_to_server;flag=server:<[tab]>]" d:<[inventory]>
    - else:
      - choose <[tab]>:
        # HeroCraft tab
        - case herocraft:
          - foreach <script.data_key[data.herocraft.waystones]>:
            - inventory set slot:<[value]> o:town_waystones_info d:<[inventory]>
          - foreach <script.data_key[data.herocraft.items].keys>:
            - inventory set slot:<script.data_key[data.herocraft.items.<[value]>]> o:<[value]>_info d:<[inventory]>
          - inventory set slot:<script.data_key[data.herocraft.gui_waystone]> o:travel_menu_gui_waystone[lore=<&sp.repeat_as_list[250]>] d:<[inventory]>
        # Calipolis tab
        - case calipolis:
          - foreach <script.data_key[data.calipolis.items].keys>:
            - foreach <script.data_key[data.calipolis.items.<[value]>]> as:slot:
              - inventory set slot:<[slot]> o:travel_menu_calipolis_<[value]>_icon d:<[inventory]>
        # Hub tab
        - case hub:
          - foreach <script.data_key[data.hub_slots]> key:warp_name as:slots:
            - foreach <[slots]> as:slot:
              - inventory set slot:<[slot]> d:<[inventory]> o:<item[hub_warp_<[warp_name]>_icon].with[flag=warp_id:<[warp_name]>;flag=run_script:hub_warp]>
        # test tab
        - case test:
          - narrate test
        # build tab
        - case build:
          - narrate test
    - inventory open d:<[inventory]>

travel_menu_to_world:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - teleport <player> <context.item.flag[world].spawn_location>

travel_menu_open_tab:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - ratelimit <player> 10t
    - run travel_menu_open def:<context.item.flag[server]>

travel_menu_to_server:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - adjust <player> send_to:<context.item.flag[server]>

travel_menu_inventory:
  type: inventory
  debug: false
  inventory: chest
  title: <&a>Travel!
  gui: true
  size: 54

hub_warp:
  type: task
  debug: false
  script:
    - define warpName <context.item.flag[warp_id]>
    - teleport <player> hub_warp_<[warpName]>
    - playsound <player> sound:ENTITY_ENDERMAN_TELEPORT
    - playeffect effect:PORTAL at:<player.location> visibility:500 quantity:500 offset:1.0
    - actionbar "<proc[reverse_color_gradient].context[Teleporting to <[warpName].replace[_].with[ ].to_titlecase>|#6DD5FA|#FFFFFF]>"

## Herocraft
travel_menu_show_recipe:
  type: task
  debug: false
  script:
    - run custom_recipe_inventory_open def:<context.item.flag[item_recipe]>|1|travel

multiverse_dust_info:
  type: item
  material: feather
  display name: <element[Multiverse Dust].rainbow>
  lore:
    - <&6>Travel To Zan'Zar!
    - <&6>Full of Challenge and Adventure
    - <&e>- Over 5000 dungeons
    - <&e>- 100+ Loot Tables!
    - <&e>- Custom Mobs & Enchantments
    - <&b>-- Click to see Crafting Recipe --
  mechanisms:
    custom_model_data: 500
  flags:
    run_script: travel_menu_show_recipe
    item_recipe: shaped_recipe_multiverse_dust_1

return_scroll_info:
  type: item
  material: feather
  display name: <&6>Return Scroll
  lore:
    - <&6>Saves Location when Crafted
    - <&6>Returns you there when used
    - <&e>- 2,000 Block Range
    - <&e>- Replaces <&a>/home
    - <&b>-- Click to see Crafting Recipe --
  mechanisms:
    custom_model_data: 200
  flags:
    run_script: travel_menu_show_recipe
    item_recipe: shapeless_recipe_return_scroll_1

back_scroll_info:
  type: item
  material: feather
  display name: <&6>Back Scroll
  lore:
    - <&6>Return to your death location
    - <&e>- 2,000 Block Range
    - <&e>- Replaces <&a>/back
    - <&b>-- Click to see Crafting Recipe --
  mechanisms:
    custom_model_data: 201
  flags:
    run_script: travel_menu_show_recipe
    item_recipe: shapeless_recipe_back_scroll_1

town_return_scroll_info:
  type: item
  material: feather
  display name: <&6>Town Scroll
  lore:
    - <&6>Teleports you to a Town Spawn
    - <&e>- 2,000 Block Range
    - <&e>- Replaces <&a>/t spawn
    - <&b>-- Click to see Crafting Recipe --
  mechanisms:
    custom_model_data: 202
  flags:
    run_script: travel_menu_show_recipe
    item_recipe: shapeless_recipe_town_return_scroll_1

tpa_crystal_info:
  type: item
  material: feather
  display name: <&6>TPA Crystal
  lore:
    - <&6>Request Teleportation
    - <&e>- Unlimited Range
    - <&e>- Capable of Crossing Dimensions
    - <&e>- Replaces <&a>/tpa
    - <&b>-- Click to see Crafting Recipe --
  mechanisms:
    custom_model_data: 102
  flags:
    run_script: travel_menu_show_recipe
    item_recipe: shaped_recipe_tpa_crystal_1

return_crystal_info:
  type: item
  material: feather
  display name: <&6>Return Crystal
  lore:
    - <&6>Saves Location when Crafted
    - <&6>Returns you there when used
    - <&e>- Unlimited Range
    - <&e>- Capable of Crossing Dimensions
    - <&e>- Replaces <&a>/home
    - <&b>-- Click to see Crafting Recipe --
  mechanisms:
    custom_model_data: 101
  flags:
    run_script: travel_menu_show_recipe
    item_recipe: shaped_recipe_return_crystal_1

back_crystal_info:
  type: item
  material: feather
  display name: <&6>Back Crystal
  lore:
    - <&6>Return to your death location
    - <&e>- Unlimited Range
    - <&e>- Capable of Crossing Dimensions
    - <&e>- Replaces <&a>/back
    - <&b>-- Click to see Crafting Recipe --
  mechanisms:
    custom_model_data: 100
  flags:
    run_script: travel_menu_show_recipe
    item_recipe: shaped_recipe_back_crystal_1

town_return_crystal_info:
  type: item
  material: feather
  display name: <&6>Town Crystal
  lore:
    - <&6>Teleports you to a Town Spawn
    - <&e>- Unlimited Range
    - <&e>- Capable of Crossing Dimensions
    - <&e>- Replaces <&a>/t spawn
    - <&b>-- Click to see Crafting Recipe --
  mechanisms:
    custom_model_data: 103
  flags:
    run_script: travel_menu_show_recipe
    item_recipe: shaped_recipe_town_return_crystal_1

town_waystones_info:
  type: item
  material: feather
  display name: <&6>Waystones
  lore:
    - <&e>Waystones are free fast travel
    - <&e>Some need to be discovered
    - <&e>Some are unlocked for all
    - <&e>Towns can even place their own!
    - <&b>Right Click a stone to travel
  mechanisms:
    custom_model_data: 3

travel_menu_gui_waystone:
  type: item
  material: feather
  display name: <&font[adriftus:overlays]><&chr[F90F]>

# Home Lore Warp

travel_menu_calipolis_home_icon:
  type: item
  debug: false
  display name: <&6>Homes
  lore:
  - "<&6>You House!"
  material: feather
  mechanisms:
    custom_model_data: 3
  flags:
    run_script: cancel

travel_menu_calipolis_lore_icon:
  type: item
  debug: false
  display name: <&6>Lore
  lore:
  - "<&6>Lore Locations!"
  material: feather
  mechanisms:
    custom_model_data: 3
  flags:
    run_script: calipolis_lore_locations_open

travel_menu_calipolis_warp_icon:
  type: item
  debug: false
  display name: <&6>Warps
  lore:
  - "<&6>Warps!"
  material: feather
  mechanisms:
    custom_model_data: 3
  flags:
    run_script: cancel

