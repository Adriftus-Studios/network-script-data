claiming_upgrades_command:
  type: command
  name: claim_upgrades_open
  permission: not.a.perm
  script:
    - inventory open d:claiming_protection_group_upgrades player:<server.match_player[<context.args.first>]>

########################
## GROUP UPGRADES GUI ##
########################

claiming_group_upgrade_item:
  type: item
  debug: false
  material: barrier
  display name: <&c>ERROR - REPORT THIS

claiming_protection_group_upgrades:
  type: inventory
  inventory: chest
  debug: false
  title: <&a>Group Upgrades
  procedural items:
    - foreach <script[claiming_system_upgrade_data].list_keys[upgrades].exclude[claim_limit]> as:upgrade:
      - define name <&e><[upgrade].replace[-].with[<&sp>].replace[_].with[<&sp>].to_titlecase>
      - define cost <script[claiming_system_upgrade_data].data_key[upgrades.<[upgrade]>.cost]>
      - define material <script[claiming_system_upgrade_data].data_key[upgrades.<[upgrade]>.material]>
      - define "lore:<&a>---------------------|<&e>Price<&co><&sp><&a><[cost]>|<&b>Use this item in a claim.|<&b>This will unlock <[name]>|<&a>---------------------"
      - define list:->:<item[claiming_group_upgrade_item].with[material=<[material]>;display_name=<[name]>;lore=<[lore]>;nbt=upgrade/<[upgrade]>|cost/<[cost]>]>
    - determine <[list]>
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&e>]>
    back_button: <item[claiming_back_button].with[nbt=back/back]>
  slots:
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [filler] [] [filler] [] [filler] [] [filler] [] [filler]
    - [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [filler]
    - [] [filler] [filler] [filler] [back_button] [filler] [filler] [filler] [filler]

claiming_protection_group_upgrades_events:
  type: world
  debug: false
  events:
    on player opens claiming_protection_group_upgrades:
      - define cost <script[claiming_system_upgrade_data].parsed_key[upgrades.claim_limit.cost]>
      - define "lore:|:<&a>---------------------|<&e>Price<&co><&sp><&a><[cost]>|<&b>Right click while holding.|<&b>This will unlock <&a>10 <&b>more claims.|<&a>---------------------"
      - give <item[claiming_group_upgrade_item].with[material=gold_block;display_name=<&b>Upgrade<&sp>Claim<&sp>Limit;lore=<[lore]>;nbt=upgrade/claim_limit|cost/<[cost]>]> to:<context.inventory>
    on player clicks item in claiming_protection_group_upgrades:
      - if <context.raw_slot> > 54:
        - stop
      - determine passively cancelled
      - wait 1t
      - if <context.item.has_nbt[upgrade]>:
        - define cost <context.item.nbt[cost]>
        - if <player.money> < <[cost]>:
          - narrate "<&c>You don't have the cash for that."
          - stop
        - take money quantity:<[cost]>
        - give <context.item.with[lore=<context.item.lore.get[3].to[last]>]>
        - if <context.item.nbt[upgrade]> == claim_limit:
          - flag player claim_upgrades:++
      - else if <context.item.has_nbt[back]>:
        - inventory open d:claiming_inventory
    on player right clicks with:claiming_group_upgrade_item:
      - determine passively cancelled
      - ratelimit <player> 2t
      - if <context.item.nbt[upgrade]> == claim_limit:
        - if <yaml[claims].read[limits.max.<player.uuid>]||null> != null:
          - yaml id:claims set limits.max.<player.uuid>:+:10
        - else:
          - yaml id:claims set limits.max.<player.uuid>:+:40
        - narrate "<&7>You now have a max of <&a><yaml[claims].read[limits.max.<player.uuid>]> <&7>claims!"
        - wait 1t
        - take <player.item_in_hand>
        - stop
      - define group <player.location.cuboids.filter[note_name.starts_with[claim]].first.note_name.after[.].before[/]||null>
      - if <[group]> != null:
        - define name <proc[getColorCode].context[<yaml[claims].read[groups.<[group]>.settings.color]>]><yaml[claims].read[groups.<[group]>.settings.display_name]>
        - if <player.flag[upgrade_confirmation]||null> != <[group]>:
          - narrate "<&e>Right click again, if you want to apply this upgrade to <[name]><&e>."
          - flag player upgrade_confirmation:<[group]> duration:10s
        - else:
          - yaml id:claims set groups.<[group]>.upgrades.<context.item.nbt[upgrade]>:true
          - narrate "<&e>You have applied the <context.item.nbt[upgrade]> upgrade to <[name]><&e>."
          - flag player upgrade_confirmation:!
          - wait 1t
          - take <context.item>
