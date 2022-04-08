#- % █████████████████████████████████
#- %            [ Tasks ]
#- % █████████████████████████████████

# % ██ [ Task called to start minigame ] ██
fishing_minigame_start:
    debug: false
    type: task
    definitions: player
    script:
        - flag <[player]> fishingminigame.active:true
        - flag <[player]> fishingminigame.savedinventory:<[player].inventory.map_slots>
        - if !<[player].has_flag[fishingminigame.bucket]>:
            - flag <[player]> fishingminigame.bucket.fish:<list[]>
            - flag <[player]> fishingminigame.bucket.size:6
            - flag <[player]> fishingminigame.fishtokens:0
        - if !<[player].has_flag[fishingminigame.stats]>:
            - flag <[player]> fishingminigame.stats.daily.catch:0
            - flag <[player]> fishingminigame.stats.daily.value:0
            - flag <[player]> fishingminigame.stats.alltime.catch:0
            - flag <[player]> fishingminigame.stats.alltime.value:0
            - flag <[player]> fishingminigame.stats.alltime.bestcatch:none
        - if !<[player].has_flag[fishingminigame.stats.bestcatch]>:
            - foreach <proc[fishing_minigame_get_all_types]> as:type:
                - flag <[player]> fishingminigame.stats.bestcatch.<[type]>:none
        - if !<[player].has_flag[fishingminigame.music]>:
            - flag <player> fishingminigame.music:<list[]>
        - run fishing_minigame_set_inventory def:<[player]>
        - if !<server.has_flag[fishingminingame.activeplayers]>:
            - flag server fishingminingame.activeplayers:<list[]>
        - flag server fishingminingame.activeplayers:->:<[player]>
        - title title:<&a>Fishing "subtitle:<&a>Find a whirlpool in a lake, and begin catching!" targets:<[player]>
        - narrate "<&7><&l><&lt>!<&gt><&r> <&7>You are now in fishing mode. If you at any point would like to return to normal, look for a barrier in your inventory. Typing any command will revert you back to normal."
        - narrate <&8>----------------------------------------------------
        - define event <proc[fishing_minigame_get_current_event]>
        - narrate "<&7><&l><&lt>!<&gt><&r> <&7>Currently running event: <&a><[event]>"
        - if !<[event].equals[None]>:
            - narrate "<&7><&l><&lt>!<&gt><&r> <&7>Instructions:"
            - narrate <proc[fishing_minigame_get_current_event_instructions]>

# % ██ [ Task called to stop minigame ] ██
fishing_minigame_stop:
    debug: false
    type: task
    definitions: player
    script:
        - flag <[player]> fishingminigame.active:false
        - run fishing_minigame_reset_inventory def:<[player]>
        - title 'title:<&c>Fishing Exited' "subtitle:<&c>Your fishing session is over!" targets:<[player]>
        - narrate "<&e>Your fishing session is over. If you would like to resume, just speak to the fish merchant again"
        - if <player.has_flag[fishing_minigame_playing_music]>:
            - queue <player.flag[fishing_minigame_music_queue]> stop
            - midi cancel
            - flag <player> fishing_minigame_playing_music:!
        - flag server fishingminingame.activeplayers:<server.flag[fishingminingame.activeplayers].deduplicate>
        - flag server fishingminingame.activeplayers:<-:<[player]>

# % ██ [ Task called when bucket is bucket is clicked ] ██
fishing_minigame_open_bucket:
    debug: false
    type: task
    definitions: player|merchant
    script:
        - run fishing_minigame_bucket_open_gui def:<[player]>|<[merchant]>

# % ██ [ Task used to set player inv for minigame ] ██
fishing_minigame_set_inventory:
    debug: false
    type: task
    definitions: player
    script:
        - inventory clear
        - inventory set o:fishing_minigame_bad_rod slot:1
        - inventory set o:<proc[fishing_minigame_get_bucket_type].context[<[player]>]> slot:2
        - inventory set o:<proc[fishing_minigame_get_fishtoken_item].context[<[player]>]> slot:3
        - inventory set o:fishing_minigame_end_game slot:9
        - inventory set o:fishing_minigame_statistics_book_inv slot:8
        - inventory set o:fishing_minigame_mp3_player slot:7

# % ██ [ Task used to reset player inventory ] ██
fishing_minigame_reset_inventory:
    debug: false
    type: task
    definitions: player
    script:
        - inventory clear
        - define saved <[player].flag[fishingminigame.savedinventory]>
        - foreach <[saved]> as:item key:slot:
            - inventory set o:<[item]> slot:<[slot]>

# % ██ [ Helper script just in case we need to reset whirlpools ] ██
fishing_minigame_reset_whirlpool_locations:
    debug: false
    type: task
    script:
        - flag server fishing_minigame_whirlpool_locations:<proc[fishing_minigame_generate_possible_whirlpool_locations].context[<cuboid[fishing_minigame_pond]>]>
        - foreach <server.flag[fishing_minigame_whirlpool_locations]> as:loc:
            - playeffect at:<[loc].up> flame offset:0 targets:<server.online_players>

# % ██ [ Task used to reset the whirlpools generated ] ██
fishing_minigame_reset_whirlpools:
    debug: false
    type: task
    script:
        - ~run fishing_minigame_destroy_whirlpools
        - flag server fishing_minigame_reset_whirlpools
        - flag server fishing_minigame_active_whirlpool_locations:<list[]>

# % ██ [ Task used to generate random whirlpools on the water inside given cuboid ] ██
fishing_minigame_generate_whirlpools:
    debug: false
    type: task
    definitions: amount
    script:
        - ~run fishing_minigame_reset_whirlpools
        - wait 5t
        - flag server fishing_minigame_reset_whirlpools:!
        - flag server fishing_minigame_active_whirlpool_locations:<proc[fishing_minigame_get_avaiailable_whirlpool_location].context[<[amount]>]>
        - run fishing_minigame_build_whirlpools

# % ██ [ Task used to destroy the actual whirlpool entities ] ██
fishing_minigame_destroy_whirlpools:
    debug: false
    type: task
    script:
        - foreach <server.flag[fishing_minigame_active_whirlpool_locations]> key:loc as:entity:
            - remove <[entity].get[entity].unescaped>
            - flag server fishing_minigame_active_whirlpool_locations.<[loc]>.entity:!
            - flag <[loc]> whirlpool:!

# % ██ [ Task used to summon the actual whirlpool entities ] ██
fishing_minigame_build_whirlpools:
    debug: false
    type: task
    script:
        - foreach <server.flag[fishing_minigame_active_whirlpool_locations]> as:loc:
            - define stand <entity[armor_stand]>
            - spawn <[stand]> <[loc]> save:entity persistent
            - adjust <entry[entity].spawned_entity> gravity:false
            - adjust <entry[entity].spawned_entity> marker:true
            - invisible <entry[entity].spawned_entity> state:true
            - flag server fishing_minigame_active_whirlpool_locations.<[loc]>.entity:<entry[entity].spawned_entity.escaped>
        - run fishing_minigame_whirlpool_animation

# % ██ [ Task for whirlpool animations ] ██
fishing_minigame_whirlpool_animation:
    type: task
    debug: false
    script:
        - define circles <server.flag[fishing_minigame_active_whirlpool_locations].keys.parse[up.with_pitch[90].proc[define_circle].context[1|0.1]].combine>
        - while !<server.has_flag[fishing_minigame_reset_whirlpools]>:
            - playeffect at:<[circles]> dolphin offset:0.05,0.05,0.05 targets:<server.flag[fishingminingame.activeplayers]>
            - wait 1t
        - flag server fishing_minigame_reset_whirlpools:!

# % ██ [ Task for mega whirlpool animation ] ██
fishing_minigame_mega_whirlpool_animation:
    type: task
    debug: false
    script:
        - define circle <server.flag[fishingminigame.megawhirlpool].parse[up.with_pitch[90].proc[define_circle].context[1|0.1]].combine>
        - while <server.has_flag[fishingminigame.megawhirlpool]>:
            - playeffect at:<[circle]> glow offset:0.05,0.05,0.05 targets:<server.flag[fishingminingame.activeplayers]>
            - wait 5t

# % ██ [ Adds a fish to a bucket (returns false if failed) ] ██
fishing_minigame_bucket_add:
    debug: false
    type: task
    definitions: player|fish
    script:
        - if <proc[fishing_minigame_bucket_full].context[<[player]>]>:
            - determine false

        - flag <[player]> fishingminigame.bucket.fish:<[player].flag[fishingminigame.bucket.fish].include[<[fish]>]>

        # % ██ [ Code for statistics ] ██
        - flag <[player]> fishingminigame.stats.daily.catch:<[player].flag[fishingminigame.stats.daily.catch].add[1]>
        - flag <[player]> fishingminigame.stats.alltime.catch:<[player].flag[fishingminigame.stats.alltime.catch].add[1]>
        - define value <proc[fishing_minigame_fish_value].context[<[fish]>]>
        - flag <[player]> fishingminigame.stats.daily.value:<[player].flag[fishingminigame.stats.daily.value].add[<[value]>]>
        - flag <[player]> fishingminigame.stats.alltime.value:<[player].flag[fishingminigame.stats.alltime.value].add[<[value]>]>

        # % ██ [ Best catch statistic ] ██
        - if <[player].flag[fishingminigame.stats.alltime.bestcatch].equals[none]>:
            - flag <[player]> fishingminigame.stats.alltime.bestcatch:<[fish].escaped>
        - else:
            - if <[value]> > <proc[fishing_minigame_fish_value].context[<[player].flag[fishingminigame.stats.alltime.bestcatch].unescaped>]>:
                - flag <[player]> fishingminigame.stats.alltime.bestcatch:<[fish].escaped>
        # % ██ [ Best catch statistic per fish] ██
        - define type <[fish].flag[type]>
        - define rarity <[fish].flag[rarity]>
        - if <[player].flag[fishingminigame.stats.bestcatch.<[type]>].equals[none]>:
            - flag <[player]> fishingminigame.stats.bestcatch.<[type]>:<[fish].escaped>
        - else:
            - if <[value]> > <proc[fishing_minigame_fish_value].context[<[player].flag[fishingminigame.stats.bestcatch.<[type]>].unescaped>]>:
                - flag <[player]> fishingminigame.stats.bestcatch.<[type]>:<[fish].escaped>

        # % ██ [ Server best catch statistic ] ██
        - if <server.flag[fishingminigame.bestcatch.fish].equals[none]>:
            - flag server fishingminigame.bestcatch.fish:<[fish].escaped>
            - flag server fishingminigame.bestcatch.player:<[player].uuid>
        - else:
            - if <[value]> > <proc[fishing_minigame_fish_value].context[<server.flag[fishingminigame.bestcatch.fish].unescaped>]>:
                - flag server fishingminigame.bestcatch.fish:<[fish].escaped>
                - flag server fishingminigame.bestcatch.player:<[player].uuid>

        # % ██ [ Event handling ] ██
        - if <server.has_flag[fishingminingame.speedcatch]>:
            - if <server.flag[fishingminingame.speedcatch].keys.contains[<[player].uuid>]>:
                - flag server fishingminingame.speedcatch:<server.flag[fishingminingame.speedcatch].with[<[player].uuid>].as[<server.flag[fishingminingame.speedcatch].get[<[player].uuid>].add[1]>]>
            - else:
                - flag server fishingminingame.speedcatch:<server.flag[fishingminingame.speedcatch].with[<[player].uuid>].as[1]>

        # % ██ [ Print rare fish to the server ] ██
        - if <[rarity].equals[legendary]>:
            - narrate "<&7><&l><&lt>!<&gt><&r> <&b><&l><player.name> <&r><&7>has just caught a <element[<bold>Legendary].color_gradient[from=#FF930F;to=#FFE15C]><&r> <[fish].display.on_hover[<[fish]>].type[SHOW_ITEM]>" targets:<server.online_players>

        - run fishing_minigame_narrate_fish def:<[player]>|<[fish]>
        - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
            - run fishing_minigame_update_bucket def:<[player]>
        - determine true

