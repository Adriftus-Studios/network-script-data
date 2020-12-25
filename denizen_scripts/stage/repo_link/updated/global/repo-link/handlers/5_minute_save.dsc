denizen_periodic_save:
  type: world
  debug: false
  events:
    on delta time minutely every:5:
      - adjust server save
