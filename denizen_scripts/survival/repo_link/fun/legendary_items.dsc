legendary_item_behr_claw:
  type: item
  material: diamond_shovel
  mechanisms:
    custom_model_data: 1
    nbt: legendary/behr
  enchantments:
    - EFFICIENCY:6
    - Mending:1
    - Unbreaking:2
  display name: <&6>Behr's Claw
  lore:
    - <&e>Probably not what they meant by "bear arms".
    - <&a>
    - <&e>I'm not even gonna ask where this came from.

legendary_item_devin_bucket:
  type: item
  material: diamond_boots
  mechanisms:
    custom_model_data: 1
    nbt: legendary/devin
    nbt_attributes: generic.armor/head/0/3|generic.armor_toughness/head/0/2
  enchantments:
    - PROJECTILE_PROTECTION:5
    - BLAST_PROTECTION:5
    - Mending:1
    - Unbreaking:3
  display name: <&6>Devin's Bucket
  lore:
    - <&e>Would you like a bucket?.
    - <&a>
    - <&e>May impair vision.

legendary_item_mending_cost_increase:
  type: world
  events:
    on player prepares anvil craft item:
      - if <context.item.has_nbt[legendary]>:
        - determine air
    on player mends item:
      - if <context.item.has_nbt[legendary]>:
        - determine <context.repair_amount.div[3].round_down>

legendary_effects_handler:
  type: world
  events:
    on player breaks block with:legendary_item_behr_claw:
      - define chance <util.random.int[1].to[10]>
      - if <[chance]> == 1:
        - playsound <player.location> sound:entity_polar_bear_warning sound_category:master

legendary_item_non_head_equip_handler:
  type: world
  events:
    on player clicks in inventory with:legendary_item_devin_bucket:
      - if <context.slot> == 40 && <player.inventory.slot[<context.slot>].material.name> == air:
        - define item_to_equip <context.cursor_item>
        - take cursoritem
        - wait 1t
        - equip head:<[item_to_equip]>
        - stop
      - if <context.slot> == 40 && <player.inventory.slot[<context.slot>].material.name> != air:
        - define item_to_equip <context.cursor_item>
        - take cursoritem
        - define item_to_pickup <player.inventory.slot[context.slot].item>
        - wait 1t
        - equip head:<[item_to_equip]>
        - adjust item_on_cursor <[item_to_pickup]>
        - wait 1t
        - inventory update
        - stop
      - if <context.slot> == 37:
        - determine cancelled
    on player clicks legendary_item_devin_bucket in inventory:
      - if <context.is_shift_click>:
        - if <context.slot> != 40:
          - determine passively cancelled
          - define item_to_equip <context.item>
          - if <player.inventory.slot[40].material.name> == air:
            - take <player.inventory.slot[<context.slot>]>
            - wait 1t
            - equip head:<[item_to_equip]>
            - stop
