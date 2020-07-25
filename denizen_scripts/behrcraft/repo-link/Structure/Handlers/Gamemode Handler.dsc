
GameMode_Handler:
    type: world
    debug: false
    events:
        on player changes gamemode:
            - if <context.gamemode> == Creative && <player.has_flag[Behrry.Moderation.CreativeBan]>:
                - narrate format:Colorize_Red "You are currently Creative-Banned."
                - determine cancelled
            - if <player.has_flag[gamemode.inventory.changebypass]>:
                - flag player gamemode.inventory.changebypass:!
            - else:
                - flag player gamemode.inventory.<player.gamemode>:!|:<player.inventory.list_contents>

            - inventory clear
            - if <player.has_flag[gamemode.inventory.<context.gamemode>]>:
                - inventory set d:<player.inventory> o:<player.flag[gamemode.inventory.<context.gamemode>]>
            - else:
                - flag player gamemode.inventory.<context.gamemode>:!|:<player.inventory.list_contents>
