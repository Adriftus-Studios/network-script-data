murdermobs_Command:
    type: command
    name: murdermobs
    debug: false
    description: Murders the mobs around all players.
    usage: /murdermobs (Radius) (Mobs)
    permission: Behr.Essentials.Murdermobs
    RadiusCheck:
        - if <[Radius]> < 0:
            - narrate "<proc[Colorize].context[Radius cannot be negative.|red]>"
            - stop
        - if <[Radius]> >= 24000:
            - narrate "<proc[Colorize].context[Radius cannot exceed 100.|red]>"
            - stop
        - if <[Radius].contains[.]>:
            - narrate "<proc[Colorize].context[Radius cannot contain decimals.|red]>"
            - stop
    tab complete:
        - define Args <list[Bat|Bee|Blaze|Cave_Spider|Chicken|Cod|Cow|Creeper|Dolphin|Donkey|Drowned|Elder_Guardian|Ender_Dragon|Enderman|Endermite|Evoker|Fox|Ghast|Giant|Guardian|Horse|Husk|Illusioner|Iron_Golem|Llama|Magma_Cube|Minecart|Mule|Mushroom_Cow|Ocelot|Panda|Parrot|Phantom|Pig|Pig_Zombie|Pillager|Polar_Bear|Pufferfish|Rabbit|Salmon|Sheep|Shulker|Silverfish|Skeleton|Skeleton_Horse|Snowman|Spider|Squid|Stray|Tropical_Fish|Turtle|Vex|Villager|Vindicator|Witch|Wither|Wolf|Zombie|Zombie_Horse|Zombie_Villager]>
        - inject OneArg_Command_Tabcomplete
    script:
    # % ██ [ Check Args ] ██
        - if <context.args.size> > 2:
            - inject Command_Syntax
    
    # % ██ [ Check for Default ] ██
        - if <context.args.first||null> == null:
            - define Radius 50
            - define Mobs Hostiles
        
    # % ██ [ Check First Arg ] ██
        - else if <context.args.first.is_integer>:
            - define Radius <context.args.first>
            - inject Locally RadiusCheck
        - else if <server.entity_types.include[All|Hostiles].exclude[Player].contains_any[<context.args.first.split[,]>]>:
            - define Mobs <context.args.first.split[,]>
        - else:
            - inject Command_Syntax

    # % ██ [ Check for Default Second Arg ] ██
        - if <context.args.get[2]||null> == null:
            - if <[Radius]||null> != null:
                - define Mobs Hostiles
            - else:
                - define Radius 50

    # % ██ [ Check Second Arg ] ██
        - else if <context.args.get[2].is_integer>:
            - if <[Radius]||null> != null:
                - inject Command_Syntax
            - define Radius <context.args.get[2]>
            - inject Locally RadiusCheck
        - else if <server.entity_types.include[All|Hostiles].exclude[Player].contains_any[<context.args.get[2].split[,]>]>:
            - if <[Mobs]||null> != null:
                - inject Command_Syntax
            - define Mobs <context.args.get[2].split[,]>
        - else:
            - inject Command_Syntax

    # % ██ [ Murder ] ██
        #- foreach <server.online_players> as:Player:
        - if <[Mobs]> == all:
            - remove <Player.location.find.entities.within[<[Radius]>].filter[is_living].filter[is_player.not].filter[is_npc.not]>
        - else if <[Mobs]> == Hostiles:
            - remove <Player.location.find.entities.within[<[Radius]>].filter[is_monster]>
        - else:
            - remove <Player.location.find.entities.within[<[Radius]>].filter[entity_type.contains_any[<[Mobs]>]]>




