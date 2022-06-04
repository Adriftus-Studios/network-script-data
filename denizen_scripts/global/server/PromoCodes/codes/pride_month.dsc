promo_code_pride:
  type: data
  expires: false
  expiration_date: <time[2022/07/1_00:00:00]>
  run_task: promo_code_pride_month_task

promo_code_pride_month_task:
  type: task
  debug: false
  script:
    - run titles_unlock def:LGBT
    - execute as_server "lp user <player.name> permission set adriftus.anvil.color"
    - execute as_server "lp user <player.name> permission set adriftus.chat.color"
    - execute as_server "lp user <player.name> permission set adriftus.chat.link_item"
    - narrate <element[----------------].rainbow>
    - narrate "<element[Happy Pride Month!].rainbow>"
    - narrate <element[----------------].rainbow>
    - narrate "<&color[#010000]>---- <&e>Let's make things a little more... <&color[#000001]>Colorful<&r>! <&color[#010000]>----"
    - narrate "<&6>- <&e>You have unlocked a new title!! <&b>/titles"
    - narrate "<&6>- <&e>You can also use colors in chat and when renaming items in an anvil!<&nl><&6>- <&e>You can also link your held item by putting <&b>[item]<&e> in chat.<&nl><&6>- <&b>&z<&e>, <&b>&y<&e>, and <&b>&x <&e>are our custom color codes, try em out!"