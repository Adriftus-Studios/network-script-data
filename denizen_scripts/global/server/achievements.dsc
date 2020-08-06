achievement_data:
  type: yaml data
  GUI:
    - '&a----------------------------------'
    - '&a- <[name]>'
    - '&a----------------------------------'
    - '&a- <[description]>'
    - '&a- <[reward_text]>'
    - '&a----------------------------------'
  achievements:
    First_RTP:
      reward:
        script: title_unlock/Explorer
        text: '&bYou have unlocked a new title!'
      description: '&eYou have started your journey by randomly teleporting for the first time.'
      name: '&6Your First RTP'


Achievement_give:
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