# % ██ [ Removes a fish from a bucket ] ██
fishing_minigame_bucket_remove:
    debug: false
    type: task
    definitions: player|fish
    script:
        - flag <[player]> fishingminigame.bucket.fish:<[player].flag[fishingminigame.bucket.fish].exclude[<[fish]>]>
        - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
            - run fishing_minigame_update_bucket def:<[player]>

# % ██ [ Task to narrate fish (imagine it as a to_string xD) ] ██
fishing_minigame_narrate_fish:
    debug: false
    type: task
    definitions: player|fish
    script:
        - narrate "<&a>You just caught a (The fish will be in your bucket):" targets:<[player]>
        - narrate " <[fish].display>" targets:<[player]>
        - foreach <[fish].lore> as:line:
            - if <[fish].lore.find[<[line]>]> > 1 && <[fish].lore.find[<[line]>]> < 6:
                - define line "<&8>| <[line]>"
            - narrate <[line]> targets:<[player]>

# % ██ [ Task to update the players bucket in their inventory ] ██
fishing_minigame_update_bucket:
    debug: false
    type: task
    definitions: player
    script:
        - define currentBucket <[player].inventory.slot[2]>
        - define fishAmount <[player].flag[fishingminigame.bucket.fish].size>
        - define updatedBucket <proc[fishing_minigame_get_bucket_type].context[<[player]>]>
        - if !<[currentBucket].equals[<[updatedBucket]>]>:
            - inventory set o:<[updatedBucket]> slot:2

# % ██ [ Adds given amount of tokens to given player ] ██
fish_tokens_add:
    debug: false
    type: task
    definitions: player|amount
    script:
        - flag <[player]> fishingminigame.fishtokens:<[player].flag[fishingminigame.fishtokens].add[<[amount]>]>
        - narrate "<&a><[amount].round_to[2]><&r><&font[adriftus:chat]><&chr[0045]><&r><&a> has been deposited to your account" targets:<[player]>
        - if <[player].has_flag[fishingminigame.active]> && <[player].flag[fishingminigame.active]>:
            - inventory set o:<proc[fishing_minigame_get_fishtoken_item].context[<[player]>]> slot:3 destination:<[player].inventory>

# % ██ [ Removes given amount of tokens to given player ] ██
fish_tokens_remove:
    debug: false
    type: task
    definitions: player|amount
    script:
        - define newBal <player.flag[fishingminigame.fishtokens].sub[<[amount]>]>
        - if <[newBal]> < 0:
            - determine false
        - flag <[player]> fishingminigame.fishtokens:<[player].flag[fishingminigame.fishtokens].sub[<[amount]>]>
        - narrate "<&c><[amount].round_to[2]><&r><&font[adriftus:chat]><&chr[0045]><&r><&c> has been deducted from your account" targets:<[player]>
        - if <[player].has_flag[fishingminigame.active]> && <[player].flag[fishingminigame.active]>:
            - inventory set o:<proc[fishing_minigame_get_fishtoken_item].context[<[player]>]> slot:3 destination:<[player].inventory>
        - determine true

# % ██ [ Adds given amount of tokens to given player ] ██
fishing_minigame_reset_leaderboards:
    debug: false
    type: task
    script:
        - define players <server.players_flagged[fishingminigame.stats.daily.catch]>
        - foreach <[players]> as:pl:
            - flag <[pl]> fishingminigame.stats.daily.catch:0
            - flag <[pl]> fishingminigame.stats.daily.value:0
        - flag server fishingminigame.bestcatch.fish:none
        - flag server fishingminigame.bestcatch.player:none

# % ██ [ Open Statistics book ] ██
fishing_minigame_stats_book_open:
    debug: false
    type: task
    definitions: player
    script:
        - define book <item[fishing_minigame_stats_book]>
        - define pages <list[]>

        - define page1:->:<n>
        - define "page1:->:<&sp><&sp><&sp><&sp><element[Fishing Statistics].color_gradient[from=#00D540;to=#009A08]><n>"
        - define page1:->:<n>
        - define page1:->:<n><&7>+-----------------+
        - define "page1:->:<n><&7>+ <&r>Fish Caught:"
        - define "page1:->:<n><&7>+ <&2><[player].flag[fishingminigame.stats.alltime.catch].format_number>"
        - define "page1:->:<n><&7>+ <&r>Total Value:"
        - define "page1:->:<n><&7>+ <&2><[player].flag[fishingminigame.stats.alltime.value].round_to[2].format_number> <&f><&font[adriftus:chat]><&chr[0045]>"
        - define "page1:->:<n><&7>+ <&r>Best Catch:"
        - if <[player].flag[fishingminigame.stats.alltime.bestcatch].equals[none]>:
            - define "page1:->:<n><&7>+ <&c>[<&4>None<&c>]"
        - else:
            - define fishName <[player].flag[fishingminigame.stats.alltime.bestcatch].unescaped>
            - define "page1:->:<n><&7>+ <&2>[<&9><[fishName].display.strip_color.on_hover[<[player].flag[fishingminigame.stats.alltime.bestcatch].unescaped>].type[SHOW_ITEM]><&2>]"
        - define page1:->:<n><&7>+-----------------+
        - define page1:->:<n>
        - define "page1:->:<n><element[Per Fish Stats <&sp><&sp><&sp><&sp>--<&gt>].color_gradient[from=#0053BF;to=#009DD6]>"
        - define pages:->:<[page1].unseparated>

        - foreach <list[legendary|epic|rare|uncommon|common].reverse> as:rarity:
            - define newPage:->:<n>
            - define newPage:->:<&1><[rarity].to_titlecase.bold><n>
            - define newPage:->:<n>
            - foreach <proc[fishing_minigame_get_all_types_by_rarity].context[<[rarity]>]> as:type:
                - define newPage:->:<&8><[type].to_titlecase><&co><n>
                - if <[player].flag[fishingminigame.stats.bestcatch.<[type]>].equals[none]>:
                    - define "newPage:->:<&7>+ <&c>[<&4>None<&c>]<n>"
                - else:
                    - define fishItem <[player].flag[fishingminigame.stats.bestcatch.<[type]>].unescaped>
                    - define "newPage:->:<&7>+ <&2>[<&9><element[Hover].on_hover[<[fishItem]>].type[SHOW_ITEM]><&2>]<n>"

            - define pages:->:<[newPage].unseparated>
            - define newPage <list[]>

        - adjust def:book book_pages:<[pages]>
        - adjust <[player]> show_book:<[book]>

# % ██ [ Plays the given song to the given player ] ██
fishing_minigame_play_song:
    debug: false
    type: task
    definitions: player|song
    script:
        - ~midi <[song]> <[player]>
        - flag <[player]> fishing_minigame_playing_music:!

# % ██ [ Sells all players fish ] ██
fishing_minigame_sell_all_fish:
    debug: false
    type: task
    definitions: player
    script:
        - define value <[player].flag[fishingminigame.bucket.fish].parse[proc[fishing_minigame_fish_value]].sum>
        - flag <[player]> fishingminigame.bucket.fish:<list[]>
        - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
            - run fishing_minigame_update_bucket def:<[player]>
        - if <[value]> > 0:
            - run fish_tokens_add def:<player>|<[value]>
            - if <server.has_flag[fishingminigame.bucketflush]> && !<server.has_flag[fishingminigame.flusher]>:
                - flag server fishingminigame.flusher:<[player].uuid>
        - else:
            - narrate "<&c>Theres nothing to sell!"

# % ██ [ Plays the given song to the given player ] ██
fishing_minigame_show_off:
    debug: false
    type: task
    definitions: player|fish
    script:
        - ratelimit <[player]> 10s
        - narrate "<&7><&l><&lt>!<&gt><&r> <&7>Check out this fish <[player].name> caught: <[fish].display.on_hover[<[fish]>].type[SHOW_ITEM]>" targets:<server.online_players>

# % ██ [ stop all events ] ██
fishing_minigame_stop_events:
    debug: false
    type: task
    script:
        - if <server.has_flag[fishingminingame.speedcatch]>:
            - flag server fishingminingame.speedcatch:!
            - define queues <util.queues.filter[script.name.contains[fishing_minigame_speed_catch]]>
            - foreach <[queues]> as:queue:
                - queue <[queue]> stop
        - if <server.has_flag[fishingminigame.megawhirlpool]>:
            - flag server fishingminigame.megawhirlpool:!
            - define queues <util.queues.filter[script.name.contains[fishing_minigame_mega_whirlpool]]>
            - foreach <[queues]> as:queue:
                - queue <[queue]> stop
        - if <server.has_flag[fishingminigame.chickenstuck]>:
            - flag server fishingminigame.chickenstuck:!
            - flag server fishingminigame.chickencatch:!
            - if <server.has_flag[fishingminigame.chickenentity]>:
                - remove <server.flag[fishingminigame.chickenentity].unescaped>
            - flag server fishingminigame.chickenentity:!
            - define queues <util.queues.filter[script.name.contains[fishing_minigame_chicken_save]]>
            - foreach <[queues]> as:queue:
                - queue <[queue]> stop
        - if <server.has_flag[fishingminigame.fishfinder]>:
            - flag server fishingminigame.fishfinder:!
            - flag server fishingminigame.findercatch:!
            - define queues <util.queues.filter[script.name.contains[fishing_minigame_fish_finder]]>
            - foreach <[queues]> as:queue:
                - queue <[queue]> stop
        - if <server.has_flag[fishingminigame.bucketflush]>:
            - flag server fishingminigame.bucketflush:!
            - flag server fishingminigame.flusher:!
            - define queues <util.queues.filter[script.name.contains[fishing_minigame_bucket_flush]]>
            - foreach <[queues]> as:queue:
                - queue <[queue]> stop

# % ██ [ Start a random event ] ██
fishing_minigame_start_random_event:
    debug: false
    type: task
    definitions: event
    script:
        - run fishing_minigame_stop_events
        - if !<[event].exists>:
            - define event <list[SPEED_CATCHING|MEGA_WHIRLPOOL|CHICKEN_SAVE|FISH_FINDER|BUCKET_FLUSH].random>
        - choose <[event]>:
            - case SPEED_CATCHING:
                - run fishing_minigame_speed_catch
            - case MEGA_WHIRLPOOL:
                - run fishing_minigame_mega_whirlpool
            - case CHICKEN_SAVE:
                - run fishing_minigame_chicken_save
            - case FISH_FINDER:
                - run fishing_minigame_fish_finder
            - case BUCKET_FLUSH:
                - run fishing_minigame_bucket_flush

