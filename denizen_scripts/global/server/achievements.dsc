achievement_data:
  type: data
  GUI:
    - <&a>----------------------------------
    - <&a>- <[name]>
    - <&a>----------------------------------
    - <&a>- <[description]>
    - <&a>- <[reward_text]>
    - <&a>----------------------------------
  parents:
    hub:
      icon: paper[custom_model_data=201]
      name: <&color[#010000]>Hub
      description: <&e>Welcome to Adriftus!
      background: minecraft:textures/gui/advancements/backgrounds/stone.png
    herocraft:
      icon: paper[custom_model_data=202]
      name: <&color[#010000]>Herocraft
      description: <&e>A battleground of Heroes and Villains
      background: adriftus:textures/advancements/herocraft.png
    calipolis:
      icon: paper[custom_model_data=203]
      name: <&color[#010000]>Calipolis
      description: <&e>Lore Driven Awesome SMP!
      background: minecraft:textures/gui/advancements/backgrounds/stone.png
  achievements:
    ## Herocraft
    joined_herocraft:
      icon: diamond_sword
      name: <&color[#010000]>Welcome To Herocraft!
      description: <&e>First RTP
      parent: denizen:herocraft
      frame: challenge
      sound: true
      announce: true
      hidden: false
      offset:
        x: 1
        y: 5
    failed_hot_drop:
      reward_script: herocraft_mission_1_start
      icon: elytra
      name: <&6>Well, That's One Way Down...
      description: <&e>Died on First Join
      parent: denizen:joined_herocraft
      frame: task
      sound: false
      announce: true
      hidden: true
      offset:
        x: 1
        y: 4
    completed_hot_drop:
      reward_script: herocraft_mission_1_start
      icon: elytra
      name: <&6>Nailed The Landing
      description: <&e>Survived the Hot Drop
      parent: denizen:joined_herocraft
      frame: task
      sound: true
      announce: true
      hidden: true
      offset:
        x: 1
        y: 4
    first_campsite:
      reward_script: herocraft_mission_2_start
      icon: campfire
      name: <&6>Your First... Home?
      description: <&e>Created a Campsite!
      parent: denizen:joined_herocraft
      frame: task
      sound: true
      announce: false
      hidden: false
      offset:
        x: 3
        y: 6
    joined_town:
      reward_script: herocraft_mission_2_start
      icon: campfire
      name: <&6>Your First... Home?
      description: <&e>Joined A Town!
      parent: denizen:joined_herocraft
      frame: task
      sound: true
      announce: false
      hidden: false
      offset:
        x: 4
        y: 6
    first_return_scroll:
      reward_script: herocraft_mission_3_start
      icon: feather[custom_model_data=200]
      name: <&6>Now You're Travelling
      description: <&e>Crafted A Return Scroll
      parent: denizen:joined_herocraft
      frame: task
      sound: true
      announce: false
      hidden: false
      offset:
        x: 3
        y: 5
    first_mission_complete:
      reward_script: herocraft_mission_4_start
      icon: diamond_sword
      name: <&6>Your First Steps
      description: <&e>Completed a Mission
      parent: denizen:first_return_scroll
      frame: task
      sound: true
      announce: true
      hidden: false
      offset:
        x: 5
        y: 6
    ## Hub
    welcome_to_adriftus:
      icon: paper[custom_model_data=301]
      name: <&6>Main Menu
      description: <&e>Opened the Main Menu!
      parent: denizen:hub
      frame: task
      sound: false
      announce: false
      hidden: false
      offset:
        x: -1
        y: 4
    welcome_to_adriftus1:
      icon: paper[custom_model_data=300]
      name: <&6>Adriftus Chest
      description: <&e>Opened the Adriftus Chest!
      parent: denizen:hub
      frame: task
      sound: false
      announce: false
      hidden: false
      offset:
        x: -1
        y: 6
    welcome_to_adriftus2:
      icon: paper[custom_model_data=302]
      name: <&6>Crafting Table
      description: <&e>Opened the Crafting Grid!
      parent: denizen:hub
      frame: task
      sound: false
      announce: false
      hidden: false
      offset:
        x: 1
        y: 6
    welcome_to_adriftus3:
      icon: paper[custom_model_data=303]
      name: <&6>Travel Menu
      description: <&e>Opened the Travel Menu!
      parent: denizen:hub
      frame: task
      sound: false
      announce: false
      hidden: false
      offset:
        x: 1
        y: 4

achievement_give_parent:
  type: task
  debug: false
  definitions: id
  script:
    - if <script[achievement_data].data_key[parents.<[id]>].if_null[invalid]> == invalid:
      - debug error "Invalid ID from achievement_give script in achievements.dsc. Ideally, scripts that read manual input **should never error.**"
      - stop
    - stop if:<player.has_advancement[denizen<&co><[id]>]>

    - advancement id:<[id]> grant:<player>
    - adjust <player> save_advancements

achievement_give:
  type: task
  debug: false
  definitions: id
  script:
    - if <script[achievement_data].data_key[achievements.<[id]>]||invalid> == invalid:
      - debug error "Invalid ID from achievement_give script in achievements.dsc. Ideally, scripts that read manual input **should never error.**"
      - stop
    - stop if:<player.has_advancement[denizen<&co><[id]>]>

    - define name <script[achievement_data].parsed_key[achievements.<[id]>.name]>
    - define description <script[achievement_data].parsed_key[achievements.<[id]>.description]>
    #- foreach <script[achievement_data].parsed_key[GUI]>:
    #  - narrate <[value]>
    - if <script[achievement_data].data_key[achievements.<[id]>.reward_script].exists>:
      - run <script[achievement_data].parsed_key[achievements.<[id]>.reward_script]> def:<script[achievement_data].data_key[achievements.<[id]>.reward.script].after[/]>
    - advancement id:<[id]> grant:<player>
    - adjust <player> save_advancements

achievement_data_load:
  type: world
  debug: false
  events:
    on server prestart:
      # -- Create list of parents (root advancements) achievements will use.
      - foreach <script[achievement_data].list_keys[parents]> as:id:
        - advancement id:<[id]> icon:<script[achievement_data].parsed_key[parents.<[id]>.icon]> title:<script[achievement_data].parsed_key[parents.<[id]>.name]> description:<script[achievement_data].parsed_key[parents.<[id]>.description]> background:<script[achievement_data].parsed_key[parents.<[id]>.background]> x:0 y:5

      # -- Create list of achievements as in-game advancements.
      - foreach <script[achievement_data].list_keys[achievements]> as:id:
        - advancement id:<[id]> parent:<script[achievement_data].parsed_key[achievements.<[id]>.parent]> icon:<script[achievement_data].data_key[achievements.<[id]>.icon]> title:<script[achievement_data].parsed_key[achievements.<[id]>.name]> description:<script[achievement_data].parsed_key[achievements.<[id]>.description]> frame:<script[achievement_data].parsed_key[achievements.<[id]>.frame]> hidden:<script[achievement_data].data_key[achievements.<[id]>.hidden]> x:<script[achievement_data].data_key[achievements.<[id]>.offset.x]> y:<script[achievement_data].data_key[achievements.<[id]>.offset.y]>
