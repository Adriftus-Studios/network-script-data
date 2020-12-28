
sethome_command:
  type: command
  debug: false
  name: sethome
  description: Sets your home to your current location
  usage: /sethome
  script:
  - if <player.world.environment> != end:
    - flag player home:<player.location>
    - narrate "<&a>You have set your home at <&2>X: <&b><player.location.center.x><&a>, <&2>Y: <&b><player.location.center.y><&a>, <&2>Z: <&b><player.location.center.z><&a>!"
  - else:
    - narrate "<&f>You cannot set a home in the end."

delhome_command:
  type: command
  debug: false
  name: delhome
  description: Removes your current home
  usage: /delhome
  script:
  - if !<player.has_flag[home]>:
    - narrate "<&c>You do not currently have a home set to delete"
  - else:
    - if !<player.has_flag[delete_confirmation]>:
      - narrate "<&e>Are you sure you want to delete your home? This <&c>cannot<&e> be undone!"
      - narrate "<&e>Type <&b>/Delhome<&e> to confirm."
    - else:
      - flag player home:!
      - narrate "<&e>Your home location has been cleared."

home_command:
  type: command
  debug: false
  name: home
  usage: /home
  description: Teleports to your home
  script:
  - if <player.flag[home]||null> != null:
    - teleport <player.flag[home]>
    - narrate "<&a>You have been teleported home!"
  - else:
    - narrate "<&f>You have not set a home."

home_respawn_event:
  type: world
  debug: false
  events:
    on player respawns bukkit_priority:HIGHEST ignorecancelled:true:
    - determine passively <player.flag[home]||spawn>
    - flag player fallImmunity d:10s
    - narrate "<&a>You have 10 seconds of spawn protection."
    - wait 10s
    - narrate "<&a>Your spawn protection has worn off."
    on player damaged flagged:fallImmunity:
    - determine cancelled
    on player enters bed:
    - if <player.has_flag[home]>:
      - stop
    - else:
      - flag player home:player.location
