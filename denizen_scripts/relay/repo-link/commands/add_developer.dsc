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
      - define uuid <util.random.uuid.before[-]>
      - define url https://github.com/login/oauth/authorize?client_id=293a70069291db7790ea&scope=repo&state=<[author].id>_<[uuid]>
    #^- bungeerun relay github_oauth def:<[author].id>_<[uuid]>|add
      - discord id:adriftusbot message channel:<[channel]> <&lt><[url]><&gt>