fishing_minigame_speed_catch:
    debug: false
    type: task
    script:
        - title "title:<&a>Speed Catch!" "subtitle:<&a>Catch as much fish as you can in 2m!" targets:<server.flag[fishingminingame.activeplayers]>
        - narrate "<&7>You have 2 minutes to catch as much fish as you can to win this event. The reward is 2500 fishtokens" targets:<server.flag[fishingminingame.activeplayers]>
        - flag server fishingminingame.speedcatch:<map[]>
        - wait 1m
        - narrate "<&7><&l><&lt>!<&gt><&r> <&7>There is 1 minute left!" targets:<server.flag[fishingminingame.activeplayers]>
        - wait 30s
        - narrate "<&7><&l><&lt>!<&gt><&r> <&7>There are 30 seconds left!" targets:<server.flag[fishingminingame.activeplayers]>
        - wait 20s
        - narrate "<&7><&l><&lt>!<&gt><&r> <&7>There are 10 seconds left!" targets:<server.flag[fishingminingame.activeplayers]>
        - wait 10s
        - narrate "<&7><&l><&lt>!<&gt><&r> <&7>Times up!" targets:<server.flag[fishingminingame.activeplayers]>
        - define players <server.flag[fishingminingame.speedcatch].sort_by_value.keys.reverse>
        - define amounts <server.flag[fishingminingame.speedcatch].sort_by_value.values.reverse>
        - if <[players].first.exists>:
            - title "title:<&a><player[<[players].first>].name> Won!" "subtitle:<&a>They caught <[amounts].first> fish in 2 minutes" targets:<server.flag[fishingminingame.activeplayers]>
        - else:
            - title "title:Nobody Won!" "subtitle:<&a>Wow really? What are yall doing!??" targets:<server.flag[fishingminingame.activeplayers]>
        - narrate "<&7><&l><&lt>!<&gt><&r> <&7>Event Results"
        - narrate <&8>+-----------------------------------+ targets:<server.flag[fishingminingame.activeplayers]>
        - if <[players].first.exists>:
            - narrate "<&8>+ <element[1st: <player[<[players].first>].name>].color_gradient[from=#FFEA00;to=#FFF873]> <&7>with <[amounts].first> fish" targets:<server.flag[fishingminingame.activeplayers]>
        - else:
            - narrate "<&8>+ <element[1st:].color_gradient[from=#FFEA00;to=#FFF873]> <&7>Nobody" targets:<server.flag[fishingminingame.activeplayers]>
        - if <[players].get[2].exists>:
            - narrate "<&8>+ <element[2nd: <player[<[players].get[2]>].name>].color_gradient[from=#A7A7A7;to=#E6E6E6]> <&7>with <[amounts].get[2]> fish" targets:<server.flag[fishingminingame.activeplayers]>
        - else:
            - narrate "<&8>+ <element[2nd:].color_gradient[from=#A7A7A7;to=#E6E6E6]> <&7>Nobody" targets:<server.flag[fishingminingame.activeplayers]>
        - if <[players].get[3].exists>:
            - narrate "<&8>+ <element[3rd: <player[<[players].get[3]>].name>].color_gradient[from=#F08800;to=#FFA057]> <&7>with <[amounts].get[3]> fish" targets:<server.flag[fishingminingame.activeplayers]>
        - else:
            - narrate "<&8>+ <element[3rd:].color_gradient[from=#F08800;to=#FFA057]> <&7>Nobody" targets:<server.flag[fishingminingame.activeplayers]>
        - narrate <&8>+-----------------------------------+ targets:<server.flag[fishingminingame.activeplayers]>
        - if <[players].first.exists>:
            - run fish_tokens_add def:<player[<[players].first>]>|2500
        - flag server fishingminingame.speedcatch:!

fishing_minigame_mega_whirlpool:
    debug: false
    type: task
    script:
        - title "title:<&a>Mega Whirlpool!" "subtitle:<&a>Find the mega whirlpool, and catch a fish!" targets:<server.flag[fishingminingame.activeplayers]>
        - narrate "<&7>Theres a mega whirlpool that has spawned somewhere randomly on the pond. Go be the first to find it, and catch a fish from it! The reward is 2500 fishtokens" targets:<server.flag[fishingminingame.activeplayers]>
        - flag server fishingminigame.megawhirlpool:<proc[fishing_minigame_get_avaiailable_whirlpool_location].context[1]>
        - run fishing_minigame_mega_whirlpool_animation
        - while !<server.has_flag[fishingminigame.eventcatch]>:
            - wait 10t
        - flag server fishingminigame.megawhirlpool:!
        - define winner <server.flag[fishingminigame.eventcatch]>
        - title "title:<&a><player[<[winner]>].name> Won!" "subtitle:<&a>They were first to catch a fish in the Mega Whirlpool" targets:<server.flag[fishingminingame.activeplayers]>
        - run fish_tokens_add def:<player[<[winner]>]>|2500
        - flag server fishingminigame.eventcatch:!

fishing_minigame_chicken_save:
    debug: false
    type: task
    script:
        - title "title:<&a>Chicken Stuck!" "subtitle:<&a>Find and save the chicken stuck in a whirlpool!" targets:<server.flag[fishingminingame.activeplayers]>
        - narrate "<&7>A chicken was sighted stuck in some whirlpool! Be the first to find it and save the day! (go fish out the chiken)" targets:<server.flag[fishingminingame.activeplayers]>
        - flag server fishingminigame.chickenstuck
        #Spawn chicken
        - define chicken <entity[chicken]>
        - adjust def:chicken gravity:false
        - adjust def:chicken has_ai:false
        - if <server.flag[fishing_minigame_active_whirlpool_locations].keys.exists>:
            - define randomPool <server.flag[fishing_minigame_active_whirlpool_locations].keys.random>
        - else:
            - define randomPool <server.flag[fishing_minigame_active_whirlpool_locations].random>
        - spawn <[chicken]> <[randomPool].up[.6]> save:entity persistent
        - flag <entry[entity].spawned_entity> event
        - flag server fishingminigame.chickenentity:<entry[entity].spawned_entity.escaped>
        - while !<server.has_flag[fishingminigame.chickencatch]>:
            - if !<entry[entity].spawned_entity.exists>:
                - flag server fishingminigame.chickenstuck:!
                - flag server fishingminigame.chickenentity:!
                - stop
            - adjust <entry[entity].spawned_entity> has_ai:false
            - wait 10t
        - remove <entry[entity].spawned_entity>
        - flag server fishingminigame.chickenstuck:!
        - flag server fishingminigame.chickenentity:!
        - define winner <server.flag[fishingminigame.chickencatch]>
        - title "title:<&a><player[<[winner]>].name> Won!" "subtitle:<&a>They rescued the chicken, and saved the day!  The reward is 2500 fishtokens" targets:<server.flag[fishingminingame.activeplayers]>
        - run fish_tokens_add def:<player[<[winner]>]>|2500
        - flag server fishingminigame.chickencatch:!

fishing_minigame_fish_finder:
    debug: false
    type: task
    script:
        - define rarity <proc[fishing_minigame_get_random_rarity]>
        - define rarityColor <script[fishing_minigame_fish_table].parsed_key[rarity.<[rarity]>.color]>
        - title "title:<&a>Fish Finder!" "subtitle:<&a>Be the first to catch a <&f><[rarityColor]><[rarity].to_titlecase> <&a>fish!" targets:<server.flag[fishingminingame.activeplayers]>
        - narrate "<&7>We are looking for a specific rarity fish! Be the first to catch a <&f><[rarityColor]><[rarity].to_titlecase> <&8>Fish, and win the 2500 fishtoken prize!" targets:<server.flag[fishingminingame.activeplayers]>
        - flag server fishingminigame.fishfinder:<[rarity]>
        - while !<server.has_flag[fishingminigame.findercatch]>:
            - wait 10t
        - flag server fishingminigame.fishfinder:!
        - define winner <server.flag[fishingminigame.findercatch]>
        - title "title:<&a><player[<[winner]>].name> Won!" "subtitle:<&a>They were first to catch a <&f><[rarityColor]><[rarity].to_titlecase> <&a>fish" targets:<server.flag[fishingminingame.activeplayers]>
        - run fish_tokens_add def:<player[<[winner]>]>|2500
        - flag server fishingminigame.findercatch:!

fishing_minigame_bucket_flush:
    debug: false
    type: task
    script:
        - title "title:<&a>Bucket Flush!" "subtitle:<&a>Be the first person to sell your entire bucket!" targets:<server.flag[fishingminingame.activeplayers]>
        - narrate "<&7>We are looking for people ready to risk all their contents of their bucket for a reward of 2500 fishtokens!<n>(Note!: This event required you to press the sell all button at the fishing merchant)" targets:<server.flag[fishingminingame.activeplayers]>
        - flag server fishingminigame.bucketflush
        - while !<server.has_flag[fishingminigame.flusher]>:
            - wait 10t
        - flag server fishingminigame.bucketflush:!
        - define winner <server.flag[fishingminigame.flusher]>
        - title "title:<&a><player[<[winner]>].name> Won!" "subtitle:<&a>They were first to sell all their fish, from their bucket" targets:<server.flag[fishingminingame.activeplayers]>
        - run fish_tokens_add def:<player[<[winner]>]>|2500
        - flag server fishingminigame.flusher:!

#- % █████████████████████████████████
#- %          [ Procedures ]
#- % █████████████████████████████████

fishing_minigame_get_current_event:
    debug: false
    type: procedure
    script:
        - if <server.has_flag[fishingminingame.speedcatch]>:
            - determine "Speed Catch"
        - if <server.has_flag[fishingminigame.megawhirlpool]>:
            - determine "Mega Whirlpool"
        - if <server.has_flag[fishingminigame.chickenstuck]>:
            - determine "Chicken Stuck"
        - if <server.has_flag[fishingminigame.fishfinder]>:
            - determine "Fish Finder"
        - if <server.has_flag[fishingminigame.bucketflush]>:
            - determine "Bucket Flush"
        - determine None

fishing_minigame_get_current_event_instructions:
    debug: false
    type: procedure
    script:
        - if <server.has_flag[fishingminingame.speedcatch]>:
            - determine "<&7>You have 2 minutes to catch as much fish as you can to win this event. The reward is 2500 fishtokens"
        - if <server.has_flag[fishingminigame.megawhirlpool]>:
            - determine "<&7>Theres a mega whirlpool that has spawned somewhere randomly on the pond. Go be the first to find it, and catch a fish from it! The reward is 2500 fishtokens"
        - if <server.has_flag[fishingminigame.chickenstuck]>:
            - determine "<&7>A chicken was sighted stuck in some whirlpool! Be the first to find it and save the day! (go fish out the chiken)"
        - if <server.has_flag[fishingminigame.fishfinder]>:
            - define rarity <server.flag[fishingminigame.fishfinder]>
            - define rarityColor <script[fishing_minigame_fish_table].parsed_key[rarity.<[rarity]>.color]>
            - determine "<&7>We are looking for a specific rarity fish! Be the first to catch a <&f><[rarityColor]><[rarity].to_titlecase> <&8>Fish, and win the 2500 fishtoken prize!"
        - if <server.has_flag[fishingminigame.bucketflush]>:
            - determine "<&7>We are looking for people ready to risk all their contents of their bucket for a reward of 2500 fishtokens!<n>(Note!: This event required you to press the sell all button at the fishing merchant)"

# % ██ [ Returns the level of the players bucket ] ██
fishing_minigame_get_bucket_level:
    debug: false
    type: procedure
    definitions: player
    script:
        - if !<[player].has_flag[fishingminigame.bucket.size]>:
            - determine 1
        - choose <[player].flag[fishingminigame.bucket.size]>:
            - case 6:
                - determine 1
            - case 9:
                - determine 2
            - case 12:
                - determine 3
            - case 20:
                - determine MAX

# % ██ [ Returns the slots for the given bucket level ] ██
fishing_minigame_get_slots_by_level:
    debug: false
    type: procedure
    definitions: level
    script:
        - choose <[level]>:
            - case 1:
                - determine 6
            - case 2:
                - determine 9
            - case 3:
                - determine 12
            - case MAX:
                - determine 20

