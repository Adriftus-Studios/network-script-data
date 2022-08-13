animal_mimic_events:
    type: world
    debug: false
    events:
        after cow|sheep|pig|chicken|rabbit|frog|llama|goat spawns because NATURAL:
            - stop if:<context.location.town.exists>
            - define chance 0.5
            - define chance:*:2 if:<context.location.world.has_storm>
            - define chance:*:2 if:<context.location.world.time.is_more_than_or_equal_to[13000]>
            - define chance:*:2 if:<context.entity.entity_type.is_in[llama|goat]>
            - if <util.random_chance[<[chance]>]>:
                - flag <context.entity> animal_mimic expire:5m
        on entity_flagged:animal_mimic dies:
            - stop if:<context.damager.is_player.not.if_null[true]>
            - determine passively cancelled
            - define location <context.entity.location>
            - remove <context.entity> if:<context.entity.exists>
            - title "title:<dark_red><bold>You have been met with a terrible fate..." fade_in:1t fade_out:1s stay:1s
            - spawn "<entity[animal_mimic].with[custom_name=<dark_red><context.entity.name.to_titlecase> Mimic]>" <[location]> target:<context.damager.if_null[<[location].find_entities[player].within[50].first>]> persistent save:mimic
            - flag <entry[mimic].spawned_entity> mimic_drops:<context.drops>
        on player right clicks entity_flagged:animal_mimic:
            - determine passively cancelled
            - define location <context.entity.location>
            - remove <context.entity> if:<context.entity.exists>
            - title "title:<dark_red><bold>You have been met with a terrible fate..." fade_in:1t fade_out:1s stay:1s
            - spawn "<entity[animal_mimic].with[custom_name=<dark_Red><context.entity.name.to_titlecase> Mimic]>" <[location]> target:<context.player> persistent save:mimic
            - flag <entry[mimic].spawned_entity> mimic_drops:<context.drops>

animal_mimic:
    type: entity
    debug: false
    entity_type: husk
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
        speed: 0.5

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
        - determine passively <context.entity.flag[mimic_drops].if_null[<list[]>].include[<element[magical_pylon].repeat_as_list[<util.random.int[1].to[10]>]>]>
        - determine passively <context.xp.mul[3]>