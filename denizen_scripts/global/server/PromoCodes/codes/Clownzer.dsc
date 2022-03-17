promo_code_syntrocity:
  type: data
  expires: false
  expiration_date: <time[2022/04/20_00:00:00]>
  run_task: promo_code_syntrocity_task

promo_code_clownzer_task:
  type: task
  debug: false
  script:
    - run title_unlock def:Synbreaker
    - narrate <element[---------------------].rainbow>
    - narrate "<element[Clownzer, Breaker of Syn].rainbow>"
    - narrate <element[---------------------].rainbow>
    - narrate "<&e>Has granted you a new title! <&b>/titles"