
sethome_command:
  type: command
  name: sethome
  script:
  - if <player.location.world.environment> != end:
    - note <player.location> as:home_<player.uuid>
  - else:
    - narrate "<&f>You cannot sethome in the end."

delhome_command:
  type: command
  name: delhome
  script:
  - note remove as:home_<player.uuid>
  - narrate "<&f>Home removed."

home_command:
  type: command
  name: home
  script:
  - if <location[home_<player.uuid>]||null> != null:
    - teleport <location[home_<player.uuid>]>
  - else:
    - narrate "<&f>You have not set a home."

home_respawn_event:
  type: world
  events:
    on player respawns bukkit_priority:HIGHEST ignorecancelled:true:
      - determine <location[home_<player.uuid>]||<location[spawn]>>