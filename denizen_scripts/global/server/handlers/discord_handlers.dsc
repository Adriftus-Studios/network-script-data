Reload_Task:
  type: task
  debug: false
  definitions: hook
  script:
    - flag server reload_hook:<[hook]> duration:1s
    - reload

Reload_Error_Detection:
  type: world
  debug: false
  events:
    on reload scripts:
      - if <server.has_flag[reload_hook]>:
        - if !<context.had_error>:
          - define color Code
          - define title "Scripts Reloaded"
        - else:
          - define color Red
          - define title "Scripts Reloaded (With Errors)"
        - define script_count <server.scripts.size>
        - bungeerun relay reload_response def:<[Color]>|<[title]>|<bungee.server>|<[script_count]>|<server.flag[reload_hook]>
