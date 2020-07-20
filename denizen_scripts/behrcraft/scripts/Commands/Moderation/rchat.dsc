rchat:
    type: command
    name: rchat
    usage: /rchat
    description: Types as a named player, or random name
    permission: Behrry.Developmental
    script:
        - if <context.args.size> < 2:
            - inject Command_Syntax Instantly
        - if <context.args.get[1]> == random:
            - if !<server.has_flag[Behrry.Developmental.RchatQueue]>:
                - flag server Behrry.Developmental.RchatQueue:|:<script.yaml_key[Random].random[99]>
            - define Name <server.flag[Behrry.Developmental.RchatQueue].first>
            - flag server Behrry.Developmental.RchatQueue:<-:<[Name]>
            - flag server Behrry.Developmental.RchatQueue:->:<[Name]>
        - else:
            - define Name <context.args.get[1]>
        - announce "<&7><[Name]><&b>:<&r> <context.raw_args.after[<context.args.get[1]><&sp>].parse_color>"
    random:
        - bob
        - Tom_Hansen
        - Katy_Perry
        - Steve
        - Gooby
        - Sandwich
        - Majeejee
        - Naruto
        - David
        - goliath
        - isabella
        - Scooby-Doo
        - Peach
        - Ass
        - Cow
        - Bonquiqui
        - Nuggies
        - Pussyman
        - PenisBreth
        - Thomas_Jefferson
        - George_Washington