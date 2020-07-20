WebgettestCommand:
    type: command
    name: webgettest
    usage: /webgettest
    description: don't
    permission: test
    script:
        - if <context.args.is_empty>:
            - inject Command_Syntax
        - else if <context.args.size> > 3:
            - inject COmmand_Syntax

        - define URL <context.args.first>
        - define Data <context.args.get[2]>
        - define Headers <context.args.get[3]>

        - ~webget <[URL]> Data:<[Data]> headers:<[Headers]> save:saveName

        #- announce to_console <entry[saveName].failed>
        - announce to_console <entry[saveName].result>
        #- announce to_console <entry[saveName].status>
        #- announce to_console <entry[saveName].time_ran>


testvent:
    type: world
    events:
        on player places *chest:
            - if <player.name> != behr_riley:
                - stop
            - narrate <context.location.other_block||invalid>