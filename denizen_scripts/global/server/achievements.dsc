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
    herocraft:
      icon: paper[custom_model_data=202]
      name: <&color[#010000]>Herocraft
      description: <&e>A battleground of Heroes and Villains
      background: minecraft:textures/gui/advancements/backgrounds/stone.png
  achievements:
    joined_herocraft:
      reward_script: herocraft_mission_1
      icon: diamond_sword
      name: <&color[#010000]>Welcome To Herocraft!
      description: <&e>Joined the Battle!
      parent: denizen:herocraft
      frame: task
      announce: true
      hidden: false
      offset:
        x: 1
        y: 5
    failed_hot_drop:
      reward:
        script: herocraft_mission_2
      icon: elytra
      name: <&6>Well, That's One Way Down...
      description: <&e>Died on First Join
      parent: denizen:joined_herocraft
      frame: task
      announce: true
      hidden: true
      offset:
        x: 2
        y: 4
    completed_hot_drop:
      reward:
        script: herocraft_mission_2
      icon: elytra
      name: <&6>Nailed The Landing
      description: <&e>Survived the Hot Drop
      parent: denizen:joined_herocraft
      frame: task
      announce: true
      hidden: true
      offset:
        x: 2
        y: 4
    firt_return_scroll:
      reward:
        script: herocraft_mission_3
      icon: feather[custom_model_data=200]
      name: <&6>Now You're Travelling
      description: <&e>Crafted A Return Scroll
      parent: denizen:joined_herocraft
      frame: task
      announce: true
      hidden: false
      offset:
        x: 2
        y: 5
    first_mission_complete:
      reward:
        script: herocraft_mission_4
      icon: feather[custom_model_data=200]
      name: <&6>Your First Steps
      description: <&e>Complete a Mission
      parent: denizen:firt_return_scroll
      frame: task
      announce: true
      hidden: false
      offset:
        x: 3
        y: 5

achievement_give:
  type: task
  debug: false
  definitions: id
  script:
    - if <script[achievement_data].data_key[achievements.<[id]>]||invalid> == invalid:
      - debug error "Invalid ID from achievement_give script in achievements.dsc. Ideally, scripts that read manual input **should never error.**"
      - stop

    - define name <script[achievement_data].parsed_key[achievements.<[id]>.name]>
    - define description <script[achievement_data].parsed_key[achievements.<[id]>.description]>
    - foreach <script[achievement_data].parsed_key[GUI]>:
      - narrate <[value]>
    - run <script[achievement_data].parsed_key[achievements.<[id]>.reward_script]> def:<script[achievement_data].data_key[achievements.<[id]>.reward.script].after[/]>
    - advancement id:<[id]> grant:<player>

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