# % ██ [ Returns the slots for the given bucket level ] ██
fishing_minigame_get_slots_to_add:
    debug: false
    type: procedure
    definitions: player
    script:
        - choose <[player].flag[fishingminigame.bucket.size]>:
            - case 6:
                - determine 3
            - case 9:
                - determine 3
            - case 12:
                - determine 8

# % ██ [ Returns the slots for the given bucket level ] ██
fishing_minigame_get_slot_list_by_level:
    debug: false
    type: procedure
    definitions: level
    script:
        - choose <[level]>:
            - case 1:
                - determine <list[40|41|42|49|50|51]>
            - case 2:
                - determine <list[31|32|33|40|41|42|49|50|51]>
            - case 3:
                - determine <list[22|23|24|31|32|33|40|41|42|49|50|51]>
            - case MAX:
                - determine <list[21|22|23|24|25|30|31|32|33|34|39|40|41|42|43|48|49|50|51|52]>

# % ██ [ Returns the inventory name based on level ] ██
fishing_minigame_get_bucket_name:
    debug: false
    type: procedure
    definitions: level
    script:
        - choose <[level]>:
            - case 1:
                - determine <&f><&font[adriftus:fishing_minigame]><&chr[F808]><&chr[0021]>
            - case 2:
                - determine <&f><&font[adriftus:fishing_minigame]><&chr[F808]><&chr[0022]>
            - case 3:
                - determine <&f><&font[adriftus:fishing_minigame]><&chr[F808]><&chr[0023]>
            - case MAX:
                - determine <&f><&font[adriftus:fishing_minigame]><&chr[F808]><&chr[0024]>

# % ██ [ Returns avaialbe whirlpool locations ] ██
fishing_minigame_get_avaiailable_whirlpool_location:
    debug: false
    type: procedure
    definitions: amount
    script:
        - define existing <list[]>
        - if <server.has_flag[fishing_minigame_active_whirlpool_locations]> && <server.flag[fishing_minigame_active_whirlpool_locations].keys.exists>:
            - define existing <[existing].include[<server.flag[fishing_minigame_active_whirlpool_locations].keys>]>
        - if <server.has_flag[fishing_minigame_active_whirlpool_locations]> && <server.flag[fishing_minigame_active_whirlpool_locations].size> > 0:
            - define existing <[existing].include[<server.flag[fishing_minigame_active_whirlpool_locations]>]>
        - if <server.has_flag[fishingminigame.megawhirlpool]>:
            - define existing <[existing].include[<server.flag[fishingminigame.megawhirlpool].first>]>
            - narrate <[existing]>
        - define list <list[]>
        - while <[list].size> < <[amount]>:
            - define whirlpoolLoc <server.flag[fishing_minigame_whirlpool_locations].random>
            - foreach <[existing]> as:loc:
                - if <proc[whirlpools_intersect].context[<[loc]>|<[whirlpoolLoc]>]>:
                    - while next
            - foreach <[list]> as:loc:
                - if <proc[whirlpools_intersect].context[<[loc]>|<[whirlpoolLoc]>]>:
                    - while next
            - define list:->:<[whirlpoolLoc]>
        - determine <[list]>

# % ██ [ Returns the available midi tracks ] ██
fishing_minigame_get_all_music_tracks:
    debug: false
    type: procedure
    script:
        - define tracks <server.list_files[midi/mp3_player]>
        - define music <map[]>
        - foreach <[tracks]> as:track:
            - define track <[track].replace[.mid].with[]>
            - define split <[track].split[-]>
            - define music <[music].include[<[split].get[1]>=<map[author=<[split].get[2]>;filename=mp3_player/<[track]>]>]>
        - determine <[music]>

# % ██ [ Returns the token item with the balance ] ██
fishing_minigame_get_fishtoken_item:
    debug: false
    type: procedure
    definitions: player
    script:
        - define fishtokenwallet <item[fishing_minigame_fishtoken_item]>
        - define displayName "<&d><&l><[player].flag[fishingminigame.fishtokens].round_to[2].format_number> Fishtokens"
        - adjust def:fishtokenwallet display:<[displayName]>
        - determine <[fishtokenwallet]>

# % ██ [ Returns the proper bucket item ] ██
fishing_minigame_get_bucket_type:
    debug: false
    type: procedure
    definitions: player
    script:
        - define fishAmount <[player].flag[fishingminigame.bucket.fish].size>
        - if <[fishAmount]> == 0:
            - determine fishing_minigame_fish_bucket_empty
        - else if <proc[fishing_minigame_bucket_full].context[<[player]>]>:
            - determine fishing_minigame_fish_bucket_full
        - else if <[fishAmount]> > 0:
            - determine fishing_minigame_fish_bucket

# % ██ [ Procedure for finding nearest whirlpool ] ██
fishing_minigame_find_nearest_whirlpool:
    debug: false
    type: procedure
    definitions: loc
    script:
        - define closestWhirlpool <server.flag[fishing_minigame_active_whirlpool_locations].keys.first>
        - define distance <server.flag[fishing_minigame_active_whirlpool_locations].keys.first>
        - foreach <server.flag[fishing_minigame_active_whirlpool_locations]> key:loc as:entity:
            - if <[closestWhirlpool].distance[<[loc]>]> < <[distance]>:
                - define closestWhirlpool <[loc]>
                - define distance <[closestWhirlpool].distance[<[loc]>]>
        - determine <[closestWhirlpool]>

# % ██ [ Checks if 2 given whirlpools intersect ] ██
whirlpools_intersect:
    debug: false
    type: procedure
    definitions: loc1|loc2
    script:
        - define blockList1 <list[<[loc1]>|<[loc1].right>|<[loc1].backward>|<[loc1].right.backward>]>
        - define blockList2 <list[<[loc2]>|<[loc2].right>|<[loc2].backward>|<[loc2].right.backward>]>
        - determine <[blockList1].contains_any[<[blockList2]>]>

# % ██ [ Function to check if the given location is in whirlpool (used fo the fish hook) ] ██
fishing_minigame_location_in_whirlpool:
    debug: false
    type: procedure
    definitions: location
    script:
        - define locations <server.flag[fishing_minigame_active_whirlpool_locations].keys>
        - if <server.has_flag[fishingminigame.megawhirlpool]>:
            - define locations <[locations].include[<server.flag[fishingminigame.megawhirlpool].first>]>
        - define closest <[locations].sort_by_number[distance[<[location]>]].first>
        - if <[closest].distance[<[location].with_y[<[closest].y>]>]> <= 1.1:
            - determine true
        - determine false

# % ██ [ Returns a random quality ] ██
fishing_minigame_get_random_quality:
    debug: false
    type: procedure
    script:
        - foreach <list[amazing|great|good|okay|bad]> as:quality:
            - if <util.random_chance[<script[fishing_minigame_fish_table].data_key[quality.<[quality]>.weight]>]>:
                - determine <[quality]>

# % ██ [ Returns a random rarity ] ██
fishing_minigame_get_random_rarity:
    debug: false
    type: procedure
    script:
        - foreach <list[legendary|epic|rare|uncommon|common]> as:rarity:
            - if <util.random_chance[<script[fishing_minigame_fish_table].data_key[fish.<[rarity]>.weight]>]>:
                - determine <[rarity]>

# % ██ [ Returns a random fish type from that rarity ] ██
fishing_minigame_get_random_type:
    debug: false
    type: procedure
    definitions: rarity
    script:
        - determine <script[fishing_minigame_fish_table].data_key[fish.<[rarity]>].exclude[weight].keys.random>

# % ██ [ Get rarity by type ] ██
fishing_minigame_get_rarity_by_type:
    debug: false
    type: procedure
    definitions: type
    script:
        - foreach <list[legendary|epic|rare|uncommon|common]> as:rarity:
            - if <script[fishing_minigame_fish_table].data_key[fish.<[rarity]>].exclude[weight].keys.contains[<[type]>]>:
                - determine <[rarity]>

# % ██ [ Returns all fish types ] ██
fishing_minigame_get_all_types:
    debug: false
    type: procedure
    script:
        - define types <list[]>
        - foreach <list[legendary|epic|rare|uncommon|common]> as:rarity:
            - define types:|:<script[fishing_minigame_fish_table].data_key[fish.<[rarity]>].exclude[weight].keys>
        - determine <[types]>

# % ██ [ Returns all fish types ] ██
fishing_minigame_get_all_types_by_rarity:
    debug: false
    type: procedure
    definitions: rarity
    script:
        - determine <script[fishing_minigame_fish_table].data_key[fish.<[rarity]>].exclude[weight].keys>

# % ██ [ Returns a color for the weight based on the random value ] ██
fishing_minigame_get_color_for_weight:
    debug: false
    type: procedure
    definitions: random
    script:
        - if <[random]> < 0.2:
            - determine <script[fishing_minigame_fish_table].parsed_key[quality.bad.color]>
        - else if <[random]> < 0.4:
            - determine <script[fishing_minigame_fish_table].parsed_key[quality.okay.color]>
        - else if <[random]> < 0.6:
            - determine <script[fishing_minigame_fish_table].parsed_key[quality.good.color]>
        - else if <[random]> < 0.8:
            - determine <script[fishing_minigame_fish_table].parsed_key[quality.great.color]>
        - else if <[random]> <= 1:
            - determine <script[fishing_minigame_fish_table].parsed_key[quality.amazing.color]>

# % ██ [ Returns a random weight from that fish type and rarity ] ██
fishing_minigame_get_random_weight_and_size:
    debug: false
    type: procedure
    definitions: type|rarity
    script:
        - define minWeight <script[fishing_minigame_fish_table].data_key[fish.<[rarity]>.<[type]>.minWeight]>
        - define maxWeight <script[fishing_minigame_fish_table].data_key[fish.<[rarity]>.<[type]>.maxWeight]>
        - define diffWeight <[maxWeight].sub[<[minWeight]>]>
        - define minSize <script[fishing_minigame_fish_table].data_key[fish.<[rarity]>.<[type]>.minSize]>
        - define maxSize <script[fishing_minigame_fish_table].data_key[fish.<[rarity]>.<[type]>.maxSize]>
        - define diffSize <[maxSize].sub[<[minSize]>]>
        - define random <util.random.decimal[0].to[1].power[2]>
        - define weightColor <proc[fishing_minigame_get_color_for_weight].context[<[random]>]>
        - determine <map[weight=<[random].mul[<[diffWeight]>].add[<[minWeight]>].round_to[2]>;size=<[random].mul[<[diffSize]>].add[<[minWeight]>].round_to[2]>;color=<[weightColor]>]>

