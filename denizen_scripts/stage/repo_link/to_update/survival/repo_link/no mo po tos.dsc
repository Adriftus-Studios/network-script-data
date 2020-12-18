no_ortals_alright:
  type: world
  debug: false
  events:
    on entity creates portal:
      - if <context.portal_type> == ender:
        - determine cancelled
    on player right clicks end_portal_frame with:ender_eye:
      - narrate "no no no no no!"
      - determine cancelled
