no_end_travel_events:
  type: world
  debug: false
  events:
    on player right clicks end_portal_frame:
    - determine cancelled

no_nether_travel_events:
  type: world
  debug: false
  events:
    on portal created because fire:
    - determine cancelled