Add_Developer_DCommand:
  type: task
  debug: false
  PermissionRoles:
  # % ██ [ Staff Roles  ] ██
    - Lead Developer

  # % ██ [ Public Roles ] ██
    - Lead Developer
  definitions: Message|Channel|Author|Group
  script:
  # % ██ [ Clean Definitions & Inject Dependencies ] ██
    - inject Role_Verification
    - inject Command_Arg_Registry

    - if <[message_object].formatted_mentions.is_empty>:
      - announce to_console "Invalid Syntax. No users specified."
      - stop

    - define new_developers <list>
    - define baddies <list>
    - define developer_role <discordrole[adriftusbot,626078288556851230,626082447347679243]>
    - define title "`[Adriftus Test Environment Invitation]`"
    - foreach <[message_object].formatted_mentions> key:discord_user_name as:discord_user:
      - if !<yaml[discord_links].contains[discord_ids.<[discord_user].id>]>:
        - define baddies <[baddies].include_single[<[discord_user]>]>
        - announce to_console "User does not have discord linked."
        - foreach next
      - define new_developers <[new_developers].include_single[<[discord_user]>]>
      - if !<[discord_user].roles[<[group]>].contains[<[developer_role]>]>:
        - discord id:adriftusbot add_role user:<[discord_user]> role:<[developer_role]> group:<[group]>
        
      - define user_id <[discord_user].id>
      - define uuid <util.random.uuid.before[-]>
    #^- bungeerun relay github_oauth def:<[author].id>_<[uuid]>|add
      - define url https://github.com/login/oauth/authorize?client_id=293a70069291db7790ea&scope=repo&state=<[user_id]>_<[uuid]>
      - define context "<list_single[You've been invited to become a colaborator for Adriftus. Click the link above to authorize our GitHub connections. By providing authorization, you will receive the following:]>"
      - define context "<[context].include_single[:diamond_shape_with_a_dot_inside: **Remote Testing Environment** | Your pre-generated testing environment will be generated based on configurations reflecting the live server.]>"
      - define context "<[context].include_single[:diamond_shape_with_a_dot_inside: **Developmental Domain**: You will receive a subdomain pointing to your testing environment. The subdomain will be initialized after authorizing the application and will be based on an alias; eg: `<[discord_user].name.substring[0,4]>.behr.dev`.]>"
      - define context "<[context].include_single[:diamond_shape_with_a_dot_inside: **Triage Management Access**: You'll earn access to manage issues and create pull requests to contribute upstream to Adriftus Studios projects.]>"
    #^- define embed "<discordembed.title[`[Adriftus Test Environment Invitation]`].description[<[context].separated_by[<n>]>].url[<[url]>]>"
    #^- discord id:adriftusbot user:<[discord_user]> send_embed embed:<[embed]>

    #^- define embed <map.with[embed].as[<map.with[url].as[<[url]>].with[color].as[16774144].with[title].as[<[title]>].with[description].as[<[context].separated_by[<n>]>]>]>
    #^- define headers <yaml[saved_headers].parsed_key[Bot_Auth]>
      - discord id:adriftusbot message user:<[discord_user]> <[title]><n><&lt><[url]><&gt><n><[context].separated_by[<n>]>

    #$ /adddev @Behr#5305
    - define context <list>
    - if !<[new_developers].is_empty>:
      - if <[new_developers].size> == 1:
        - define context "<[context].include_single[<[new_developers].first.mention> is now a <[developer_role].mention>!]>"
      - else:
        - define context "<[context].include_single[<[new_developers].parse[mention].formatted> are now <[developer_role].mention>s!]>"

    - if !<[baddies].is_empty>:
      - if <[baddies].size> == 1:
        - define context "<[context].include_single[<n>**Note**:<[baddies].first.mention> does not have a Discord link established. <n>Please use the `/discord connect` command in-game to link your Discord account with your Minecraft account. You must have an established Discord link to collaborate within the Adriftus Testing Environment.]>"
      - else:
        - define context "<[context].include_single[<n>**Note**:<[baddies].parse[mention].formatted> do not have Discord links established. <n>Please use the `/discord connect` command in-game to link your Discord account with your Minecraft account. You must have an established Discord link to collaborate within the Adriftus Testing Environment.]>"

    - define channel_id <[channel]>
    - inject get_webhooks

    - define embeds "<list[<map.with[title].as[Developer Information].with[color].as[16766976].with[description].as[<[context].separated_by[<n>]>]>]>"
    - define data "<map.with[username].as[Git Handler].with[avatar_url].as[https://cdn.discordapp.com/attachments/642764810001448980/715739998980276224/server-icon.png].with[embeds].as[<[embeds]>].to_json>"

    - define headers <yaml[saved_headers].read[discord.webhook_message]>
    - ~webget <[hook]> data:<[data]> headers:<[headers]>
