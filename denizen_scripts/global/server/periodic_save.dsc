denizen_periodic_save:
  type: world
  debug: true
  events:
    on delta time minutely every:5:
      - adjust server save
