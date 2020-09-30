Player_Sitting:
    type: world
    debug: false
    events:
        on player right clicks *stairs with:air:
            - if <player.has_flag[Behrry.Essentials.Sitting]> || <context.location.material.half> == TOP || <player.world.name> == Creative:
                - stop
            - define Location <context.location>
            - inject Sit_Task Instantly
        on player steers armor_stand flagged:Behrry.Essentials.Sitting:
            - if <context.dismount>:
                - if <player.has_flag[Behrry.Essentials.AwkwardlySitting]>:
                    - teleport <player.location.add[0,1.5,0]>
                - else:
                    - teleport <player.location.add[0,0,0]>
                - remove <context.entity>
                - flag player Behrry.Essentials.Sitting:!

Sit_Command:
    type: command
    name: sit
    debug: false
    usage: /sit
    description: Sits.
    permission: Behrry.Essentials.Sit
    script:
        - define Location <player.location>
        - inject Sit_Task Instantly

Sit_Task:
    type: task
    debug: false
    script:
        - if <[Location].material.direction||invalid> != invalid:
            - choose <[Location].material.direction>:
                - case NORTH:
                    - spawn <[Location].add[0.5,-1.2,0.6]> armor_stand[visible=false;collidable=false;gravity=false;invulnerable=true] save:armor
                    - look <entry[armor].spawned_entity> <[Location].add[0.5,0,1]>
                - case SOUTH:
                    - spawn <[Location].add[0.5,-1.2,0.4]> armor_stand[visible=false;collidable=false;gravity=false;invulnerable=true] save:armor
                    - look <entry[armor].spawned_entity> <[Location].add[0.5,0,-1]>
                - case WEST:
                    - spawn <[Location].add[0.6,-1.2,0.5]> armor_stand[visible=false;collidable=false;gravity=false;invulnerable=true] save:armor
                    - look <entry[armor].spawned_entity> <[Location].add[1,0,0.5]>
                - case EAST:
                    - spawn <[Location].add[0.4,-1.2,0.5]> armor_stand[visible=false;collidable=false;gravity=false;invulnerable=true] save:armor
                    - look <entry[armor].spawned_entity> <[Location].add[-1,0,0.5]>

        - else:
            - spawn <[Location].add[0,-1.5,0]> armor_stand[visible=false;collidable=false;gravity=false;invulnerable=true] save:armor
            - flag player Behrry.Essentials.AwkwardlySitting

        - flag player Behrry.Essentials.Sitting
        - mount <player>|<entry[armor].spawned_entity>
