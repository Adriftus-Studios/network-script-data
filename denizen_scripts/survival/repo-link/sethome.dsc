
sethome_command:
  type: command
  debug: false
  name: sethome
  script:
  - if <player.location.world.environment> != end:
    - note <player.location> as:home_<player.uuid>
    - narrate "<&a>You have set your home at <&2>X: <&b><player.location.center.x><&a>, <&2>Y: <&b><player.location.center.y><&a>, <&2>Z: <&b><player.location.center.z><&a>!"
  - else:
    - narrate "<&f>You cannot set a home in the end."

delhome_command:
  type: command
  debug: false
  name: delhome
  script:
  - note remove as:home_<player.uuid>
  - narrate "<&f>Home removed."

home_command:
  type: command
  debug: false
  name: home
  script:
  - if <location[home_<player.uuid>]||null> != null:
    - teleport <location[home_<player.uuid>]>
    - narrate "<&a>You have been teleported home!"
  - else:
    - narrate "<&f>You have not set a home."

home_respawn_event:
  type: world
  events:
    on player respawns bukkit_priority:HIGHEST ignorecancelled:true:
      - determine <location[home_<player.uuid>]||<location[spawn]>>
