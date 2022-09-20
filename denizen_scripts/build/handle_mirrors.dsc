handle_mirrors:
  type: world
  debug: false
  events:
    on server prestart:
    - createworld HeroCraft_mirror

tp_to_mirrors:
  type: command
  name: mirrortp
  description: teleport to a mirror
  usage: /mirrortp herocraft
  tab completions:
    1: <server.worlds.filter[ends_with[_mirror]].parse[name].include[flatworld]>
  script:
    - if <context.args.size> < 1:
      - narrate "<&c>Need to specify a mirror!"
      - stop
    - if !<server.worlds.parse[name].contains[<context.args.first>]> || <context.args.first> == flatworld:
      - narrate "<&c>Unknown Mirror<&co> <context.args.first>"
      - stop
    - teleport <world[<context.args.first>].spawn_location>
    - narrate "<&a>Teleported to Mirror!"