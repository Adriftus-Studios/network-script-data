# -- No /gamerule for OPs
mod_gamerule_listener:
  type: world
  debug: false
  events:
    on gamerule command:
      - if <player.is_op>:
        - determine FULFILLED
