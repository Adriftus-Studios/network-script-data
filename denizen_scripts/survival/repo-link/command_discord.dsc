command_discord:
  type: command
  name: discord
  description: Join the discord - discord.adriftus.com
  usage: /discord
  tab complete:
    - discord
  script:
    - playsound <player> sound:entity_player_levelup
    - narrate <&7>+--------------------------------------------------+
    - narrate ""
    - narrate "                  <&a>Join us in discord"
    - narrate ""
    - narrate "            <&6>https://discord.adriftus.com"
    - narrate ""
    - narrate <&7>+--------------------------------------------------+
