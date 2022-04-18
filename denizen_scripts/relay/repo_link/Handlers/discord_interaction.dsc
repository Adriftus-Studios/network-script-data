discord_interaction_handler:
  type: task
  debug: true
  script:
    - if <context.headers.get[X-signature-ed25519]>
    - if <context.headers.get[X-Signature-Timestamp]>
    - define query <util.parse_yaml[<context.query>]>
    - choose <[query].get[version]>:
      - case 1:
        - determine passively code:200
        - determine passively '{"type": 1}'