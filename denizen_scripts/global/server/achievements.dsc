achievement_data:
  type: data
  GUI:
    - '&a----------------------------------'
    - '&a- <[name]>'
    - '&a----------------------------------'
    - '&a- <[description]>'
    - '&a- <[reward_text]>'
    - '&a----------------------------------'
  parents:
    survival:
      icon: grass_block
      name: 'Survival'
      description: 'Adriftus Survival'
      background: 'minecraft:textures/gui/advancements/backgrounds/stone.png'
  achievements:
    First_RTP:
      reward:
        script: title_unlock/Explorer
        text: '&bYou have unlocked a new title!'
      icon: ender_pearl
      name: '&6Your First RTP'
      description: '&eYou have started your journey by randomly teleporting for the first time.'
      parent: survival
      frame: task
      announce: false
      hidden: false
      offset:
        x: 0
        y: 0

achievement_give:
  type: task
  definitions: id
  script:
    - if <script[achievement_data].data_key[achievements.<[id]>]||null> == null:
      - error
    - else:
      - define name <script[achievement_data].data_key[achievements.<[id]>.name].parse_color>
      - define description <script[achievement_data].data_key[achievements.<[id]>.description].parse_color>
      - define reward_text <script[achievement_data].data_key[achievements.<[id]>.reward.text].parse_color>
      - foreach <script[achievement_data].data_key[GUI].parse[parse_color.parsed]>:
        - narrate <[value]>
      - run <script[achievement_data].data_key[achievements.<[id]>.reward.script].before[/]> def:<script[achievement_data].data_key[achievements.<[id]>.reward.script].after[/]>
      - advancement id:<[id]> grant:<player>

achievement_data_load:
  type: world
  debug: false
  events:
    on server start:
      # -- Create list of parents (root advancements) achievements will use.
      - foreach <script[achievement_data].list_keys[parents]> as:id:
        - advancement id:<[id]> icon:<script[achievement_data].data_key[parents.<[id]>.icon]> title:<script[achievement_data].data_key[parents.<[id]>.name]> description:<script[achievement_data].data_key[parents.<[id]>.description]> background:<script[achievement_data].data_key[parents.<[id]>.background]>

      # -- Create list of achievements as in-game advancements.
      - foreach <script[achievement_data].list_keys[achievements]> as:id:
        - advancement id:<[id]> parent:<script[achievement_data].data_key[achievements.<[id]>.parent]> icon:<script[achievement_data].data_key[achievements.<[id]>.icon]> title:<script[achievement_data].data_key[achievements.<[id]>.name].parse_color> description:<script[achievement_data].data_key[achievements.<[id]>.description].parse_color> frame:<script[achievement_data].data_key[achievements.<[id]>.frame]> hidden:<script[achievement_data].data_key[achievements.<[id]>.hidden]> x:<script[achievement_data].data_key[achievements.<[id]>.offset.x]> y:<script[achievement_data].data_key[achievements.<[id]>.offset.y]>
