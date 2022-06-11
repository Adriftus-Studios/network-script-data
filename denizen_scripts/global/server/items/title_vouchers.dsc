title_voucher:
  type: item
  debug: false
  material: name_tag

title_voucher_events:
  type: world
  debug: false
  events:
    on player right clicks block with:title_voucher bukkit_priority:LOWEST:
      - determine passively cancelled
      - if <yaml[global.player.<player.uuid>].contains[titles.unlocked.<context.item.flag[title]>]>:
        - narrate "<&c>You already have unlocked this title."
        - stop
      - if <player.has_flag[title_confirm]>:
        - wait 1t
        - if <player.item_in_hand> == <context.item>:
          - define title_id <context.item.flag[title]>
          - inject titles_unlock
          - take iteminhand quantity:1
          - narrate "<&b>You have redeemed the <yaml[titles].read[titles.<context.item.flag[title]>.tag].parse_color><&b> title!"
          - flag player title_confirm:!
      - else:
        - flag player title_confirm duration:10s
        - narrate "<&e>Right click again to confirm claiming this title."