# % ██ [ Returns a random fish item ] ██
fishing_minigame_get_random_fish:
    debug: false
    type: procedure
    script:
        - define rarity <proc[fishing_minigame_get_random_rarity]>
        - define type <proc[fishing_minigame_get_random_type].context[<[rarity]>]>
        - define weightAndSize <proc[fishing_minigame_get_random_weight_and_size].context[<[type]>|<[rarity]>]>
        - define quality <proc[fishing_minigame_get_random_quality]>
        - define valueMulti <script[fishing_minigame_fish_table].data_key[fish.<[rarity]>.<[type]>.valueMulti]>
        - define perfectWeight <script[fishing_minigame_fish_table].data_key[fish.<[rarity]>.<[type]>.maxWeight]>
        - define rarityColor <script[fishing_minigame_fish_table].parsed_key[rarity.<[rarity]>.color]>
        - define qualityColor <script[fishing_minigame_fish_table].parsed_key[quality.<[quality]>.color]>
        - define weightColor <[weightAndSize].get[color]>
        - define perfect false
        - define bestWeight false
        - if <[weightAndSize].get[weight].equals[<[perfectWeight]>]>:
            - define bestWeight true
            - if <[quality].equals[amazing]>:
                - define perfect true

        - define fish <item[tropical_fish]>

        - define lore:|:<&8>+------------------+
        - if !<[rarity].equals[legendary]>:
            - define "lore:|:<&r><&e>Rarity: <&f><[rarityColor]><[rarity].to_sentence_case>"
        - else:
            - define "lore:|:<&r><&e>Rarity: <&f><element[<bold><[rarity].to_sentence_case>].color_gradient[from=#FF930F;to=#FFE15C]>"

        - if <[quality].equals[amazing]>:
            - define "lore:|:<&r><&e>Quality: <&f><&color[<[qualityColor]>]><&l><[quality].to_sentence_case>"
        - else:
            - define "lore:|:<&r><&e>Quality: <&f><&color[<[qualityColor]>]><[quality].to_sentence_case>"

        - if <[bestWeight]>:
            - define "lore:|:<&r><&e>Weight: <&f><&color[<[weightColor]>]><&l><[weightAndSize].get[weight]> lbs"
            - define "lore:|:<&r><&e>Size: <&f><&color[<[weightColor]>]><&l><[weightAndSize].get[size]> in."
        - else:
            - define "lore:|:<&r><&e>Weight: <&f><&color[<[weightColor]>]><[weightAndSize].get[weight]> lbs"
            - define "lore:|:<&r><&e>Size: <&f><&color[<[weightColor]>]><[weightAndSize].get[size]> in."
        - define lore:|:<&8>+------------------+

        - adjust def:fish display:<&r><&f><[rarityColor]><[type].to_sentence_case>
        - adjust def:fish lore:<[lore]>
        - if <[perfect]>:
            - adjust def:fish enchantments:sharpness=1
            - adjust def:fish hides:enchants
        - adjust def:fish flag_map:<map[type=<[type]>;rarity=<[rarity]>;quality=<[quality]>;weight=<[weightAndSize].get[weight]>;size=<[weightAndSize].get[size]>;valueMulti=<[valueMulti]>;perfect=<[perfect]>]>
        - determine <[fish]>

# % ██ [ Returns a list of every possible whirlpool location ] ██
fishing_minigame_generate_possible_whirlpool_locations:
    debug: false
    type: procedure
    definitions: cuboid
    script:
        - define validLocations <list[]>
        - foreach <[cuboid].blocks[water]> as:water:
            - if <[water].right.is_liquid> && <[water].backward.is_liquid> && <[water].right.backward.is_liquid>:
                - if <[water].up.material.name.equals[air]> && <[water].right.up.material.name.equals[air]> && <[water].backward.up.material.name.equals[air]> && <[water].right.backward.up.material.name.equals[air]>:
                    - define validLocations:->:<[water]>
        - determine <[validLocations]>

# % ██ [ Returns whether the bucket is full or not ] ██
fishing_minigame_bucket_full:
    debug: false
    type: procedure
    definitions: player
    script:
        - define fishAmount <[player].flag[fishingminigame.bucket.fish].size>
        - define maxSize <[player].flag[fishingminigame.bucket.size]>
        - determine <[fishAmount].is_less_than[<[maxSize]>].not>

# % ██ [ Returns the fish value based on its attributes ] ██
fishing_minigame_fish_value:
    debug: false
    type: procedure
    definitions: fish
    script:
        - define rarityMulti <script[fishing_minigame_fish_table].parsed_key[rarity.<[fish].flag[rarity]>.multi]>
        - define qualityMulti <script[fishing_minigame_fish_table].parsed_key[quality.<[fish].flag[quality]>.multi]>
        # % ██ [ Weight * Size * Fish Value Multi * Rarity Multi * Quality Multi ] ██
        - determine <[fish].flag[weight].mul[<[fish].flag[size]>].mul[<[fish].flag[valueMulti]>].mul[<[rarityMulti]>].mul[<[qualityMulti]>]>

# % ██ [ Returns a list of players who have the most catches ] ██
fishing_minigame_top_catchers_daily:
    debug: false
    type: procedure
    script:
        - define players <server.players_flagged[fishingminigame.stats.daily.catch]>
        - foreach <[players]> as:pl:
            - if <[pl].flag[fishingminigame.stats.daily.value]> == 0:
                - define players <[players].exclude[<[pl]>]>
        - determine <[players].sort_by_number[flag[fishingminigame.stats.daily.catch]].reverse>

# % ██ [ Returns a list of players who have the most value ] ██
fishing_minigame_top_value_daily:
    debug: false
    type: procedure
    script:
        - define players <server.players_flagged[fishingminigame.stats.daily.value]>
        - foreach <[players]> as:pl:
            - if <[pl].flag[fishingminigame.stats.daily.value]> == 0:
                - define players <[players].exclude[<[pl]>]>
        - determine <[players].sort_by_number[flag[fishingminigame.stats.daily.value]].reverse>

#- % █████████████████████████████████
#- %            [ Events ]
#- % █████████████████████████████████

# % ██ [ Minigame Timed Events Handling ] ██
fishing_minigame_timed_event_handler:
    debug: false
    type: world
    events:
        on delta time minutely every:5:
            - run fishing_minigame_generate_whirlpools def:<server.flag[fishing_minigame_active_whirlpool_amount]>
            - foreach <server.online_players_flagged[fishingminigame.active]> as:player:
                - if <[player].flag[fishingminigame.active]>:
                    - narrate "<&7>The whirlpools have moved, you might need to find a new spot to fish" targets:<[player]>
        on delta time minutely every:15:
            - wait 15s
            - run fishing_minigame_start_random_event
        on system time 00:00:
            - run fishing_minigame_reset_leaderboards

