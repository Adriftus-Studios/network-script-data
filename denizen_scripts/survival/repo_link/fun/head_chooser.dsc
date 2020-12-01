head_chooser_token:
  type: item
  material: player_head
  display name: <&b>Decorative Head Chooser
  mechanisms:
    skull_skin: 0f0e290c-fdf2-47a1-b987-f72a0549ed36|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTE0OWZjZDJkMThhYTlhYjQ3OTljZTg5MWJlNGZjOTZmMThiZWU4YWQ2ZjdkYjcxN2RjZWRiZjY1Zjc5N2IwIn19fQ==
  lore:
  - <&e>Can be used to get one of a large variety of heads.
  - <&e>Right click to open menu.

head_chooser_script:
  type: world
  debug: false
  events:
    on player right clicks block with:head_chooser_token:
    - determine passively cancelled
    - ratelimit player 20t
    - flag player text_input:head_list_command/search duration:30s
    - narrate "<&e>Enter the kind of head you would like to search for."
    - narrate "<&e>For example: Monkey, Banana, Fire, Wheel..."





# | everything below here heavily modified using Monkey's head script as a source for heads and basic code.
# +------------------
# |
# | H e a d   L i s t
# |
# | An in-game usable list of custom head items.
# |
# +------------------
#
# @author mcmonkey
# @date 2020/07/17
# @denizen-build REL-1712
# @script-version 1.0
#
# Installation:
# - Put the script in your scripts folder.
# - Add a list of heads to plugins/Denizen/data/head_list.yml (key name 'heads', list of maps with keys 'title', 'uuid', 'value')
# If you need a heads list, here's a list file of about 30000 heads from minecraft-heads.com: https://cdn.discordapp.com/attachments/351925110866968576/733929490132238357/head_list.yml
# - Restart server (or reload and manually '/ex' the 'on server start' actions)
#
# Usage:
# Type "/heads" in-game, optionally with a search like "/heads monkey".
# You will need permission "denizen.heads" to use the command.
# You can just grab heads right out of the opened inventory.
# For large searches, click the left/right arrows freely to move through pages (45 heads per page). There will be up to 1000 results listed for any search.
# Note that searches will cache, meaning the first time you search something might take a second to load. The cache resets when the server restarts.
#
# ---------------------------- END HEADER ----------------------------

head_list_command:
    type: command
    name: heads
    debug: false
    usage: /heads (search)
    description: Searches a list of heads.
    permission: denizen.heads
    script:
    - flag player text_input:!
    - define search <[1]>
    - if <yaml[head_cache].contains[<[search].escaped>]>:
        - define heads <yaml[head_cache].read[<[search].escaped>]>
    - else:
        - define heads <list>
        - define headmegalist <yaml[head_list].read[heads]>
        - foreach <[headmegalist]> as:one_head_map:
            - define title <[one_head_map].get[title]>
            - if <[title].contains[<[search]>]>:
                - define heads:->:player_head[skull_skin=<[one_head_map].get[uuid]>|<[one_head_map].get[value]>;display_name=<[title]>]
                - if <[heads].size> > 1000:
                    - foreach stop
        - yaml set id:head_cache <[search]>:!|:<[heads]>
    - if <[heads].is_empty>:
        - narrate "<&c>No matches for that search."
        - stop
    - if <[heads].size> > 1000:
        - narrate "<&b>Showing first 1000 heads..."
    - else:
        - narrate "<&b>Showing <[heads].size> matching heads..."
    - run head_list_inventory_open_task def:<list_single[<[heads]>].include[1]>

head_list_arrow_left_item:
    type: item
    material: player_head
    display name: <&f>Previous Page
    mechanisms:
        skull_skin: 6d9cb85a-2b76-4e1f-bccc-941978fd4de0|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTE4NWM5N2RiYjgzNTNkZTY1MjY5OGQyNGI2NDMyN2I3OTNhM2YzMmE5OGJlNjdiNzE5ZmJlZGFiMzVlIn19fQ==

head_list_arrow_right_item:
    type: item
    material: player_head
    display name: <&f>Next Page
    mechanisms:
        skull_skin: 3cd9b7a3-c8bc-4a05-8cb9-0b6d4673bca9|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMzFjMGVkZWRkNzExNWZjMWIyM2Q1MWNlOTY2MzU4YjI3MTk1ZGFmMjZlYmI2ZTQ1YTY2YzM0YzY5YzM0MDkxIn19fQ

head_list_exit_item:
    type: item
    material: barrier
    display name: <&f>Close Window

head_list_retry_item:
    type: item
    material: repeater
    display name: <&f>New Search

head_list_inventory:
    type: inventory
    inventory: chest
    debug: false
    title: Heads
    size: 54
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

head_list_inventory_open_task:
    type: task
    definitions: heads|page
    debug: false
    script:
    - flag player current_head_list:!|:<[heads]>
    - flag player current_head_page:<[page]>
    - define inv <inventory[head_list_inventory]>
    - inventory set d:<[inv]> o:<[heads].get[<[page].sub[1].mul[45].max[1]>].to[<[page].mul[45]>]>
    - inventory set d:<[inv]> o:head_list_exit_item slot:50
    - inventory set d:<[inv]> o:head_list_retry_item slot:49
    - if <[page]> > 1:
        - inventory set d:<[inv]> o:head_list_arrow_left_item slot:46
    - if <[heads].size> > <[page].mul[45]>:
        - inventory set d:<[inv]> o:head_list_arrow_right_item slot:54
    - inventory open d:<[inv]>

head_list_world:
    type: world
    debug: true
    events:
        on server start:
        - yaml load:data/head_list.yml id:head_list
        - yaml create id:head_cache
        on player clicks in head_list_inventory priority:1:
            - determine passively cancelled
            - if <context.raw_slot||100> < 46 && <context.item.material.name> != air:
                - inventory set d:<context.inventory> "o:<context.item.with[lore=<&a>Click here to confirm]>" slot:51
                - wait 1t
                - inventory update
            - if <context.raw_slot||100> == 51:
                - take iteminhand
                - give "<context.item.with[lore=<&a> ]>"
                - inventory close d:<context.inventory>
        on player clicks head_list_arrow_left_item in head_list_inventory:
        - determine passively cancelled
        - if !<player.has_flag[current_head_list]>:
            - stop
        - run head_list_inventory_open_task def:<list_single[<player.flag[current_head_list]>].include[<player.flag[current_head_page].sub[1]>]>
        on player clicks head_list_exit_item in head_list_inventory:
        - determine passively cancelled
        - define inv <inventory[head_list_inventory]>
        - inventory close d:<[inv]>
        on player clicks head_list_retry_item in head_list_inventory:
        - determine passively cancelled
        - define inv <inventory[head_list_inventory]>
        - inventory close d:<[inv]>
        - flag player text_input:head_list_command/search duration:30s
        - narrate "<&e>Enter the name of the group you want to claim this chunk to."
        - narrate "<&e>Enter the kind of head you would like to search for."
        - narrate "<&e>For example: Monkey, Banana, Fire, Wheel..."
        on player clicks head_list_arrow_right_item in head_list_inventory:
        - determine passively cancelled
        - if !<player.has_flag[current_head_list]>:
            - stop
        - run head_list_inventory_open_task def:<list_single[<player.flag[current_head_list]>].include[<player.flag[current_head_page].add[1]>]>
