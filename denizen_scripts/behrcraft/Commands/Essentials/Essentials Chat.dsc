PlayerChat_Command:
    type: command
    name: playerchat
    usage: /playerchat <&lt>messsage<&gt>
    description: na
    permission: Behrry.Essentials.chat
    aliases:
        - c
    script:
        - if <context.args.size> == 0:
            - inject Command_Syntax Instantly
        - if <context.server>:
            - announce "<&2>[<&a>Console<&2>] <&a>B<&b>e<&a>hr<&b>: <&7><context.raw_args>"
        - else:
            - announce "<player.display_name><&b>:<&f> <context.raw_args>"

        