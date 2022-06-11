rules_command:
  type: command
  name: rules
  debug: false
  description: Lists the rules for b
  usage: /rules
  permission: behr.essentials.rules
  script:
  # % ██ [ check if typing arguments ] ██
    - if !<context.args.is_empty>:
      - narrate "<&c>Invalid usage - /rules"

  # % ██ [ narrate the rules for b   ] ██
    - narrate "<&e>1<&6>. <&a>Use common sense."