# % ██ [ Minigame Event Handling ] ██
fishing_minigame_event_handler:
    debug: false
    type: world
    events:
        # % ██ [ Player Catch Fish ] ██
        on player fishes while caught_fish:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - define randomFish <proc[fishing_minigame_get_random_fish]>
                - define rarity <[randomFish].flag[rarity]>
                - if <proc[fishing_minigame_location_in_whirlpool].context[<context.hook.location>]> :
                    - if <server.has_flag[fishingminigame.megawhirlpool]> and <server.flag[fishingminigame.megawhirlpool].first.distance[<context.hook.location.with_y[<server.flag[fishingminigame.megawhirlpool].first.y>]>]> <= 1.1:
                        - flag server fishingminigame.eventcatch:<player.uuid>
                    - if <server.has_flag[fishingminigame.fishfinder]> && <[rarity].equals[<server.flag[fishingminigame.fishfinder]>]>:
                        - flag server fishingminigame.findercatch:<player.uuid>
                    - if !<proc[fishing_minigame_bucket_full].context[<player>]>:
                        - run fishing_minigame_bucket_add def:<player>|<[randomFish]>
                        - remove <context.hook>
                        - determine cancelled
                    - else:
                        - title "title:<&c>Bucket Full!" "subtitle:<&c>Go sell your fish before you catch more!" targets:<player>
                        - narrate "<&c>The fish slipped out of your hands, because you had nowhere to put it! Go sell your fish at the fish merchant before you continue!"
                        - remove <context.hook>
                        - determine cancelled
                - else:
                    - narrate "<&c>There are no fish here, make sure you're fishing in a whirlpool!"
                    - remove <context.hook>
                    - determine cancelled

        on player fishes while caught_entity:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - if <context.entity.entity_type.equals[chicken]> && <server.has_flag[fishingminigame.chickenstuck]> && <context.entity.has_flag[event]>:
                    - adjust <context.entity> gravity:true
                    - shoot <context.entity> destination:<player.location> speed:10
                    - flag server fishingminigame.chickencatch:<player.uuid>
                - else:
                    - remove <context.hook>
                    - determine cancelled

        after player fishes while fishing:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - while <context.hook.fish_hook_state.exists> and !<context.hook.fish_hook_state.equals[bobbing]>:
                    - wait 3s
                - if <context.hook.is_spawned>:
                    - if <proc[fishing_minigame_location_in_whirlpool].context[<context.hook.location>].not> :
                        - narrate "<&c>Make sure you're fishing in a whirlpool to catch fish!"
                    - if <proc[fishing_minigame_bucket_full].context[<player>]>:
                        - title "title:<&c>Bucket Full!" "subtitle:<&c>Go sell your fish before you catch more!" targets:<player>

        # % ██ [ Generates and stores a list of valid whirlpool locations ] ██
        after server start:
            - wait 5s
            - run fishing_minigame_reset_whirlpools
            - run fishing_minigame_reset_whirlpool_locations
            - run fishing_minigame_generate_whirlpools def:<server.flag[fishing_minigame_active_whirlpool_amount]>
            - if !<server.has_flag[fishingminigame.bestcatch.fish]>:
                - flag server fishingminigame.bestcatch.fish:none
                - flag server fishingminigame.bestcatch.player:none

        # % ██ [ Player Interact with Merchant ] ██
        on player clicks in fishing_minigame_merchant_gui:
            - if !<context.item.material.name.equals[air]> && <context.item.script.name.exists>:
                - choose <context.item.script.name>:
                    - case fishing_minigame_start_button:
                        - inventory close
                        - run fishing_minigame_start def:<player>
                    - case fishing_minigame_fishtokens_button:
                        - if <player.has_flag[fishingminigame.fishtokens]>:
                            - run fishing_minigame_shop_open_gui def:<player>
                        - else:
                            - inventory close
                            - narrate "<&c>You cannot access the shop, until you have made some tokens!"
                    - case fishing_minigame_leaderboards_button:
                        - run fishing_minigame_leaderboards_open_gui def:<player>
                    - case fishing_minigame_fish_button:
                        - if <player.has_flag[fishingminigame.bucket.size]>:
                            - run fishing_minigame_open_bucket def:<player>|true
                        - else:
                            - inventory close
                            - narrate "<&c>You dont have a bucket yet! Start playing to get your first for free!"
                    - case fishing_minigame_end_game:
                        - inventory close
                        - run fishing_minigame_stop def:<player>

        # % ██ [ Player Interact with Shop ] ██
        on player clicks in fishing_minigame_shop_gui:
            - if !<context.item.material.name.equals[air]> && <context.item.script.name.exists>:
                - choose <context.item.script.name>:
                    - case fishing_minigame_shop_exchange_item:
                        - inventory close
                        - narrate "<&c>Unavailable during the beta"
                    - case fishing_minigame_shop_skins_item:
                        - inventory close
                        - narrate "<&c>Unavailable during the beta"
                    - case fishing_minigame_shop_music_item:
                        - run fishing_minigame_music_shop_open_gui def:<player>
                    - case fishing_minigame_shop_bucket_item:
                        - if !<proc[fishing_minigame_get_bucket_level].context[<player>].equals[MAX]>:
                            - run fish_tokens_remove def:<player>|2500 save:removed
                            - if <entry[removed].created_queue.determination.first>:
                                - flag <player> fishingminigame.bucket.size:<player.flag[fishingminigame.bucket.size].add[<proc[fishing_minigame_get_slots_to_add].context[<player>]>]>
                                - narrate "<&a>You're backpack just upgraded to level <proc[fishing_minigame_get_bucket_level].context[<player>]>"
                                - run fishing_minigame_shop_open_gui def:<player>
                            - else:
                                - narrate "<&c>You can not afford that!"

        # % ██ [ Player Interact with MP3 Player ] ██
        on player clicks in fishing_minigame_mp3_gui:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - define song <context.item>
                - if <[song].material.name.equals[music_disc_pigstep]>:
                    - if <player.has_flag[fishing_minigame_playing_music]>:
                        - queue <player.flag[fishing_minigame_music_queue]> stop
                        - midi cancel
                        - flag <player> fishing_minigame_playing_music:!
                    - actionbar "<&b>Now playing <[song].display.strip_color>" targets:<player>
                    - inventory close
                    - flag <player> fishing_minigame_playing_music
                    - flag <player> fishing_minigame_last_song:<[song].display.strip_color>
                    - wait 10t
                    - run fishing_minigame_play_song def:<player>|<[song].flag[fileName]> save:queue
                    - flag <player> fishing_minigame_music_queue:<entry[queue].created_queue>
                - else if <[song].material.name.equals[note_block]>:
                    - if <player.has_flag[fishing_minigame_playing_music]>:
                        - queue <player.flag[fishing_minigame_music_queue]> stop
                        - midi cancel
                        - flag <player> fishing_minigame_playing_music:!
                        - run fishing_minigame_mp3_open_gui def:<player>

        # % ██ [ Player Interact with Music Shop ] ██
        on player clicks in fishing_minigame_music_shop_gui:
            - define song <context.item>
            - if <[song].material.name.equals[music_disc_pigstep]>:
                - if !<[song].is_enchanted>:
                    - run fish_tokens_remove def:<player>|1000 save:removed
                    - if <entry[removed].created_queue.determination.first>:
                        - define songName <[song].flag[songName]>
                        - flag <player> fishingminigame.music:<player.flag[fishingminigame.music].include[<[songName]>]>
                        - narrate "<&a><[songName]> has been added to your MP3 Player!"
                        - run fishing_minigame_music_shop_open_gui def:<player>
                    - else:
                        - narrate "<&c>You can not afford that!"

        # % ██ [ Player Interact with Bucket ] ██
        on player clicks in fishing_minigame_bucket_gui:
            - if !<context.item.material.name.equals[air]>:
                - if <context.item.has_flag[type]>:
                    - if <context.click.equals[LEFT]>:
                        - define fish <context.item>
                        - while <[fish].lore.size> > 6:
                            - adjust def:fish lore:<[fish].lore.remove[last]>
                        - run fishing_minigame_bucket_remove def:<player>|<[fish]>
                        - if <context.inventory.slot[1].material.name.equals[barrier]>:
                            - run fishing_minigame_open_bucket def:<player>|true
                            - run fish_tokens_add def:<player>|<proc[fishing_minigame_fish_value].context[<[fish]>]>
                        - else:
                            - run fishing_minigame_open_bucket def:<player>|false
                    - else if <context.click.equals[RIGHT]>:
                        - define fish <context.item>
                        - while <[fish].lore.size> > 6:
                            - adjust def:fish lore:<[fish].lore.remove[last]>
                        - inventory close
                        - run fishing_minigame_show_off def:<player>|<[fish]>
                - if <context.item.script.exists> and <context.item.script.name.equals[fishing_minigame_sell_all]>:
                    - run fishing_minigame_sell_all_fish def:<player>
                    - run fishing_minigame_open_bucket def:<player>|true

        # % ██ [ Right click end fishing ] ██
        on player right clicks block with:fishing_minigame_end_game:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - run fishing_minigame_stop def:<player>
                - determine cancelled

         # % ██ [ Right click handler ] ██
        on player right clicks block:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - if <context.item.script.data_key[data.flag].exists> && <context.item.script.data_key[data.flag].equals[bucket]>:
                    - run fishing_minigame_open_bucket def:<player>|false
                    - determine cancelled
                - if <context.item.script.data_key[data.flag].exists> && <context.item.script.data_key[data.flag].equals[statbook]>:
                    - run fishing_minigame_stats_book_open def:<player>
                    - determine cancelled
                - if <context.item.script.data_key[data.flag].exists> && <context.item.script.data_key[data.flag].equals[mp3]>:
                    - run fishing_minigame_mp3_open_gui def:<player>
                    - determine cancelled

        # # % ██ [ On closes inventory ] ██
        # on player closes inventory:
        #     - define sub_inv <list[fishing_minigame_bucket_gui|fishing_minigame_music_shop_gui|fishing_minigame_shop_gui|fishing_minigame_leaderboards_gui]>
        #     - if <context.inventory.script.name.exists> and <[sub_inv].contains_any[<context.inventory.script.name>]>:
        #         - run fishing_minigame_merchant_open_gui def:<player>

        # % ██ [ Bunch of events to prevent unwanted actions ] ██
        on player picks up item:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - if !<context.item.has_flag[type]>:
                    - determine cancelled
        on player drops item:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - if !<context.item.has_flag[type]>:
                    - determine cancelled
        on player clicks item in inventory:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - if !<context.item.material.name.equals[air]> && <context.item.script.name.exists>:
                    - if <context.item.script.name.equals[fishing_minigame_fish_bucket]> || <context.item.script.name.equals[fishing_minigame_fish_bucket_empty]> || <context.item.script.name.equals[fishing_minigame_fish_bucket_full]>:
                        - determine cancelled passively
                        - run fishing_minigame_open_bucket def:<player>|false
                    - else if <context.item.script.name.equals[fishing_minigame_statistics_book_inv]>:
                        - run fishing_minigame_stats_book_open def:<player>
                        - determine cancelled
                    - else if <context.item.script.name.equals[fishing_minigame_end_game]>:
                        - inventory close
                        - run fishing_minigame_stop def:<player>
                    - else if <context.item.script.data_key[data.flag].exists> && <context.item.script.data_key[data.flag].equals[mp3]>:
                        - run fishing_minigame_mp3_open_gui def:<player>
                    - determine cancelled
        on player opens inventory:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - adjust <player> item_on_cursor:<item[air]>
        on player drags in inventory:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - determine cancelled
        on player swaps items:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - determine cancelled
        on player breaks block:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - determine cancelled
        on player places block:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - determine cancelled
        # on command:
        #     - if <context.source_type.equals[PLAYER]>:
        #         - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
        #             - run fishing_minigame_stop def:<player>
        on player right clicks entity:
            - if <player.has_flag[fishingminigame.active]> && <player.flag[fishingminigame.active]>:
                - if <context.entity.is_npc>:
                    - if !<context.entity.scripts.parse[name].contains[fishing_minigame_merchant_npc]>:
                        - run fishing_minigame_stop def:<player>
        on player joins:
            - if !<player.has_flag[fishingminigame.music]>:
                - flag <player> fishingminigame.music:<list[]>
        on player quits:
            - if <player.has_flag[fishing_minigame_playing_music]>:
                - queue <player.flag[fishing_minigame_music_queue]> stop
                - midi cancel
                - flag <player> fishing_minigame_playing_music:!

# % ██ [ Minigame Merchant Handling ] ██
fishing_minigame_merchant_npc:
    debug: false
    type: assignment
    actions:
        on assignment:
            - trigger name:click state:true
        on click:
            - run fishing_minigame_merchant_open_gui def:<player>

#- % █████████████████████████████████
#- %          [ Inventories ]
#- % █████████████████████████████████

fishing_minigame_merchant_open_gui:
    type: task
    definitions: player
    debug: false
    build_inventory:
        - define inventory <inventory[fishing_minigame_merchant_gui]>
        - if <[player].has_flag[fishingminigame.active]> && <[player].flag[fishingminigame.active]>:
            - inventory set o:fishing_minigame_end_game slot:10 d:<[inventory]>
            - inventory set o:fishing_minigame_end_game slot:11 d:<[inventory]>
            - inventory set o:fishing_minigame_end_game slot:12 d:<[inventory]>
            - inventory set o:fishing_minigame_end_game slot:19 d:<[inventory]>
            - inventory set o:fishing_minigame_end_game slot:20 d:<[inventory]>
            - inventory set o:fishing_minigame_end_game slot:21 d:<[inventory]>
        - else:
            - inventory set o:fishing_minigame_start_button slot:10 d:<[inventory]>
            - inventory set o:fishing_minigame_start_button slot:11 d:<[inventory]>
            - inventory set o:fishing_minigame_start_button slot:12 d:<[inventory]>
            - inventory set o:fishing_minigame_start_button slot:19 d:<[inventory]>
            - inventory set o:fishing_minigame_start_button slot:20 d:<[inventory]>
            - inventory set o:fishing_minigame_start_button slot:21 d:<[inventory]>
        - define tokensButton <item[fishing_minigame_fishtokens_button]>
        - define tokensLore <[tokensButton].lore>
        - if <[player].has_flag[fishingminigame.fishtokens]>:
            - define newLoreLine "<&a>Fishtokens Amount: <[player].flag[fishingminigame.fishtokens].round_to[2].format_number> <&r><&font[adriftus:chat]><&chr[0045]>"
        - else:
            - define newLoreLine "<&a>Fishtokens Amount: 0 <&r><&font[adriftus:chat]><&chr[0045]>"
        - define tokensLore <[tokensLore].set_single[<[newLoreLine]>].at[3]>
        - adjust def:tokensButton lore:<[tokensLore]>
        - inventory set o:<[tokensButton]> slot:38 d:<[inventory]>
        - inventory set o:<[tokensButton]> slot:39 d:<[inventory]>
        - inventory set o:<[tokensButton]> slot:40 d:<[inventory]>
        - inventory set o:fishing_minigame_leaderboards_button slot:9 d:<[inventory]>
        - inventory set o:fishing_minigame_fish_button slot:42 d:<[inventory]>
        - inventory set o:fishing_minigame_fish_button slot:43 d:<[inventory]>
    script:
        - inject locally path:build_inventory
        - inventory open d:<[inventory]>

fishing_minigame_merchant_gui:
    type: inventory
    inventory: chest
    size: 45
    debug: false
    title: <&f><&font[adriftus:fishing_minigame]><&chr[F808]><&chr[0001]>
    gui: true
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

fishing_minigame_shop_open_gui:
    type: task
    definitions: player
    debug: false
    build_inventory:
        - define inventory <inventory[fishing_minigame_shop_gui]>
        - define bucketUpgrade <item[fishing_minigame_shop_bucket_item]>
        - define bucketLore "<[bucketUpgrade].lore.set_single[<&r><&3>Current Level: <&b><proc[fishing_minigame_get_bucket_level].context[<[player]>]>].at[6]>"
        - if <proc[fishing_minigame_get_bucket_level].context[<[player]>].equals[MAX]>:
            - define bucketLore <[bucketLore].remove[10|9|8|7]>
        - adjust def:bucketUpgrade lore:<[bucketLore]>
        - inventory set o:<[bucketUpgrade]> slot:17 d:<[inventory]>
    script:
        - inject locally path:build_inventory
        - inventory open d:<[inventory]>

fishing_minigame_shop_gui:
    type: inventory
    inventory: chest
    size: 27
    debug: false
    title: <&b>Shop
    gui: true
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [fishing_minigame_shop_exchange_item] [] [fishing_minigame_shop_skins_item] [] [fishing_minigame_shop_music_item] [] [] []
    - [] [] [] [] [] [] [] [] []

