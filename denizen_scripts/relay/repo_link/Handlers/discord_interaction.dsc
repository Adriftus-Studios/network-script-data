discord_interaction_handler:
  type: task
  debug: false
  script:
    - define query <util.parse_yaml[<context.query>]>
    - choose <[query].get[version]>:
      - case 1:
        - determine passively code:200
        - determine passively <map[type=1].to_json>