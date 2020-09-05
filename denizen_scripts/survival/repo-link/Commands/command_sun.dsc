Sun_command:
    type: command
    name: sun
    usage: /sun
    alias:
    - sunny
    - ihaterain
    - effthunder
    description: Sets to weather to sunny
    permission: adriftus.staff
    script:
    - weather sunny mainland reset:10m
    - Announce "<&e>Weather set to <&dq>Clear<&dq> by <player.display_name>"
