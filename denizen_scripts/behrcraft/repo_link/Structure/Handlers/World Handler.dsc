World_Handler:
    type: world
    debug: false
    events:
        on player places wither_skeleton_skull|tnt|bedrock|end_crystal|ender_chest:
            - if !<player.is_op>:
                - determine cancelled
        on player changes world to creative:
            - if <player.has_flag[Behrry.Moderation.CreativeBan]>:
                - wait 1t
                - narrate format:Colorize_Red "You are currently Creative-Banned."
                - teleport <player> <location[0,200,0,world]>
            - if !<player.in_group[Moderation]>:
                - adjust <player> gamemode:Creative
        on player changes world to World:
            - if !<player.in_group[Moderation]>:
                - adjust <player> gamemode:Survival
        #@on server prestart:
        #^    - createworld Old_Worlds/1_15/world
        #^    - createworld Hub
        #^    - createworld Runescape50px1
        #^    - createworld Creative
        #^    - createworld SkyBlock
        #@on player damaged by void in:SkyBlock:
        #^    - determine passively cancelled
        #^    - define Velocity <player.velocity>
        #^    - teleport <player> <player.location.with_world[world].with_y[350].with_pose[<player>]>
        #^    - adjust <player> velocity:<[Velocity]>
        #@on player enters SkyLandsAir:
        #^    - define Velocity <player.velocity>
        #^    - teleport <player> <player.location.with_world[SkyBlock].with_y[-50].with_pose[<player>]>
        #^    - adjust <player> velocity:<[Velocity]>
        on server start:
            - foreach <server.worlds.exclude[<world[world]>]> as:world:
                - adjust <[world]> keep_spawn:false
