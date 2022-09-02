lock_basic:
    type: item
    material: lever
    display name: <green>Basic Lock
    mechanisms:
        hides: all
    enchantments:
        - UNBREAKING:1
    flags:
        right_click_script: lock_apply
        locks:
            level: basic

lock_apply:
    type: task
    debug: false
    data:
        lockable:
            - chest
            - barrel
            - furnace
            - blast_furnace
            - smoker
            - hopper
            - brewing_stand
            - trapped_chest
            - *_box
            - lever
            - *_button
            - dispenser
            - dropper
    script:
        - define mat <context.location.material>
        - stop if:<player.is_sneaking>
        # If location is a town and the player is not a resident in the town, stop
        - stop if:<context.location.town.residents.contains[<player>].not||false>
        - stop if:<player.worldguard.can_build[<context.location>].not||false>
        - stop if:<script.data_key[data].get[lockable].filter_tag[<context.location.material.name.advanced_matches[<[filter_value]>]>].any.not>
        - stop if:<context.location.has_flag[locks.level]>
        - determine passively cancelled
        - define locf <context.location.proc[get_name]>
        - if <[mat].name> == trapped_chest:
            - log "<player.name> was denied a lock and hurt at <[locf]> because it was a trapped chest. ROFL." info file:logs/locks.log
            - hurt 5 <player> cause:MAGIC
            - push <player> destination:<player.eye_location.backward_flat[5].above[5]> no_rotate
            - playsound <player> sound:entity_ghast_scream pitch:2.0
            - take item:<context.item> quantity:1 from:<player.inventory>
            - stop
        # No double chests
        - if <context.location.material.half.is_in[LEFT|RIGHT]||false>:
            - log "<player.name> was denied a lock at <[locf]> because it was a double chest." info file:logs/locks.log
            - narrate "<red>You cannot apply a lock to a double chest!"
            - playsound <player> sound:entity_villager_no
            - stop
        - take item:<context.item> quantity:1 from:<player.inventory>
        - define uuid <util.random_uuid>
        - flag <context.location> locks.level:<context.item.flag[locks.level]||basic>
        - flag <context.location> locks.allowed:<list_single[<player>]>
        - flag <context.location> locks.original_owner:<player>
        - flag <context.location> locks.uuid:<[uuid]>
        - narrate "<context.item.display||<context.item.material.name.to_titlecase||Basic> Lock><reset><green> applied to <context.location.proc[get_name]>!"
        - define lore "<list[<white><bold>Location<&co> <context.location.proc[get_name]>.|<empty>|<white>Right click another player to give them access.|<white>Right click the container to manage who can access it.|<white>Shift right click the container to remove the lock.|<empty>|<white><underline>You do not need this key to open the container.]>"
        - define key "<item[imprint_key].with_single[display_name=<white><[mat].proc[get_name]> Imprint Key].with_single[lore=<[lore]>].with_flag[locks.location:<context.location>].with_flag[locks.original_owner:<player>].with_flag[locks.uuid:<[uuid]>]>"
        - playsound <context.location> sound:block_chain_place pitch:0.5
        - drop <[key]> <context.location.above[1]> quantity:1

locked_container_events:
    type: world
    debug: false
    events:
        on player breaks block location_flagged:locks.allowed:
            - if <context.location.flag[locks.allowed].contains[<player>]>:
                - flag <context.location> locks:!
                - narrate "<yellow>You broke the lock that was on this block!"
                - playsound <context.location> sound:block_chain_break pitch:2.0
            - else:
                - narrate "<red>You can't break this <context.location.material.proc[get_lower_name]> because it's locked!"
                - playsound <context.location> sound:block_chest_locked pitch:0.7
                - determine cancelled
        on player right clicks block location_flagged:locks.allowed:
            - if !<context.location.flag[locks.allowed].contains[<player>]> && !<context.item.has_flag[locks_pick.level]>:
                - narrate "<red>Hey! You can't interact with this! It belongs to <context.location.flag[locks.original_owner].proc[get_name]||ERROR! CONTACT ADMINS!>!"
                - playsound <context.location> sound:block_chest_locked pitch:1.3
                - determine cancelled
        on item moves from inventory to inventory:
            - if <context.origin.location.has_flag[locks.allowed]>:
                - determine cancelled
        on block destroyed by explosion location_flagged:locks.allowed:
            - determine cancelled
        on block burns location_flagged:locks.allowed:
            - determine cancelled
        on block spreads location_flagged:locks.allowed:
            - determine cancelled
        on piston extends:
            - determine cancelled if:<context.blocks.filter_tag[<[filter_value].has_flag[locks.allowed]>].any>
        on piston retracts:
            - determine cancelled if:<context.blocks.filter_tag[<[filter_value].has_flag[locks.allowed]>].any>
        ##Misc events
        on player places item_flagged:locks:
            - determine cancelled

imprint_key:
    type: item
    material: tripwire_hook
    display name: <red>Disambiguous Imprint Key
    mechanisms:
        hides: all
    enchantments:
        - UNBREAKING:1

