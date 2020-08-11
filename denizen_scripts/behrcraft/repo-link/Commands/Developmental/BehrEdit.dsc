BStaff:
  type: item
  debug: false
  material: golden_hoe
  display name: "<&2>B<&e>e<&a>hr<&2>E<&a>dit <&2>S<&a>taff"
  lore:
    - <&6>M<&e>ode<&b>: <&3>S<&3>ingle <&b>C<&3>uboid
    - <&6>P<&e>osition 1<&b>: <&3>Left<&b>-<&3>Click
    - <&6>P<&e>osition 2<&b>: <&3>Right<&b>-<&3>Click
  enchantments:
    - BINDING_CURSE
  mechanisms:
    hides: HIDE_ALL

BehrEdit_Command:
    type: command
    debug: false
    name: be
    usage: /BEdit Commands
    description: BehrEdit Commands
    permission: test
    aliases:
        - bStaff
        - bSel
    Commands:
        bStaff: Gives you the staff.
    Syntax:
        - define Hover "<&2>C<&a>lick <&2>f<&a>or <&2>H<&a>elp"
        - define Text "<&b>C<&3>lick <&b>f<&3>or <&b>h<&3>elp<&b>."
        - define Command "be help"
        - narrate "<&4>I<&c>nvalid <&4>U<&c>sage<&4>. <proc[MsgCmd].context[<[Hover]>|<[Text]>|<[Command]>]>"
    script:
        - choose <context.args.first||<context.alias||null>>:
            - case Help be:
                - narrate "<&8><&M>+-------<&2><&M>-----<&a><&M>----<&2>[ <&2>B<&e>e<&a>hr<&2>E<&a>dit <&2>C<&a>ommands <&2>]<&a><&M>----<&2><&M>-----<&8><&M>-------+"
                - foreach <script.list_keys[Commands]> as:Command:
                    - define D <script.data_key[Commands.<[Command]>]>
                    - define Text <&6>/<&e><[Command]>
                    - define Hover "<&2>S<&a>hift<&e>-<&2>C<&a>lick <&2>t<&a>o <&2>I<&a>nsert<&e>:<&nl><[Text]>"
                    - define Insert /<[Command]><&sp>
                    - define C <proc[MsgHoverIns].context[<[Hover]>|<[Text]>|<[Insert]>]>
                    - narrate "<&8><&M>+-<&l>}<&6>/<&e><[C]> <&b>| <&3><[D]>"
                - narrate "<&8><&M>+-------<&2><&M>-----<&a><&M>----<&2>[ <&a>L <&2>]<&a><&M>---<&2><&M>--<&8><&M>-<&2><&M>--<&a><&M>---<&2>[ <&a>R <&2>]<&a><&M>----<&2><&M>-----<&8><&M>-------+"
            - case BStaff:
                - narrate hi
            - case bSel:
                - choose <context.args.size>:
                    - case 2:
                        - define ModeQty <context.args.first>
                        - if <list[Single|Multiple].contains[<[ModQty]>]>:
                            - inject Locally Syntax
                            - define ModeType <context.args.get[2]>
                        - if !<list[Cuboid].contains[<[ModeType]>]>:
                            - inject Locally Syntax
                    - case 3:
                        - define ModeQty <context.args.get[2]>
                        - if <list[Single|Multiple].contains[<[ModQty]>]>:
                            - inject Locally Syntax
                            - define ModeType <context.args.get[3]>
                        - if !<list[Cuboid].contains[<[ModeType]>]>:
                            - inject Locally Syntax
                    - default:
                        - inject Locally Syntax
                - narrate "Setting Mode"

            - default:
                - inject Locally Syntax

testing:
    type: task
    debug: false
    script:
        - foreach <server.entity_types> as:entity:
            - spawn <[Entity]> save:s
            - wait 1t
            - if <entry[s].spawned_entity.is_tamed||invalid> != invalid:
                - define list:->:<[Entity]>
            - wait 1t
            - remove <entry[s].spawned_entity>
        - debug approval "<&2>T<&A>amable <&2>E<&A>ntities<&4>: <[list].comma_separated.replace[,].with[<&6>,<&e> ]>"


#@PianoGoBing:
#@  type: world
#@  debug: false
#@  events:
#@    on player clicks red_carpet in:TestPianoSeat:
#^      - determine passively cancelled
#^      - spawn armor_stand[visible=false;invulnerable=true] <context.location.center.below[2.2].with_yaw[180]> save:seat
#^      - mount <player>|<entry[seat].spawned_entity> <context.location.center.below[2.2].with_yaw[180]>
#^      - wait 2m
#^      - remove <entry[seat].spawned_entity>
#@    on player clicks smooth_quartz_stairs in:TestPiano priority:-2:
#^      - define KeyLoc <player.eye_location.precise_cursor_on>
#^      - playeffect at:<[KeyLoc].above[1]> effect:note offset:0.1
#^      - playsound <[KeyLoc]> sound:Block_Note_Block_Pling volume:2 pitch:<[KeyLoc].x.sub[2315].div[2]>
#^      - determine cancelled
#@    on player breaks block in:TestPiano:
#^      - determine cancelled