fishing_minigame_bucket_open_gui:
    type: task
    debug: false
    definitions: player|merchant
    build_inventory:
        - define inventory <inventory[fishing_minigame_bucket_gui]>
        - define bucketLevel <proc[fishing_minigame_get_bucket_level].context[<[player]>]>
        - adjust def:inventory title:<proc[fishing_minigame_get_bucket_name].context[<[bucketLevel]>]>
        - define bucketSlots <proc[fishing_minigame_get_slot_list_by_level].context[<[bucketLevel]>]>
        - define fishes <[player].flag[fishingminigame.bucket.fish]>
        - foreach <[fishes]> as:fish:
            - define fishCopy <item[<[fish]>]>
            - if <[merchant]>:
                - define fishLore "<[fish].lore.include[<&r><&b>Value: <&r><&b><proc[fishing_minigame_fish_value].context[<[fish]>].round_to[2].format_number> <&font[adriftus:chat]><&chr[0045]>]>"
                - define fishLore <[fishLore].include[<&r>]>
                - define fishLore "<[fishLore].include[<&r><element[➤ Click to Sell].color_gradient[from=#62FF00;to=#CBFFB9]>]>"
            - else:
                - define fishLore "<[fish].lore.include[<&r><element[➤ Left Click to Trash].color_gradient[from=#FF2929;to=#FF9292]>]>"
                - define fishLore "<[fishLore].include[<&r><element[➤ Right Click to Show Off in Chat].color_gradient[from=#FF8400;to=#FFC481]>]>"
            - adjust def:fishCopy lore:<[fishLore]>
            - inventory set o:<[fishCopy]> slot:<[bucketSlots].first> d:<[inventory]>
            - define bucketSlots <[bucketSlots].remove[first]>
        - if <[merchant]>:
            - inventory set o:fishing_minigame_sell_all slot:1 d:<[inventory]>
    script:
        - inject locally path:build_inventory
        - inventory open d:<[inventory]>

fishing_minigame_bucket_gui:
    type: inventory
    inventory: chest
    size: 54
    title: <&f><&font[adriftus:fishing_minigame]><&chr[F808]><&chr[0021]>
    gui: true
    debug: false
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

