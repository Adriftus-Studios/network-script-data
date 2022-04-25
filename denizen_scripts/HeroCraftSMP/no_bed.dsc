no_bed:
  type: world
  debug: false
  events:
    on player right clicks *bed:
      - narrate "Sleep escapes you at the moment..."
      - determine cancelled