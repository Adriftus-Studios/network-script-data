Website_Command:
    type: command
    name: website
    debug: false
    description: Gives you the website link.
    usage: /website
    permission: behrry.essentials.website
    script:
        #@ Check Args
        - if <context.args.get[1]||null> != null:
            - inject Command_Syntax Instantly
        
        #@ Send Website Link
        - define Hover "<proc[Colorize].context[Click to follow Link:|green]><&nl><proc[Colorize].context[https://behrcraft.godaddysites.com/|blue]>"
        - define Text "<proc[Colorize].context[Click for the Link to:|yellow]> <&3><&n>B<&b><&n>ehrCraft.com"
        - define URL https://behrcraft.godaddysites.com/
        - narrate <proc[msgUrl].context[<def[Hover]>|<def[Text]>|<def[URL]>]>