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
    ignored:
      chat : true
  events:
    on command permission:adriftus.admin:
      - if !<script.data_key[data.ignored.<context.command>].exists>:
        - bungeerun relay discord_sendMessage "def:Adriftus Staff|manager-logs|`<bungee.server>`<&co>`<player.name>` ran command `<context.command> <context.raw_args>`"
