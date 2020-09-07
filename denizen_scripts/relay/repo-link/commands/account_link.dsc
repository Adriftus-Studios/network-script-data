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

    - if <[args].size> != 2 || <[message].formatted_mentions.size> != 1:
        - define context "<list_single[Syntax: `/discord_connect <&lt>@Discord_Ping<&gt> <&lt>Minecraft_Name<&gt>]>"
        - define embed "<discordembed.title[Invalid Command Syntax].description[<[context].separated_by[<n>]>].color[16774144].footer[You typed: <[command]> <[raw_args]>]>"
        - discord id:adriftusbot channel:<[channel]> send_embed embed:<[embed]>
    
    - foreach <[message].formatted_mentions> key:discord_name as:discord_user:
        - define discord_name <[discord_name]>
        - define discord_user <[discord_user]>

    - if <yaml[discord_links].contains[discord_ids.<[discord_user].id>]>:
        - define context "<list_single[<[discord_name]> is already connected to <yaml[discord_links].read[discord_ids.<[discord_user].id>.minecraft.name]>. If this is an error, request help from an Administrator or a Lead Developer for assistance on removing this link.]>"
        - define embed "<discordembed.title[Discord Already Linked].description[<[context].separated_by[<n>]>].color[16774144]>"
        - foreach stop

    - foreach survival|behrcraft|hub1 as:server:
        # $ this should be replaced with a YAML system to return UUIDs - $
        # $ based on global player names saved to relay directly ----  - $
        - ~bungeetag <map.with[player_uuid].as[<server.match_offline_player[<[args].get[2]>].uuid||invalid>].with[player_name].as[<server.match_offline_player[<[args].get[2]>].name||invalid>]||invalid> save:response
        - define response <entry[response].result>
        - if <list[invalid|null].contains[<[response]>]> || <[response].values.contains_any[invalid|null]>:
            - foreach next
        - else:
            - foreach <[response]>:
                - define <[key]> <[value]>
            - foreach stop
        # $ - -------------------------------------------------------- - $
    - if <list[invalid|null].contains[<[response]>]> || <[response].values.contains_any[invalid|null]>:
        - define context "<list_single[`<[args].get[2]>` is an invalid player, or was not found. Make sure you log into the game to verify you can properly be connected. Alternatively, type `/discord connect` in-game to link your discord account.]>"
        - define embed "<discordembed.title[Invalid Player].description[<[context].separated_by[<n>]>].color[16774144]>"
    - else:
        - define uuid <util.random.uuid>
        - define url https://discord.com/api/oauth2/authorize?client_id=716381772610273430&redirect_uri=http<&pc>3A<&pc>2F<&pc>2F147.135.7.85<&pc>3A25580<&pc>2FoAuth<&pc>2FDiscord&response_type=code&scope=identify<&pc>20connections&state=<[player_uuid]>_<[uuid]>
        - define context "<list_single[<[discord_name]> link invite created for `<[player_name]>` - please check your direct messages for the connection link.]>"
        - define embed "<discordembed.title[Invite Sent].description[<[context].separated_by[<n>]>].color[16774144]>"
        - discord id:adriftusbot message user:<[discord_user]> "Here's your Discord Connection link: <&lt><[url]><&gt><n> By connecting your discord, you will be linked to the minecraft account: <[player_name]>"
        - run discord_oauth def:<[player_uuid]>_<[uuid]>|add

    - discord id:adriftusbot channel:<[channel]> send_embed embed:<[embed]>
