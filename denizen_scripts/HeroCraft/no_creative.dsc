herocraft_deny_creative:
  type: world
  debug: false
  events:
    on player changes gamemode to creative:
      - determine cancelled

herocraft_command_monitoring:
  type: world
  debug: false
  data:
    ignored_commands:
      msg: true
  events:
    on command permission:adriftus.staff:
      - stop if:<script.data_key[data.ignored_commands.<context.command>].exists>
      - announce to_console Fired
      - if <player.has_permission[adriftus.admin]>:
        - bungeerun relay discord_sendMessage "def:Adriftus Staff|manager-logs|`<bungee.server>`<&co>`<player.name>` ran command `<context.command> <context.raw_args>`"
      - else if <player.has_permission[adriftus.moderator]>:
        - bungeerun relay discord_sendMessage "def:Adriftus Staff|command-log|`<bungee.server>`<&co>`<player.name>` ran command `<context.command> <context.raw_args>`"