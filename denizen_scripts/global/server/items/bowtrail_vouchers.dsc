bowtrail_voucher:
  type: item
  debug: false
  material: name_tag

bowtrail_voucher_events:
  type: world
  debug: false
  events:
    on player right clicks block with:bowtrail_voucher bukkit_priority:LOWEST:
      - determine passively cancelled
      - if <yaml[global.player.<player.uuid>].read[bowtrail.unlocked].contains[<context.item.flag[trail]>]||false>:
        - narrate "<&c>You already have unlocked this bow trail."
        - stop
      - if <player.has_flag[bowtrail_confirm]>:
        - wait 1t
        - if <player.item_in_hand> == <context.item>:
          - define bowtrail <context.item.flag[trail]>
          - inject bowtrail_unlock
          - take iteminhand quantity:1
          - narrate "<&b>You have redeemed the <yaml[bowtrails].read[bowtrails.<context.item.flag[trail]>.name].parse_color><&b> bow trail!"
          - flag player bowtrail_confirm:!
      - else:
        - flag player bowtrail_confirm duration:10s
        - narrate "<&e>Right click again to confirm claiming this bow trail."