imprint_key_manage_players:
    type: world
    debug: false
    events:
        on player right clicks entity with:item_flagged:locks.location:
            - stop if:<context.entity.is_player.not>
            - determine passively cancelled
            - if <context.item.flag[locks.location].flag[locks.allowed].size||0> >= 27:
                - narrate "<red>Can't add anyone else to that container! <&co>(" targets:<player>
                - playsound <player> sound:entity_experience_orb_pickup
                - log "<player.name> maxed out perm'd players at <context.location.proc[get_name]> (<context.location.material.proc[get_name]>)." info file:logs/locks.log
                - stop
            - if <context.item.flag[locks.location].flag[locks.allowed].contains[<context.entity>]||false>:
                - flag <context.item.flag[locks.location]> <context.item.flag[locks.allowed]>:<-:<context.entity>
                - narrate "<green>Removed access from <context.entity.proc[get_name]>." targets:<player>
                - playsound <player> sound:entity_experience_orb_pickup
                - log "<player.name> removed perms of <context.location.proc[get_name]> (<context.location.material.proc[get_name]>) from <context.entity.proc[get_name]>." info file:logs/locks.log
                - stop
            - flag <context.item.flag[locks.location]> locks.allowed:->:<context.entity>
            - log "<player.name> granted perms of <context.location.proc[get_name]> (<context.location.material.proc[get_name]>) to <context.entity.proc[get_name]>." info file:logs/locks.log
            - narrate "<green>Granted access to <context.entity.proc[get_name]>." targets:<player>
        on player right clicks block with:item_flagged:locks.location:
            - determine passively cancelled
            - if <context.item.flag[locks.location].equals[<context.location>].not||true>:
                - narrate "<red>This key isn't for this block!"
                - playsound <player> sound:block_chest_close pitch:2.0
                - stop
            - if <context.item.flag[locks.uuid].equals[<context.location.flag[locks.uuid]>].not>:
                - narrate "<red>This key is outdated!"
                - playsound <player> sound:block_chest_close pitch:2.0
                - stop
            - if <player.is_sneaking>:
                - narrate "<green>Removed <context.location.flag[locks.level].if_null[basic].to_titlecase> Lock!"
                - drop lock_<context.location.flag[locks.level].if_null[basic]> <context.location.above[1]> quantity:1
                - playsound <context.location> sound:block_chain_break pitch:2.0
                - log "<player.name> removed <context.location.flag[locks.level]> lock from <context.location.simple> (<context.location.material.proc[get_name]>)." info file:logs/locks.log
                - flag <context.location> locks:!
                - take iteminhand quantity:1
                - stop
            - define inv <inventory[lock_permissions].include[<item[air]>]>
            - inventory open d:<[inv]>
            - playsound <player> sound:block_chest_open pitch:2.0
            - foreach <context.location.flag[locks.allowed].exclude[<player>]> as:target:
                - give to:<[inv]> "player_head[skull_skin=<[target].skull_skin>;custom_model_data=1;display=<white><[target].proc[get_player_display_name]>;flag=run_script:lock_remove_access;flag=person:<[target]>;flag=location:<context.location>;lore=<list_single[<white>Left click to remove.]>]"
            - log "<player.name> began editing perms of <context.location.proc[get_name]> (<context.location.material.proc[get_name]>)." info file:logs/locks.log

lock_permissions:
    type: inventory
    inventory: chest
    title: Allowed Players
    gui: true
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

lock_remove_access:
    type: task
    debug: false
    script:
        - take item:<context.item> from:<context.inventory>
        - flag <context.item.flag[location]> locks.allowed:<-:<context.item.flag[person]>
        - narrate "<green>Removed access from <context.item.flag[person].proc[get_name]||ERROR>."
        - narrate "You got your access removed from the <context.item.flag[location].material.proc[get_name].to_lowercase> at <context.item.flag[location].proc[get_name]>!" targets:<context.item.flag[person]> if:<context.item.flag[person].is_online>
        - log "<player.name> removed perms of <context.item.flag[location].proc[get_name]> (<context.item.flag[location].material.proc[get_name]>) from <context.item.flag[person].proc[get_name]>." info file:logs/locks.log

lock_pick_basic:
    type: item
    material: stick
    display name: <white>Lock Pick
    flags:
        locks_pick:
            level: basic
            chance: 5

lock_pick_admin:
    type: item
    material: stick
    display name: <red><bold>Admin Lock Pick
    flags:
        locks_pick:
            level: admin
            chance: 100

lock_pick_events:
    type: world
    debug: false
    events:
        on player right clicks block location_flagged:locks.level with:item_flagged:locks_pick.level:
            - if <player.is_sneaking.not>:
                - determine cancelled
            - stop if:<context.location.flag[locks.allowed].contains[<player>]||false>
            - stop if:<player.worldguard.can_build[<context.location>].not||false>
            - determine passively cancelled
            - define locf <context.location.proc[get_name]>
            - define matf <context.location.material.proc[get_name]>
            - if <context.location.town.residents.contains[<player>]>:
                - narrate "<red>Whoa! You can't pick this lock because it is from a different town!"
                - playsound <player> sound:entity_villager_no
                - log "<player.name> tried to lock pick a lock at <[locf]> but failed because it belongs to town <context.location.town.proc[get_name]>." info file:logs/locks.log
                - stop
            ## Chance == chance of success
            - define chance <context.item.flag[locks_pick.chance]||5>
            - log "<player.name> used an admin lock pick at <[locf]> (<[matf]>)!" info file:logs/locks.log if:<context.item.flag[locks_pick.level].equals[admin]>
            - if !<util.random_chance[<[chance]>]>:
                - take item:<context.item> from:<player.inventory> quantity:1
                - narrate "<red>Your <context.item.proc[get_name]> broke!"
                - playsound <context.location> sound:entity_item_break pitch:2.0
                - log "<player.name> broke a lock pick at <[locf]> (<[matf]>)." info file:logs/locks.log
                - stop
            - flag <context.location> locks:!
            - narrate "<green>You picked the lock!"
            - log "<player.name> picked a lock at <[locf]> (<[matf]>)!" info file:logs/locks.log
            - mcmmo add xp skill:repair quantity:<element[100].sub[<context.item.flag[locks_pick.chance]>]> player:<player> if:<proc[mcmmo_installed]||false>
            - playsound <context.location> sound:block_chain_break pitch:0.5 volume:2.0
