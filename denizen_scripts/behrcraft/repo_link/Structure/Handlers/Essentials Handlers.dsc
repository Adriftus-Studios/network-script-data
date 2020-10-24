Essentials:
    type: world
    debug: false
    events:
        on hanging breaks because obstruction:
                - determine cancelled
        on player right clicks Composter:
            - if <context.location.material.level> == 8 && <player.world.name> == Gielinor:
                - determine cancelled
        on player kicked:
            - if <context.reason> == "Illegal characters in chat":
                - determine cancelled
        on player dies:
            - flag player Behr.essentials.teleport.deathback:<player.location>
        #    - define key Behr.Essentials.Cached_Inventories
        #    - define YamlSize <yaml[<player.uuid>].read[<[Key]>].size||0>
        #    - define UID <yaml[<player.uuid>].read[<[Key]>].get[<[YamlSize]>].before[Lasagna]||0>
        #    - if <[YamlSize]> > 9:
        #        - foreach <yaml[<player.uuid>].read[<[Key]>].get[1].to[<[YamlSize].sub[9]>]>:
        #            - yaml id:<player.uuid> set <[Key]>:<-:<[Value]>
        #    - yaml id:<player.uuid> set <[Key]>:->:<[UID].add[1]>Lasagna<player.inventory.list_contents>
        #    - yaml id:<player.uuid> savefile:../../../../.playerdata/<player.uuid>.dsc
        on player respawns:
            - if <player.flag[settings.essentials.bedspawn]||false>:
                - determine passively <player.bed_spawn>
            - else:
                - determine passively <player.world.spawn_location>
        on pl|plugin|plugins command:
            - determine passively fulfilled
            - narrate "Plugins (4): <&a>BehrEdit<&f>, <&a>BehrEssentials<&f>, <&a>Citizens<&f>, <&a>Denizen<&f>"
        on player enters minecart:
            - define Vehicle <context.vehicle>
            - adjust <[Vehicle]> speed:0.5
        on player changes sign:
            - determine <context.new.parse[parse_color]>
        #on entity spawns because:natural in:1152Spawn:
        #    - if <context.reason> == natural:
        #        - determine cancelled
        #on entity spawns because:natural in:TestingRoom:
        #    - if <context.reason> == natural:
        #        - determine cancelled
        on player enters TestingRoom:
            - cast Night_Vision d:9999
        on player exits TestingRoom:
            - cast Night_Vision remove
            
VillageLeasher:
    type: world
    debug: false
    events:
        on player right clicks Villager with:Lead:
            - if !<context.entity.has_flag[ClickDedupe]>:
                - flag <context.entity> ClickDedupe duration:1t
                - if <context.entity.is_leashed>:
                    - if <context.entity.leash_holder> != <player>:
                        - determine cancelled
                    - else:
                        - stop
                - wait 1t
                - adjust <context.entity> leash_holder:<player>
                - take iteminhand
            - determine passively cancelled

        #on player damages player:
        #    - if <context.entity.gamemode||null> == creative:
        #        - if !<context.entity.has_flag[smacked]>:
        #            - define vector <context.entity.location.sub[<context.damager.location>].normalize.mul[0.5]>
        #            - adjust <context.entity> velocity:<def[vector].x>,0.4,<def[vector].z>
        #            - flag <context.entity> smacked duration:0.45s
        #        - playeffect effect:EXPLOSION_NORMAL at:<context.entity.location.add[0,1,0]> visibility:50 quantity:10 offset:0.5
        #        - playeffect effect:EXPLOSION_LARGE at:<context.entity.location.add[0,1,0]> visibility:50 quantity:1 offset:0.5
