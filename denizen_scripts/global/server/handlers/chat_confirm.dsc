chat_confirm:
  type: task
  debug: false
  data:
    agree_text: <&a><&lb>Accept<&rb>
    deny_text: <&4><&lb>Deny<&rb>
  definitions: prompt|callback
  script:
    - run chat_pause
    - define uuid <util.random_uuid>
    - clickable chat_confirm_handler def:true|<[uuid]>|<[callback]> save:accept
    - clickable chat_confirm_handler def:false|<[uuid]>|<[callback]> save:deny
    - narrate <element[------------------].color_gradient[from=<color[aqua]>;to=<color[white]>]>
    - narrate <[prompt]><&nl><&nl>
    - define list:!|:<element[<script[chat_confirm].parsed_key[data.agree_text]>].on_click[<entry[accept].command>]>
    - define list:|:<element[<script[chat_confirm].parsed_key[data.deny_text]>].on_click[<entry[deny].command>]>
    - narrate "   <[list].separated_by[          ]>"
    - narrate <element[------------------].color_gradient[from=<color[aqua]>;to=<color[white]>]>

chat_confirm_handler:
  type: task
  debug: false
  definitions: result|UUID|callback
  script:
    - if !<player.has_flag[tmp.chat_confirm.<[uuid]>]>:
      - flag player tmp.chat_confirm.<[uuid]> duration:30s
      - run chat_unpause
      - run <[callback]> def:<[result]>