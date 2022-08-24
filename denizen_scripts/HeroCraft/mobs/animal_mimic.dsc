animal_mimic_events:
    type: world
    debug: false
    events:
        after cow|sheep|pig|chicken|rabbit|frog|llama|goat spawns:
            - stop if:<context.location.town.exists>
            - define chance 0.5
            - define chance:*:2 if:<context.location.world.has_storm>
            - define chance:*:2 if:<context.location.world.time.is_more_than_or_equal_to[13000]>
            - define chance:*:2 if:<context.entity.entity_type.is_in[llama|goat]>
            - define chance:*:2 if:<context.entity.is_baby.if_null[false]>
            - flag <context.entity> animal_mimic expire:20m if:<util.random_chance[<[chance]>]>

        on entity_flagged:animal_mimic dies:
            - stop if:<context.damager.is_player.not.if_null[true]>
            - define location <context.entity.location>
            - determine passively NO_DROPS
            - spawn "<entity[animal_mimic].with[custom_name=<dark_red><context.entity.name.to_titlecase> Mimic]>" <[location]> target:<context.damager.if_null[<[location].find_entities[player].within[50].first>]> persistent save:mimic
            - flag <entry[mimic].spawned_entity> mimic_drops:<context.drops>
            - run animal_mimic_spawn player:<context.damager> def:<context.entity.location> if:<context.damager.is_player>
            - remove <context.entity> if:<context.entity.exists>

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
        speed: 0.5

animal_mimic_spawn:
    type: task
    debug: false
    definitions: location
    script:
        - title "title:<dark_red><bold>You have been met with a terrible fate..." fade_in:1t fade_out:1s stay:1s
        - playeffect effect:flame at:<[location]> offset:0.5,3,0.5 quantity:100
        - playsound sound:entity_ghast_scream at:<[location]> volume:2.0 pitch:0.5 sound_category:master

animal_mimic_death:
    type: task
    debug: false
    script:
        - playsound sound:entity_ghast_death <context.entity.location> sound_category:master volume:2.0 pitch:0.5
        - determine passively <context.entity.flag[mimic_drops].if_null[<list[]>].include[<element[magical_pylon].repeat_as_list[<util.random.int[1].to[10]>]>]>
        - determine passively <context.xp.mul[10]>