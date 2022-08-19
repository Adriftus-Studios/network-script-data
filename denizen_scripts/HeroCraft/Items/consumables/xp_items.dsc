xp_item_10:
  type: item
  debug: false
  material: experience_bottle
  display name: <&a>10 Levels of XP
  data:
    recipe_book_category: misc.xp1
  lore:
    - <&a>Right Click to Consume
    - <&c>Requires the XP to Craft
  flags:
    right_click_script: xp_item_consume
    xp_levels: 10
    on_recipe_formed: xp_item_craft_requirement
    on_craft: xp_item_take_xp
  mechanisms:
    custom_model_data: 1
  recipes:
    1:
      type: shapeless
      input: WRITABLE_BOOK|GLOW_INK_SAC|COPPER_BLOCK

xp_item_30:
  type: item
  debug: false
  material: experience_bottle
  display name: <&a>30 Levels of XP
  data:
    recipe_book_category: misc.xp2
  lore:
    - <&a>Right Click to Consume
    - <&c>Requires the XP to Craft
  flags:
    right_click_script: xp_item_consume
    xp_levels: 30
    on_recipe_formed: xp_item_craft_requirement
    on_craft: xp_item_take_xp
  mechanisms:
    custom_model_data: 2
  recipes:
    1:
      type: shapeless
      input: WRITABLE_BOOK|GLOW_INK_SAC|DIAMOND_BLOCK

xp_item_50:
  type: item
  debug: false
  material: experience_bottle
  display name: <&a>50 Levels of XP
  data:
    recipe_book_category: misc.xp3
  lore:
    - <&a>Right Click to Consume
    - <&c>Requires the XP to Craft
  flags:
    right_click_script: xp_item_consume
    xp_levels: 50
    on_recipe_formed: xp_item_craft_requirement
    on_craft: xp_item_take_xp
  mechanisms:
    custom_model_data: 3
  recipes:
    1:
      type: shapeless
      input: WRITABLE_BOOK|GLOW_INK_SAC|NETHERITE_BLOCK

xp_item_consume:
  type: task
  debug: false
  data:
    10: 160
    30: 1396
    50: 5345
  script:
    - determine passively cancelled
    - ratelimit <player> 1t
    - take iteminhand
    - experience give <script.data_key[data.<context.item.flag[xp_levels]>]>

xp_item_craft_requirement:
  type: task
  debug: false
  script:
    - define xp_needed <script[xp_item_consume].data_key[data.<context.item.flag[xp_levels]>]>
    - if <player.calculate_xp> < <[xp_needed]>:
      - determine cancelled

xp_item_take_xp:
  type: task
  debug: false
  script:
    - define xp_needed <script[xp_item_consume].data_key[data.<context.item.flag[xp_levels]>]>
    - experience take <[xp_needed]>