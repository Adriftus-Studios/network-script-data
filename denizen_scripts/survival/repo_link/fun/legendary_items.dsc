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

legendary_item_mending_cost_increase:
  type: world
  events:
    on player prepares anvil craft item:
      - if <context.item.has_nbt[legendary]>:
        - determine air
    on player mends item:
      - if <context.item.has_nbt[legendary]>:
        - determine <context.repair_amount.div[3].round_down>
    on player breaks block with:legendary_item_behr_claw:
      - define chance <util.random.int[1].to[10]>
      - if <[chance]> == 1:
        - playsound <player.location> sound:entity_polar_bear_warning sound_category:master
