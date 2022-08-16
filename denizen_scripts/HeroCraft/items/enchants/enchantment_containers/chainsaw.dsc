chainsaw_enchantment:
    type: enchantment
    id: chainsaw
    slots:
    - mainhand
    rarity: rare
    min_cost: <context.level.mul[1]>
    max_cost: <context.level.mul[2]>
    data:
        effect:
        - Gives haste when breaking logs.
        item_slots:
        - axe
    category: breakable
    full_name: <&7>Chainsaw <context.level.to_roman_numerals>
    min_level: 1
    max_level: 5
    is_tradable: false
    is_discoverable: true
    can_enchant: <context.item.advanced_matches[*_axe]>
    treasure_only: false

chainsaw_enchantment_events:
    type: world
    events:
        after player breaks *_log with:item_enchanted:chainsaw:
            - ratelimit <player> 15s
            - cast FAST_DIGGING <player> amplifier:<context.item.enchantment_map.get[chainsaw]> duration:10s hide_particles no_icon no_ambient
            - playsound sound:entity_ender_dragon_growl <player> sound_category:blocks volume:0.5 pitch:2.0