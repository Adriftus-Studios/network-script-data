player_enters_area_error_handler:
    type: world
    debug: false
    events:
        on script generates error:
            - if <context.script.name||invalid> == debug_wrapper:
                - determine cancelled
        on server generates exception:
            - if <context.script.name||invalid> == debug_wrapper:
                - determine cancelled
debug_wrapper:
    type: task
    debug: false
    player_clicks_fake_entity:
        - define ContextTags entity|hand|click_type
    entity_changes_block:
        - define ContextTags entity|location|old_material|new_material
        - inject locally script
    on_block being built:
        - define ContextTags location|old_naterial|new_material
        - inject locally script
    block_burns:
        - define ContextTags location|material
        - inject locally script
    block_dispenses_item:
        - define ContextTags location|item|velocity
        - inject locally script
    block_fades:
        - define ContextTags location|material
        - inject locally script
    block_falls:
        - define ContextTags location|entity
        - inject locally script
    block_forms:
        - define ContextTags location|material
        - inject locally script
    block_grows:
        - define ContextTags location|material
        - inject locally script
    block_ignites:
        - define ContextTags location|entity|origin|cause
        - inject locally script
    entity_death:
        - define ContextTags entity|damager|message|cause|drops|xp
        - inject locally script
    enters_area:
        - define ContextTags area|cause|to|from
        - inject locally script
    enters_biome:
        - define ContextTags from|to|old_biome|new_biome
        - inject locally script
    on_player scrolls their hotbar:
        - define ContextTags new_slot|previous_slot
        - inject locally script
    on_player breaks block:
        - define ContextTags location|material|xp
        - inject locally script
    player_breaks held item:
        - define ContextTags item|slot
        - inject locally script
    player_changes gamemode:
        - define ContextTags gamemode
        - inject locally script
    changes_sign:
        - define ContextTags location|new|old|material
        - inject locally script
    player_changes_world:
        - define ContextTags origin_world|destination|world
        - inject locally script
    player_clicks_block:
        - define ContextTags item|location|relative|click_type|hand
        - inject locally script
    player_clicks_in_inventory:
        - define ContextTags item|inventory|clicked_inventory|cursor_item|click|slot_type|slot|raw_slot|is_shift_click|action|hotbar_button
        - inject locally script
    player_drags_in_inventory:
        - define ContextTags item|inventory|clicked_inventory|slots|raw_slots
        - inject locally script
    player_kicked:
        - define ContextTags message|reason|flying
        - inject locally script
    player_places_block:
        - define ContextTags location|material|old_material|item_in_hand
        - inject locally script
    resource_pack_status:
        - define ContextTags status
        - inject locally script
    command:
        - define ContextTags command|raw_args|args|source_type|command_block_location|command_minecart
        - inject locally script
    script:
        - define event_header <context.event_header>
        - flag server <[event_header]>_debugging:++ duration:1s
        - define Context "<list.include_single[<&b>You are seeing this because of your <&3>*<&b> Permission Node.]>"
        - define Context "<[Context].include_single[<&e>Single Second Fire Rate<&6>: <&b><server.flag[<[event_header]>_debugging]>]>"
        - define Context "<[Context].include_single[<&6><&lt><&e>script.name<&6><&gt> <&3>| <&b><queue.script.name>]>"
        - define Context "<[Context].include_single[<&6><&lt><&e>queue.id<&6><&gt> <&3>| <&3>*<&b><queue.id.after_last[_]>]>"
        - foreach <list[cancelled|event_name].include[<[ContextTags]>]> as:Tag:
            - define Tag_Parsed <element[<&lt>context.<[Tag]>||<&c>Invalid<&gt>].parsed||<&c>Invalid>
            - define Context "<[Context].include_single[<&6><&lt><&e>context<&6>.<&e><[Tag]><&6><&gt> <&3>|<&b> <[Tag_Parsed]>]>"

        - define Hover <[Context].separated_by[<&nl>]>
        - define Text "<&2>[<&a>Event Fired<&2>]<&b> Hover for Debug Content<&3>."

        - announce to_console <[Hover]>
        - narrate <&hover[<[Hover]>]><[Text]><&end_hover> targets:<server.online_players.filter[has_permission[override]]>
