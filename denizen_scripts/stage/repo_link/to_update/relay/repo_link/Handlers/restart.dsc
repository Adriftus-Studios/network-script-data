restart_handler:
  type: world
  debug: false
  events:
    on system time minutely every:5:
      - if <util.time_now.hour.mod[12]> == 1 && <util.time_now.minute> == 55:
        - adjust server restart
