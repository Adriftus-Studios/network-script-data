herocraft_deny_creative:
  type: world
  debug: false
  events:
    on player changes gamemode to creative:
      - determine cancelled

herocraft_command_monitoring:
  type: world
  debug: false
  events:
    on command permission:adriftus.admin:
      - bungeerun relay discord_sendMessage "def:A Staff|manager-logs|<player.name> ran command <context.command> <context.raw_args>"