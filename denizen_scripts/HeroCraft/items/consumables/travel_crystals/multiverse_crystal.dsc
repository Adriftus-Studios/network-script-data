multiverse_dust:
  type: item
  material: feather
  display name: <element[Multiverse Dust].rainbow>
  lore:
  - "<&e>What the heck is this?"
  data:
    recipe_book_category: travel
  flags:
    right_click_script: multiverse_dust_task
    soulbound: true
  mechanisms:
    custom_model_data: 500
  recipes:
    1:
      type: shaped
      input:
        - compressed_obsidian|compressed_obsidian|compressed_obsidian
        - compressed_obsidian|nether_star|compressed_obsidian
        - compressed_obsidian|compressed_obsidian|compressed_obsidian

multiverse_dust_task:
  type: task
  debug: false
  script:
    - ratelimit <player> 1t
    - if <context.item.has_flag[last_used]> && <context.item.flag[last_used].from_now.in_minutes> < 10:
      - narrate "<&c>This item has not recharged"
      - narrate "<&e>Cooldown Remaining<&co> <&f><duration[10m].sub[<context.item.flag[last_used].from_now>].formatted>"
      - stop
    - if <bungee.server> == herocraft:
      - inventory flag slot:<player.held_item_slot> last_used:<util.time_now>
      - run herocraft_send_to_world def:zanzabar
    - else if <bungee.server> == zanzabar:
      - inventory flag slot:<player.held_item_slot> last_used:<util.time_now>
      - run herocraft_send_to_world def:herocraft
    - else:
      - narrate "<&c>Nothing happens..."
