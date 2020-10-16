Donate_Command:
    type: command
    name: donate
    debug: false
    description: Gives you the donate link.
    usage: /donate
    permission: Behr.Essentials.Donate
    script:
    # % ██ [ Check Args ] ██
        - if !<context.args.is_empty>:
            - inject Command_Syntax

    # % ██ [ Print Donate Link ] ██
        - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[https://www.paypal.com/paypalme2/BearRiley|blue]>"
        - define Text "<proc[Colorize].context[Click for the Link to:|yellow]> <&3><&n>P<&b><&n>ay<&3><&n>P<&b><&n>al"
        - define URL https://www.paypal.com/paypalme2/BearRiley
        - narrate <proc[msg_url].context[<[Hover]>|<[Text]>|<[URL]>]>
