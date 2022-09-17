context_menu_events:
  type: world
  debug: false
  events:
    on player right clicks player with:air:
      - ratelimit <player.uuid>_<context.entity.uuid> 5s
      - if <player.is_sneaking>:
        - define prompt "<&e><player.proc[get_player_display_name]> wants to trade with you!"
        - flag <context.entity> tmp.trade_target:<player> expire:30s
        - narrate targets:<player> "<&e>You requested to trade with <context.entity.proc[get_player_display_name]>."
        - run chat_confirm "def:<[prompt]>|context_menu_trade_confirmed" player:<context.entity>

context_menu_trade_confirmed:
  type: task
  debug: false
  definitions: result
  script:
    - if <[result]>:
      - run trade_open def:<player.flag[tmp.trade_target]>
    - else:
      - narrate "<&c>You denied <player.flag[tmp.trade_target].proc[get_player_display_name]>'s Trade Request"
      - narrate "<&c><player.proc[get_player_display_name]> Denied your trade request." targets:<player.flag[tmp.trade_target]>

open_context_menu:
  type: task
  debug: false
  data:
    points:
      - <player.eye_location.below[0.3].forward[1].up[0.1]>
  script:
    - define target <context.entity>
    - define options <list[trade]>
    - define points <script.parsed_key[data.points]>
    - foreach <[options].get[1].to[<[points].size>]>:
      - fakespawn context_menu_<[value]> <[points].get[<[loop_index]>]> duration:10s save:option
      - flag <entry[option].faked_entity> target:<context.entity>

context_menu_trade:
  type: entity
  debug: false
  entity_type: armor_stand
  mechanisms:
    equipment:
      helmet: feather[custom_model_data=1]
    visible: false
    custom_name: <&a>Trade
    custom_name_visible: true
    is_small: true
  flags:
    right_click_script: context_trade_initiate

context_trade_initiate:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - run trade_open def:<context.entity.flag[target]>
