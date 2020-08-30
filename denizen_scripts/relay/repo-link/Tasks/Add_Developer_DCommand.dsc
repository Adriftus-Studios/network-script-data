Add_Developer_DCommand:
  type: task
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

    - if <[args].is_empty>:
      - stop
    - else if <[args].first> == discordtest:
      - define uuid <util.random.uuid>
      - define url https://discord.com/api/oauth2/authorize?client_id=716381772610273430&redirect_uri=http<&pc>3A<&pc>2F<&pc>2F147.135.7.85<&pc>3A25580<&pc>2FoAuth<&pc>2FDiscord&response_type=code&scope=identify<&pc>20connections&state=<player.uuid>_<[uuid]>
      - bungeerun relay discord_oauth def:<player.uuid>_<[uuid]>|add
      - discord id:adriftusbot message channel:<[channel]> <&lt><[url]><&gt>
