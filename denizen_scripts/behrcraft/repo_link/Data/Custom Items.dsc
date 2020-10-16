MagicSword:
    type: item
    debug: false
    material: golden_sword
    display name: <&6>M<&e>agic <&6>S<&e>word
    enchantments:
        - sharpness:10
    mechanisms:
        unbreakable: true
        hides: all

MagicSwordHandler:
    type: world
    debug: false
    events:
        on entity damages player:
            - if <player.has_flag[Behrry.Combat.Invulnerable]>:
                - determine cancelled
        on player damages entity:
            - if <context.cause> == projectile:
                - adjust <context.entity> no_damage_duration:1t
                - flag player Behrry.Combat.Cooldown:!
            #- narrate "<&e>Normal<&2>: <&a><context.final_damage>"
            #- narrate "<&e>New<&2>: <&a><proc[DamageProc].context[<context.damager>|<context.entity>|<context.cause>].max[<context.final_damage>].mul[<element[1].sub[<player.flag[Behrry.Combat.Cooldown].expiration.in_ticks.div[13]||1>]>].round_to_precision[0.01]>"
            - if <player.has_flag[Behrry.Combat.MultiTargetDedupe]>:
                #- narrate "<&c>Old<&4>: <&e><context.final_damage>"
                #- narrate "<&e>Dedupe<&6>: <&a><player.flag[Behrry.Combat.MultiTargetDedupe]>"
                - determine <player.flag[Behrry.Combat.MultiTargetDedupe].round_to_precision[0.01]||<context.final_damage>>
            - else if <player.has_flag[Behrry.Combat.Cooldown]>:
                - define Damage <proc[DamageProc].context[<context.damager>|<context.entity>|<context.cause>].max[<context.final_damage>].mul[<element[1].sub[<player.flag[Behrry.Combat.Cooldown].expiration.in_ticks.div[13]||1>]>].round_to_precision[0.01]||<context.final_damage>>
                #- narrate "<&c>Old<&4>: <&e><context.final_damage>"
                #- narrate "<&e>New<&6>: <&a><[Damage]>
                - flag player Behrry.Combat.Cooldown duration:13t
                - flag player Behrry.Combat.MultiTargetDedupe:<[Damage]> duration:1t
                - determine <[Damage]>
            - else:
                - define Damage <proc[DamageProc].context[<context.damager>|<context.entity>|<context.cause>].max[<context.final_damage>].round_to_precision[0.01]||<context.final_damage>>
                - flag player Behrry.Combat.Cooldown duration:13t
                - flag player Behrry.Combat.MultiTargetDedupe:<[Damage]> duration:1t
                #- narrate "<&c>Old<&4>: <&e><context.final_damage>"
                #- narrate "<&e>New<&6>: <&2><[Damage]>"
                - determine <[Damage]>
        on player right clicks block with:MagicSword:
            - if <player.target||null> == null:
                - stop
            - if !<player.target.is_spawned>:
                - stop
            - define PLoc <player.location>
            - define TLoc <player.target.location>
            - define Points <[PLoc].points_between[<[TLoc]>].distance[1]>

            - if <[Points].size> > 3 && <[Points].size> < 25:
                - flag player Behrry.Combat.Invulnerable duration:10t
                - define Distance <[PLoc].forward[<[Points].size.sub[2]>].center.add[0,0.5,0]>
                - define Dloc <[Distance].find.surface_blocks.within[4].filter[x.is[==].to[<[Distance].x>]].filter[z.is[==].to[<[Distance].z>]].first.add[0,1.1,0].with_yaw[<[Ploc].yaw>].with_pitch[<[PLoc].pitch>]>
                - if <player.is_on_ground>:
                    - define PVel <player.velocity.mul[0.55]>
                - else:
                    - define PVel <player.velocity.mul[1.1]>
                - define Vector <player.location.sub[<[TLoc]>].normalize.mul[0.5]>
                - define BVel <[Vector].x>,0.4,<[Vector].z>

                - playeffect <[DLoc]> offset:0 flash targets:<player.location.find.players.within[20].exclude[<player.location.find.players.within[3]>]>
                - if <[Points].size> > 7:
                    - teleport <player> <[DLoc]>
                - else:
                    - adjust <player> velocity:<Player.eye_location.add[<player.location.direction.vector.mul[2]>].sub[<player.location>].x>,0,<Player.eye_location.add[<player.location.direction.vector.mul[2]>].sub[<player.location>].z>
                - wait 4t
                - adjust <player> velocity:<[PVel].add[<[BVel]>].div[2]>
                - animate <player> animation:arm_swing
                - foreach <[PLoc].points_between[<[Dloc]>].distance[0.1]> as:Loc:
                    - playeffect <[Loc]> SMOKE_NORMAL offset:0.25 quantity:2
                - repeat 3:
                    - playeffect effect:portal at:<[Dloc].add[0,0.5,0]> quantity:20 data:-1 offset:2
                    - wait 1t
                - playeffect <player.location.forward[0.75]> targets:<player> offset:0.25 sweep_attack
                - repeat 5:
                    - playeffect <player.location.forward[0.75]> targets:<player.location.find.players.within[20].exclude[<player>]> offset:0.25 sweep_attack
                    - wait 1t
                - foreach <[DLoc].forward[1].find.entities.within[2].filter[is_mob]> as:Mob:
                    - if !<[Mob].is_spawned>:
                        - foreach next
                    - playeffect <[Mob].location.add[0,1,0]> offset:0.25 explosion_normal quantity:15
                    - define Damage <proc[DamageProc].context[<player>|<[Mob]>|ENTITY_ATTACK].add[5].round_to_precision[0.01]>
                    - if !<[Mob].has_flag[smacked]>:
                        - define Vector <[Mob].location.sub[<player.location>].normalize.mul[0.5]>
                        - adjust <[Mob]> velocity:<[Vector].x>,0.4,<[Vector].z>
                        - playeffect <[Mob].location.add[0,0.5,0]> offset:0.25 magic_crit data:1 quantity:50
                        - flag <[Mob]> smacked duration:0.45s
                    - hurt <[Mob]> <[Damage]> source:<player>
                    - run add_xp def:<[Damage]>|Magic instantly
