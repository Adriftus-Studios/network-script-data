no_ortals_alright:
  type: world
  debug: false
  events:
    on entity creates portal:
      - if <context.portal_type> == ender:
        - determine cancelled
