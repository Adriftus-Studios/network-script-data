heal_command:
    type: command
    name: heal
    usage: /heal (player)
    description: Heals a player
    permission: adriftus.staff
    script:
    - if <context.args.size> > 1:
        - inject command_syntax
    - if <context.args.is_empty>:
        - heal <player>
        - feed amount:20 <player>
        - narrate "You have been healed"
    - else:
        - define user <context.args.first>
        - inject player_verification
        - heal <[user]>
        - feed amount:20 <[user]>
        - narrate "<[user].name> has been healed"
        - narrate "<player.name> has healed you" targets:<[user]>
