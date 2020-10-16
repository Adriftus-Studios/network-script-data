Discord_Connect_DCommand:
  type: task
  debug: false
  PermissionRoles:
  # % ██ [ Staff Roles  ] ██
    - Lead Developer
    - Developer
    - Network Administrator
    - Administrator
    - Head Moderator
    - Moderator


  # % ██ [ Public Roles ] ██
    - Lead Developer
    - Developer
    - Network Administrator
    - Administrator
    - Head Moderator
    - Moderator

  definitions: Message|Channel|Author|Group
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject Role_Verification
    - inject Command_Arg_Registry

    - if <[args].size> != 2 || <[message_object].formatted_mentions.size> != 1:
        - define context "<list_single[Syntax: `/discord_connect <&lt>@Discord_Ping<&gt> <&lt>Minecraft_Name<&gt>`]>"
        - define title "Invalid Command Syntax"
        - define channel_id <[channel]>
        - inject get_webhooks

        - define embeds <list_single[<map.with[title].as[<[title]>].with[color].as[16766976].with[description].as[<[context].separated_by[<n>]>]>]>
        - define data "<map.with[username].as[Discord Handler].with[avatar_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png].with[embeds].as[<[embeds]>].to_json>"

        - define headers <yaml[saved_headers].read[discord.webhook_message]>
        - ~webget <[hook]> data:<[data]> headers:<[headers]>
        - stop
    
    - foreach <[message_object].formatted_mentions> key:discord_name as:discord_user:
        - define discord_name <[discord_name]>
        - define discord_user <[discord_user]>

    - if <yaml[discord_links].contains[discord_ids.<[discord_user].id>]>:
        - define context "<list_single[<[discord_user].mention> is already connected to `<yaml[discord_links].read[discord_ids.<[discord_user].id>.minecraft.display_name].strip_color.replace[<&ss>x]>`. If this is an error, request help from an Administrator or a Lead Developer for assistance on removing this link.]>"
        - define title "Discord Already Linked"
        - define channel_id <[channel]>
        - inject get_webhooks

        - define embeds <list_single[<map.with[title].as[<[title]>].with[color].as[16766976].with[description].as[<[context].separated_by[<n>]>]>]>
        - define data "<map.with[username].as[Discord Handler].with[avatar_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png].with[embeds].as[<[embeds]>].to_json>"

        - define headers <yaml[saved_headers].read[discord.webhook_message]>
        - ~webget <[hook]> data:<[data]> headers:<[headers]>
        - stop

    - foreach survival|behrcraft|hub1 as:server:
        # $ this should be replaced with a YAML system to return UUIDs - $
        # $ based on global player names saved to relay directly ----  - $
        - ~bungeetag server:<[server]> <map.with[player_uuid].as[<server.match_offline_player[<[args].get[2]>].uuid||invalid>].with[player_name].as[<server.match_offline_player[<[args].get[2]>].name||invalid>]||invalid> save:response
        - define response <entry[response].result>
        - if <list[invalid|null].contains[<[response]>]> || <[response].values.contains_any[invalid|null]>:
            - foreach next
        - else:
            - define player_uuid <[response].get[player_uuid]>
            - define player_name <[response].get[player_name]>
            - foreach stop
    - if <list[invalid|null].contains[<[response]>]> || <[response].values.contains_any[invalid|null]>:
        - define context "<list_single[`<[args].get[2]>` is an invalid player, or was not found. Make sure you log into the game to verify you can properly be connected. Alternatively, type `/discord connect` in-game to link your discord account.]>"
        - define title "Invalid Player"
        # $ - -------------------------------------------------------- - $
    - else:
        - define uuid <util.random.uuid>
        - define url https://discord.com/api/oauth2/authorize?client_id=716381772610273430&redirect_uri=http<&pc>3A<&pc>2F<&pc>2F147.135.7.85<&pc>3A25580<&pc>2FoAuth<&pc>2FDiscord&response_type=code&scope=identify<&pc>20connections&state=<[player_uuid]>_<[uuid]>
        - define context "<list_single[<[discord_user].mention> link invite created for `<[player_name]>` - please check your direct messages for the connection link.]>"
        - define title "Invite Sent"
        - discord id:adriftusbot message user:<[discord_user]> "Here's your Discord Connection link: <&lt><[url]><&gt><n> By connecting your discord, you will be linked to the minecraft account: <[player_name]>"
        - run discord_oauth def:<[player_uuid]>_<[uuid]>|add

    - define channel_id <[channel]>
    - inject get_webhooks

    - define embeds <list_single[<map.with[title].as[<[title]>].with[color].as[16766976].with[description].as[<[context].separated_by[<n>]>]>]>
    - define data "<map.with[username].as[Discord Handler].with[avatar_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png].with[embeds].as[<[embeds]>].to_json>"

    - define headers <yaml[saved_headers].read[discord.webhook_message]>
    - ~webget <[hook]> data:<[data]> headers:<[headers]>

#^  - discord id:adriftusbot channel:<[channel]> send_embed embed:<[embed]>
