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
    - narrate "<element[Happy Pride Month!].rainbow>"
    - narrate <element[---------------------].rainbow>
    - narrate "Let's make things a little more... <&color[#000001]>Colorful<&r>!"
    - narrate "<&e>You have unlocked a new title!! <&b>/titles"
    - narrate "<&e>You can also use colors in chat and when renaming items in an anvil!<&nl>You can also link your held item by putting [item] in chat.<&nl>&z, &y, and &x are our custom color codes, try em out!"