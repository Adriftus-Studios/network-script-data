Silk_Spawners:
    type: world
    debug: false
    events:
        on player breaks spawner with:*pickaxe:
            - if !<player.item_in_hand.enchantments.contains[silk_touch]>:
                - stop
            - define Type <context.location.spawner_type.entity_type.to_titlecase>
            - determine <context.material.item.with[display_name=<[Type]><&sp>Spawner;nbt=key/<[Type]>]>
        on player places spawner:
            - if !<context.item_in_hand.has_nbt[key]>:
                - stop
            - define Type <context.item_in_hand.nbt[key]>
            - wait 1t
            - adjust <context.location> spawner_type:<[Type]>
 