fishing_minigame_leaderboards_open_gui:
    type: task
    definitions: player
    debug: false
    build_inventory:
        - define inventory <inventory[fishing_minigame_leaderboards_gui]>
        - define slots <list[14|15|16|23|24|25]>
        - define colors <list[e|7|6]>
        - define gradients <list[from=#FFEA00;to=#FFF873|from=#A7A7A7;to=#E6E6E6|from=#F08800;to=#FFA057]>
        - define bestCatch <server.flag[fishingminigame.bestcatch.fish]>
        - define bestCatchPlayer <server.flag[fishingminigame.bestcatch.player]>
        - define mostCatchedPlayers <proc[fishing_minigame_top_catchers_daily]>
        - define mostValuePlayers <proc[fishing_minigame_top_value_daily]>

        - define barrier <item[barrier]>
        - adjust def:barrier display:<&c><&l>Empty
        - adjust def:barrier "lore:<&7>This spot is open! Start fishing to claim it!"

        - if <[bestCatch].equals[none]>:
            - inventory set o:<item[player_head[display=<&7><&l>Nobody]]> slot:39 d:<[inventory]>
            - inventory set o:<[barrier]> slot:40 d:<[inventory]>
        - else:
            - define playerName <player[<[bestCatchPlayer]>].name>
            - define playerHead <item[player_head[skull_skin=<[playerName]>]]>
            - adjust def:playerHead "display:<&d><&l>Best Catch"
            - adjust def:playerHead "lore:<&7>Best catch of the day by:<n><&d><player[<[bestCatchPlayer]>].name.color_gradient[from=#FF62FA;to=#FFA8EF]>"
            - inventory set o:<[playerHead]> slot:39 d:<[inventory]>
            - inventory set o:<[bestCatch].unescaped> slot:40 d:<[inventory]>

        - repeat 3:
            - if <[mostCatchedPlayers].get[<[value]>].exists>:
                - define playerName <[mostCatchedPlayers].get[<[value]>].name>
                - define playerHead <item[player_head[skull_skin=<[playerName]>]]>
                - adjust def:playerHead display:<element[<&ns><[value]>].color[<[colors].get[<[value]>]>]>
                - adjust def:playerHead "lore:<&l><element[<bold><[playerName]>].color_gradient[<[gradients].get[<[value]>]>]><n><&8>+---------------+<n><&7>Fish caught: <&a><[mostCatchedPlayers].get[<[value]>].flag[fishingminigame.stats.daily.catch]><n><&8>+---------------+"
                - inventory set o:<[playerHead]> slot:<[slots].first> d:<[inventory]>
                - define slots <[slots].remove[first]>
            - else:
                - inventory set o:<[barrier]> slot:<[slots].first> d:<[inventory]>
                - define slots <[slots].remove[first]>

        - repeat 3:
            - if <[mostValuePlayers].get[<[value]>].exists>:
                - define playerName <[mostValuePlayers].get[<[value]>].name>
                - define playerHead <item[player_head[skull_skin=<[playerName]>]]>
                - adjust def:playerHead display:<element[<&ns><[value]>].color[<[colors].get[<[value]>]>]>
                - adjust def:playerHead "lore:<&l><element[<bold><[playerName]>].color_gradient[<[gradients].get[<[value]>]>]><n><&8>+---------------+<n><&7>Value caught: <&a><[mostValuePlayers].get[<[value]>].flag[fishingminigame.stats.daily.value].round_to[2].format_number> <&r><&font[adriftus:chat]><&chr[0045]><n><&8>+---------------+"
                - inventory set o:<[playerHead]> slot:<[slots].first> d:<[inventory]>
                - define slots <[slots].remove[first]>
            - else:
                - inventory set o:<[barrier]> slot:<[slots].first> d:<[inventory]>
                - define slots <[slots].remove[first]>
    script:
        - inject locally path:build_inventory
        - inventory open d:<[inventory]>

fishing_minigame_leaderboards_gui:
    type: inventory
    inventory: chest
    size: 45
    debug: false
    title: <&f><&font[adriftus:fishing_minigame]><&chr[F808]><&chr[0003]>
    gui: true
    definitions:
        green: <item[lime_stained_glass_pane[display=<&r> ]]>
        gold: <item[yellow_stained_glass_pane[display=<&r> ]]>
        silver: <item[gray_stained_glass_pane[display=<&r> ]]>
        bronze: <item[orange_stained_glass_pane[display=<&r> ]]>
        f: <item[feather].with[custom_model_data=3;display=<&r><&sp>]>
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

fishing_minigame_mp3_open_gui:
    type: task
    definitions: player
    debug: false
    build_inventory:
        - define inventory <inventory[fishing_minigame_mp3_gui]>
        - define music <proc[fishing_minigame_get_all_music_tracks]>
        - define ownedTracks <[player].flag[fishingminigame.music]>

        - if <[player].has_flag[fishing_minigame_playing_music]>:
            - define noteblock <item[fishing_minigame_mp3_stop_button]>
            - adjust def:noteblock "lore:<&7>Currently Playing:<n><&a><[player].flag[fishing_minigame_last_song]><n><&r><n><&r><element[➤ Press to Interrupt].color_gradient[from=#FF2929;to=#FF9292]>"
            - inventory set o:<[noteblock]> slot:50 d:<[inventory]>
        - else:
            - define noteblock <item[fishing_minigame_mp3_no_button]>
            - inventory set o:<[noteblock]> slot:50 d:<[inventory]>
        - if <[ownedTracks].size> > 0:
            - foreach <[ownedTracks]> as:track:
                - define trackName <[track].replace[_].with[<&sp>]>
                - define item <item[music_disc_pigstep[hides=all]]>
                - adjust def:item display:<&6><&l><[trackName]>
                - adjust def:item "lore:<&7>By: <[music].get[<[track]>].get[author].replace[_].with[<&sp>]>"
                - adjust def:item flag:fileName:<[music].get[<[track]>].get[filename]>
                - inventory set o:<[item]> slot:<[inventory].first_empty> d:<[inventory]>
    script:
        - inject locally path:build_inventory
        - inventory open d:<[inventory]>

fishing_minigame_mp3_gui:
    type: inventory
    inventory: chest
    size: 54
    debug: false
    title: <&6>MP3 Player
    gui: true
    definitions:
        gold: <item[orange_stained_glass_pane[display=<&r> ]]>
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [gold] [gold] [gold] [gold] [] [gold] [gold] [gold] [gold]

fishing_minigame_music_shop_open_gui:
    type: task
    definitions: player
    debug: false
    build_inventory:
        - define inventory <inventory[fishing_minigame_music_shop_gui]>
        - define music <proc[fishing_minigame_get_all_music_tracks]>
        - define ownedTracks <[player].flag[fishingminigame.music]>

        - foreach <[music]> key:track as:map:
            - define trackName <[track].replace[_].with[<&sp>]>
            - define item <item[music_disc_pigstep[hides=all]]>
            - adjust def:item display:<&6><&l><[trackName]>
            - if <[ownedTracks].contains[<[track]>]>:
                - adjust def:item enchantments:sharpness=1
                - adjust def:item hides:enchants
                - adjust def:item "lore:<&7>By: <[map].get[author].replace[_].with[<&sp>]><n><&r><n><&r><element[You own this song].color_gradient[from=#FF8400;to=#FFC481]>"
            - else:
                - adjust def:item "lore:<&7>By: <[map].get[author].replace[_].with[<&sp>]><n><&7>Price: <&b>1000<&r><&font[adriftus:chat]><&chr[0045]><&r><n><&r><n><&r><element[➤ Press to Purchase].color_gradient[from=#FF8400;to=#FFC481]>"
            - adjust def:item flag:fileName:<[map].get[filename]>
            - adjust def:item flag:songName:<[track]>
            - inventory set o:<[item]> slot:<[inventory].first_empty> d:<[inventory]>
    script:
        - inject locally path:build_inventory
        - inventory open d:<[inventory]>

fishing_minigame_music_shop_gui:
    type: inventory
    inventory: chest
    size: 45
    debug: false
    title: <&6>Music Shop
    gui: true
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

#- % █████████████████████████████████
#- %             [ Items ]
#- % █████████████████████████████████

# % ██ [ Fishing Loot Table ] ██
fishing_minigame_fish_table:
    debug: false
    type: data
    rarity:
        common:
            color: <&f><&l>
            multi: 0.1
        uncommon:
            color: <&a><&l>
            multi: 0.25
        rare:
            color: <&b><&l>
            multi: 0.5
        epic:
            color: <&d><&l>
            multi: 0.75
        legendary:
            color: <&6><&l>
            multi: 1
    quality:
        shit:
            weight: 100
            color: <color[#d2691e]>
            multi: 0.01
        bad:
            weight: 99
            color: <color[#D61F1F]>
            multi: 0.5
        okay:
            weight: 60
            color: <color[#ff5f56]>
            multi: 0.75
        good:
            weight: 40
            color: <color[#FFD301]>
            multi: 1
        great:
            weight: 20
            color: <color[#7BB662]>
            multi: 1.5
        amazing:
            weight: 10
            color: <color[#00FF00]>
            multi: 2
    fish:
        common:
            weight: 100
            flounder:
                minWeight: 0.5
                maxWeight: 15
                minSize: 8.7
                maxSize: 23.6
                valueMulti: 0.05
            bass:
                minWeight: 0.5
                maxWeight: 8
                minSize: 10
                maxSize: 25
                valueMulti: 0.1
            minnow:
                minWeight: 0.5
                maxWeight: 2
                minSize: 1.5
                maxSize: 4
                valueMulti: 1
            shrimp:
                minWeight: 0.1
                maxWeight: 1
                minSize: 0.8
                maxSize: 10
                valueMulti: 0.5
            herring:
                minWeight: 0.5
                maxWeight: 2.5
                minSize: 25
                maxSize: 45
                valueMulti: 0.1
        uncommon:
            weight: 20
            tuna:
                minWeight: 3
                maxWeight: 1500
                minSize: 18
                maxSize: 180
                valueMulti: 0.002
            cod:
                minWeight: 10
                maxWeight: 300
                minSize: 40
                maxSize: 80
                valueMulti: 0.01
            trout:
                minWeight: 0.5
                maxWeight: 10
                minSize: 8
                maxSize: 28
                valueMulti: 0.35
            mackerel:
                minWeight: 1
                maxWeight: 8
                minSize: 8
                maxSize: 26
                valueMulti: 0.6
            catfish:
                minWeight: 1
                maxWeight: 200
                minSize: 1
                maxSize: 62
                valueMulti: 0.08
        rare:
            weight: 10
            salmon:
                minWeight: 15
                maxWeight: 140
                minSize: 18
                maxSize: 60
                valueMulti: 0.13
            snapper:
                minWeight: 1
                maxWeight: 50
                minSize: 5
                maxSize: 40
                valueMulti: 0.3
            carp:
                minWeight: 5
                maxWeight: 110
                minSize: 10
                maxSize: 48
                valueMulti: 0.1
            perch:
                minWeight: 0.5
                maxWeight: 5
                minSize: 5
                maxSize: 20
                valueMulti: 4
        epic:
            weight: 4
            halibut:
                minWeight: 2.2
                maxWeight: 570
                minSize: 18
                maxSize: 100
                valueMulti: 0.01
            mahimahi:
                minWeight: 12
                maxWeight: 40
                minSize: 5
                maxSize: 30
                valueMulti: 0.3
            sturgeon:
                minWeight: 50
                maxWeight: 3500
                minSize: 24
                maxSize: 288
                valueMulti: 0.001
            stingray:
                minWeight: 500
                maxWeight: 800
                minSize: 72
                maxSize: 96
                valueMulti: 0.005
            swordfish:
                minWeight: 80
                maxWeight: 1430
                minSize: 96
                maxSize: 180
                valueMulti: 0.005
        legendary:
            weight: 1
            sawfish:
                minWeight: 1000
                maxWeight: 1500
                minSize: 276
                maxSize: 300
                valueMulti: 0.005
            anglerfish:
                minWeight: 15
                maxWeight: 70
                minSize: 9
                maxSize: 40
                valueMulti: 1
            shark:
                minWeight: 0.5
                maxWeight: 5000
                minSize: 8
                maxSize: 552
                valueMulti: 0.005
            moonfish:
                minWeight: 10
                maxWeight: 600
                minSize: 20
                maxSize: 72
                valueMulti: 0.1

# % ██ [ Fishing Rod ] ██
fishing_minigame_bad_rod:
    debug: false
    type: item
    material: fishing_rod
    mechanisms:
      unbreakable: true
    display name: <&a><&l>Fishing Rod
    lore:
    - <&7>Your basic fishing rod.
    - <&7>Use this to catch fish (duh).

# % ██ [ Fishing Tokens Wallet ] ██
fishing_minigame_fishtoken_item:
    debug: false
    type: item
    material: iron_nugget
    display name: <&d><&l>0 Fishtokens
    mechanisms:
        custom_model_data: 40
    lore:
    - <&7>Your fishtoken wallet.
    - <&7>This will display your fishtoken balance.

# % ██ [ Shop Excahnge item ] ██
fishing_minigame_shop_exchange_item:
    debug: false
    type: item
    material: iron_nugget
    display name: <&b><&l>5,000<&r><&font[adriftus:chat]><&chr[0045]><&r> <&b><&l>-<&gt> $10
    mechanisms:
        custom_model_data: 40
    lore:
    - <&7>Exchange your fish tokens
    - <&7>to gain some currency
    - <&7>for the server.
    - <&r>
    - <&r><element[➤ Click to Exchange].color_gradient[from=#00DDFF;to=#A6F8FF]>

# % ██ [ Shop fishing skins item ] ██
fishing_minigame_shop_skins_item:
    debug: false
    type: item
    material: fishing_rod
    display name: <&b><&l>Fishing Rod Skins
    lore:
    - <&7>Purchase fishing rod skins here!
    - <&7>This is how you can show off
    - <&7>your riches to your fellow
    - <&7>fishermen!
    - <&r>
    - <&r><element[➤ Click to View Options].color_gradient[from=#00DDFF;to=#A6F8FF]>

# % ██ [ Shop music item ] ██
fishing_minigame_shop_music_item:
    debug: false
    type: item
    material: jukebox
    display name: <&b><&l>Music
    lore:
    - <&7>Purchase music here!
    - <&7>After purchase, slap the disc
    - <&7>in your mp3 player, and listen
    - <&7>to jams while fishing!
    - <&r>
    - <&r><element[➤ Click to View Options].color_gradient[from=#00DDFF;to=#A6F8FF]>

# % ██ [ Shop music item ] ██
fishing_minigame_shop_bucket_item:
    debug: false
    type: item
    material: water_bucket
    display name: <&b><&l>Bucket Upgrades
    lore:
    - <&7>Purchase bucket upgrades here!
    - <&7>These will allow you to carry
    - <&7>more fish around, without having
    - <&7>to contantly sell!
    - <&r>
    - <&r><&3>Current Level: <&b>1
    - <&r>
    - <&r><&3>Upgrade Price: <&b>2,500<&r><&font[adriftus:chat]><&chr[0045]><&r>
    - <&r>
    - <&r><element[➤ Click to Upgrade].color_gradient[from=#00DDFF;to=#A6F8FF]>

# % ██ [ End Game ] ██
fishing_minigame_end_game:
    debug: false
    type: item
    material: feather
    display name: <&c><&l>Finish Fishing
    mechanisms:
        custom_model_data: 3
    lore:
    - <&7>This will stop the fishing minigame.
    - <&7>and return you back to normal.
    - <&r>
    - <&r><element[➤ Click to End].color_gradient[from=#FF2929;to=#FF9292]>

# % ██ [ Fish Bucket Empty ] ██
fishing_minigame_fish_bucket_empty:
    debug: false
    type: item
    material: water_bucket
    display name: <&e><&l>Empty Bucket
    data:
        flag: bucket
    lore:
    - <&7>Your fish storage.
    - <&7>Currently empty, what are you waiting for?
    - <&r>
    - <&r><element[➤ Click to View].color_gradient[from=#FFF95B;to=#FFFCB0]>

# % ██ [ Fish Bucket ] ██
fishing_minigame_fish_bucket:
    debug: false
    type: item
    material: tropical_fish_bucket
    display name: <&e><&l>Fish Bucket
    data:
        flag: bucket
    lore:
    - <&7>Your fish storage.
    - <&r>
    - <&r><element[➤ Click to View].color_gradient[from=#FFF95B;to=#FFFCB0]>

# % ██ [ Fish Bucket Empty ] ██
fishing_minigame_fish_bucket_full:
    debug: false
    type: item
    material: pufferfish_bucket
    display name: <&e><&l>Fish Bucket <&c><&l>[FULL]
    data:
        flag: bucket
    lore:
    - <&7>Your fish storage.
    - <&7>The bucket is full! Sell your fish at the merchant
    - <&r>
    - <&r><element[➤ Click to View].color_gradient[from=#FFF95B;to=#FFFCB0]>

# % ██ [ Fish bucket sell all ] ██
fishing_minigame_sell_all:
    debug: false
    type: item
    material: barrier
    display name: <&c><&l>Sell All
    lore:
    - <&7>This will sell all the fish in your bucket.
    - <&r>
    - <&r><element[➤ Click to Sell All].color_gradient[from=#FF2929;to=#FF9292]>

# % ██ [ Fish Bucket ] ██
fishing_minigame_statistics_book_inv:
    debug: false
    type: item
    material: book
    display name: <&b><&l>Statistics
    data:
        flag: statbook
    lore:
    - <&7>Your all time statistics.
    - <&r>
    - <&r><element[➤ Click to View].color_gradient[from=#00DDFF;to=#A6F8FF]>

# % ██ [ MP3 Player ] ██
fishing_minigame_mp3_player:
    debug: false
    type: item
    material: jukebox
    display name: <&6><&l>MP3 Player
    data:
        flag: mp3
    lore:
    - <&7>Play your music!
    - <&7>Purchase more songs at the
    - <&7>fishing merchant
    - <&r>
    - <&r><element[➤ Click to Open].color_gradient[from=#FF8400;to=#FFC481]>

# % ██ [ Start Minigame Button ] ██
fishing_minigame_start_button:
    debug: false
    type: item
    material: feather
    display name: <&b><&l>Start fishing!
    mechanisms:
        custom_model_data: 3
    lore:
    - <&7>You ready to begin your fishing journey?
    - <&r>
    - <&r><element[➤ Click to Start Minigame].color_gradient[from=#6DD5FA;to=#FFFFFF]>

# % ██ [ Fishtokens Button ] ██
fishing_minigame_fishtokens_button:
    debug: false
    type: item
    material: feather
    display name: <&a><&l>Pro Shop
    mechanisms:
        custom_model_data: 3
    lore:
    - <&7>This is your fishing currency.
    - <&r>
    - <&a>Fishtokens Amount: 0
    - <&r>
    - <&r><element[➤ Fishtoken Shop].color_gradient[from=#62FF00;to=#CBFFB9]>

# % ██ [ Leaderboards Button ] ██
fishing_minigame_leaderboards_button:
    debug: false
    type: item
    material: feather
    display name: <&d><&l>Leaderboards
    mechanisms:
        custom_model_data: 3
    lore:
    - <&7>View who is leading todays competition.
    - <&r>
    - <&r><element[➤ View Leaderboards].color_gradient[from=#FF34EE;to=#FFC4F4]>

# % ██ [ Sell Fish Button ] ██
fishing_minigame_fish_button:
    debug: false
    type: item
    material: feather
    display name: <&e><&l>Sell Fish
    mechanisms:
        custom_model_data: 3
    lore:
    - <&7>Get your catch valued by the merchant.
    - <&r>
    - <&r><element[➤ View Your Value].color_gradient[from=#FFF95B;to=#FFFCB0]>

# % ██ [ MP3 No Song ] ██
fishing_minigame_mp3_no_button:
    debug: false
    type: item
    material: note_block
    display name: <&c><&l>Nothing Playing
    data:
        flag: mp3_no
    lore:
    - <&7>Currently nothing is playing
    - <&7>Select a track to listen to

# % ██ [ MP3 Stop Song ] ██
fishing_minigame_mp3_stop_button:
    debug: false
    type: item
    material: note_block
    display name: <&c><&l>Stop
    data:
        flag: mp3_stop
    mechanisms:
        hides:
        - ENCHANTS
    enchantments:
    - sharpness:1
    lore:
    - <&7>Currently Playing <&a>Song
    - <&r>
    - <&r><element[➤ Press to Interrupt].color_gradient[from=#FF2929;to=#FF9292]>

# % ██ [ Statistics Book ] ██
fishing_minigame_stats_book:
    debug: false
    type: book
    title: Stats
    author: Fishing Merchant
    text:
    - Something went wrong

fishing_minigame_bucket_upgrade:
    debug: false
    type: item
    material: red_stained_glass_pane
    display name: <&c><&l>Locked
    lore:
    - <&7>Upgrade your bucket at the
    - <&7>Fishing Merchant