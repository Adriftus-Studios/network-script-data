animal_mimic_events:
    type: world
    debug: false
    events:
        after cow spawns because NATURAL:
            - stop if:<context.location.town.exists>
            - define chance 0.5
            - define chance:*:2 if:<context.location.world.has_storm>
            - if <util.random_chance[<[chance]>]>:
                - flag <context.entity> animal_mimic expire:5m
        on entity_flagged:animal_mimic dies:
            - stop if:<context.damager.is_player.not.if_null[true]>
            - determine passively cancelled
            - define location <context.entity.location>
            - remove <context.entity> if:<context.entity.exists>
            - spawn "<entity[animal_mimic].with[custom_name=<&f><context.entity.name.to_titlecase> Mimic].with_flag[mimic_drops:<context.drops>]>" <[location]> target:<context.damager.if_null[<[location].find_entities[player].within[50].first>]> persistent

animal_mimic:
    type: entity
    debug: false
    entity_type: skeleton
    flags:
        on_combust: cancel
        on_death: animal_mimic_death
        on_entity_added: animal_mimic_spawn
    mechanisms:
        custom_name_visible: true
        equipment:
            boots: netherite_boots
            leggings: netherite_leggings
            chestplate: netherite_chestplate
            helmet: jack_o_lantern
        item_in_hand: air
        max_health: 100
        health: 100
        speed: 0.2

animal_mimic_spawn:
    type: task
    debug: false
    script:
        - playeffect effect:flame at:<context.entity.location> offset:0.5,3,0.5 quantity:100
        - playsound sound:entity_ghast_scream at:<context.entity.location> volume:2.0 pitch:0.5 sound_category:master

animal_mimic_death:
    type: task
    debug: false
    script:
        - playsound sound:entity_ghast_death <context.entity.location> sound_category:master volume:2.0 pitch:0.5
        - determine passively <context.entity.flag[mimic_drops].if_null[<list[gold_ingot]>]>
        - determine passively NO_XP