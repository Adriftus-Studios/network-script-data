Day_command:
    type: command
    name: Day
    usage: /day
    aliases:
    - daymanfighterofthenightman
    description: Sets to daytime
    permission: adriftus.staff
    script:
    - time global 1000t <player.world>
    - Announce "<&e>Time set to <&dq>Day<&dq> by <player.display_name>"

Night_command:
    type: command
    name: night
    usage: /night
    description: Sets to nighttime
    permission: adriftus.staff
    script:
    - time global 13000t <player.world>
    - Announce "<&e>Time set to <&dq>Night<&dq> by <player.display_name>"
