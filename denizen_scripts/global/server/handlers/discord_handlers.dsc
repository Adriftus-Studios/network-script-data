Reload_Task:
  type: task
  definitions: Hook
  script:
    - flag server ReloadHook:<[Hook]> duration:1s
    - reload

Reload_Error_Detection:
  type: world
  debug: false
  events:
    on reload scripts:
      - if <server.has_flag[ReloadHook]>:
        - if !<context.had_error>:
          - define Color Code
          - define title "Scripts Reloaded"
        - else:
          - define color Red
          - define title "Scripts Reloaded (With Errors)"
        - define ScriptCount <server.scripts.size>
        - bungeerun Relay Reload_Response def:<[Color]>|<[Title]>|<bungee.server>|<[ScriptCount]>|<server.flag[ReloadHook]>
