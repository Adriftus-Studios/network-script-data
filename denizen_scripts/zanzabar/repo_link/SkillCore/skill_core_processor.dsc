skill_core_processor:
  type: world
  debug: false
  events:
    after script reload:
      - flag server skills:!
      - flag server skill:!
      # Define The Different lists of scripts we'll need to parse
      - define data_scripts <server.scripts.filter[container_type.equals[data]]>
      - define skill_trees <[data_scripts].filter[name.starts_with[impl_skilltree_]]>
      - define skills <[data_scripts].filter[name.starts_with[impl_skill_]]>

      # Build the different skill trees reference script flag
      - foreach <[skill_trees]> as:skill_tree:
        - flag server skills.trees.<[skill_tree].data_key[name]>.script:<[skill_tree]>

      # Build The reference flag for each skill script
      - foreach <[skills]> as:skill:
        - define skill_tree <[skill].data_key[skill_tree]>
        # If skill name is already in the setup, error with conflict
        - if <server.has_flag[skill.abilities.<[skill].data_key[name]>]>:
          - debug error "Duplicate skill name (<[skill].data_key[name]>) in script <[skill].name>, conflicting script: <server.flag[skills.abilities.<[skill].name>].name>"
        # If the skill tree exists, build the ability structure
        - else if <server.has_flag[skills.trees.<[skill_tree]>.script]>:
          - flag server skills.trees.<[skill_tree]>.<[skill].data_key[name]>:<[skill]>
          - flag server skills.abilities.<[skill].data_key[name]>:<[skill]>
        # If it gets this far, error with an unknown skill tree
        - else:
          - debug error "Skill from script <[skill].name> has an unknown Skill Tree: <[skill_tree]>"

skill_core_use:
  type: task
  debug: false
  definitions: skill
  script:
    # Check for the Global Cooldown
    - if <player.has_flag[skills.cooldowns.global]>:
      - narrate "<&c>You have <player.flag_expiration[skills.cooldowns.global].from_now.formatted> before you can use an ability again."

    # Check that the entity has the ability
    - if !<player.has_flag[skills.abilities.<[skill]>]>:
      - narrate "<&c>You do not have this skill."
      - stop

    # Cooldown Check
    - if <player.has_flag[skills.cooldowns.<[skill]>]>:
      - actionbar "<&c><[skill].replace[_].with[<&sp>].to_titlecase> is on cooldown<&co> <player.flag_expiration[skills.cooldowns.<[skill]>].from_now.formatted>"
      - stop

    # Make sure the skill is currently loaded
    - if !<server.has_flag[skills.abilities.<[skill]>]>:
      - debug error "<&c>Unknown skill used: <[skill]>"
      - narrate "<&c>This skill is disabled/deactivated, contact administration if you believe this is an error"
      - stop

    # get our definitions from the data script
    - define skill_script <server.flag[skills.abilities.<[skill]>]>
    - define targets <[skill_script].parsed_key[targetting_tags].combine.if_null[null].exclude[null]>

    # Make sure there are valid targets
    - if <[targets].is_empty>:
      - debug error "Skill <[skill]> had errors in targetting tags."
      - actionbar <[skill_script].parsed_key[messages.no_target]>
      - stop
    - define targets <[targets].get[1]> if:<[targets].size.equals[1]>

    # Inject the skill script itself
    - run <[skill_script].data_key[on_cast]> def:<list_single[<[targets]>]> save:skill

    # Cooldown if successful
    - if <entry[skill].created_queue.determination.get[1]||true>:
      - flag player skills.cooldowns.<[skill]> duration:<[skill_script].data_key[cooldown]||30s>
      - flag player skills.cooldowns.global duration:1.5s
