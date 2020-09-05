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

    - define discord_id <[query_map].get[discord_id]>
    - if !<yaml[discord_links].contains[discord_ids.<[discord_id]>]>:
      - announce to_console "User does not have discord linked."
      - stop

    - announce raw_args:<[raw_args]>
    - announce message:<[message].message>
    - announce mentions:<[message].mentions>
    - announce formatted_mentions:<[message].formatted_mentions>
    - stop
    - define uuid <util.random.uuid.before[-]>
    - define developer_id <[args].first>
    - define url https://github.com/login/oauth/authorize?client_id=293a70069291db7790ea&scope=repo&state=<[developer_id]>_<[uuid]>
  #^- bungeerun relay github_oauth def:<[author].id>_<[uuid]>|add
    - discord id:adriftusbot message channel:<[channel]> <&lt><[url]><&gt>