narrater:
    type: task
    debug: false
    script:
        - foreach <player.world.entities.parse[entity_type].deduplicate> as:entity:
            - debug approval "<&a><[Entity]><&b>: <&e><player.world.entities[<[Entity]>].size>"
            - wait 1t
fuckloadedchunks:
    type: task
    debug: false
    script:
        - define size <server.worlds.exclude[<world[world]>].parse[loaded_chunks.size].sum>
        - foreach <list[world_nether|world_the_end|Runescape50px1|Creative|SkyBlock]> as:World:
            - foreach <world[<[World]>].loaded_chunks> as:Chunk:
                - adjust <[Chunk]> unload
                - if <[loop_index].mod[10]> == 0:
                    - wait 1t

FuckLuckPerms:
    type: task
    debug: false
    script:
        - foreach <script[GroupSetters].list_keys[players]> as:Player:
            - foreach <script[GroupSetters].data_key[players.<[Player]>]> as:Group:
                - execute as_server "lp user <[Player]> parent add <[Group]>"
                - wait 1t
            - define ListedPlayers:->:<server.match_player[<[Player]>]||null>
        #- foreach <server.players.exclude[<[ListedPlayers]>].parse[name]> as:Player:
        #    - if <[Player]> == null:
        #        - foreach next
        #    - foreach <list[Silent|Visitor|Patron]> as:Group:
        #        - execute as_server "lp user <[Player]> parent add <[Group]>"
        #        - wait 1t
    #    - foreach <script[PermissionNodes].data_key[silent]> as:Node:
    #        - execute as_server "lp group silent permission unset <[Node]>"
    #        - execute as_server "lp group silent permission set <[Node]>"
GroupSetters:
    type: data
    players:
        behr_riley:
            - moderation
            - coordinator
            - constructor
            - sponsor
            - patron
            - visitor
            - silent
        faience:
            - moderation
            - administrator
            - moderator
            - constructor
            - sponsor
            - patron
            - visitor
            - silent
        foxchirpz:
            - moderation
            - administrator
            - moderator
            - constructor
            - sponsor
            - patron
            - visitor
            - silent

        indestructoyed:
            - moderation
            - moderation
            - administrator
            - moderator
            - constructor
            - sponsor
            - patron
            - visitor
            - silent
        
        expertabyss:
            - moderation
            - moderator
            - constructor
            - sponsor
            - patron
            - visitor
            - silent
        gracefulpelican:
            - moderation
            - moderator
            - constructor
            - sponsor
            - patron
            - visitor
            - silent
        spiteful_cabbage:
            - moderation
            - moderator
            - constructor
            - sponsor
            - patron
            - visitor
            - silent
        KUwUipo101:
            - moderation
            - moderator
            - constructor
            - sponsor
            - patron
            - visitor
            - silent
        pheyyy:
            - moderation
            - moderator
            - constructor
            - sponsor
            - patron
            - visitor
            - silent
        
        polgesmohol:
            - constructor
            - sponsor
            - patron
            - visitor
            - silent

        


PermissionNodes:
    type: data

    patron:
    - Behrry.Essentials.Repair
    - Behrry.Essentials.Hat
    - Behrry.Essentials.github
    - Behrry.Essentials.Droplock
    visitor:
    - behrry.essentials.suicide
    - behrry.essentials.resourcepack
    - behrry.essentials.nickname
    silent:
    - Behrry.Essentials.Back
    - Behrry.Essentials.Clearchat
    - Behrry.Essentials.Colors
    - Behrry.Essentials.DBack
    - Behrry.Essentials.Delhome
    - Behrry.Essentials.Discord
    - Behrry.Essentials.Donate
    - Behrry.Essentials.Dynmap
    - behrry.Essentials.Friend
    - Behrry.Essentials.Help
    - Behrry.Essentials.Home
    - Behrry.Essentials.Ignore
    - Behrry.Essentials.Me
    - Behrry.Essentials.Msg
    - behrry.essentials.ping
    - behrry.essentials.playtime
    - behrry.essentials.renamehome
    - behrry.essentials.rtp
    - behrry.essentials.rules
    - behrry.essentials.seen
    - behrry.essentials.sethome
    - Behrry.Essentials.Skin
    - behrry.essentials.teleport
    - behrry.essentials.tpaccept
    - behrry.essentials.tpdecline
    - behrry.essentials.tphere
    - behrry.essentials.sethome
    - behrry.essentials.website
    - behrry.essentials.world


