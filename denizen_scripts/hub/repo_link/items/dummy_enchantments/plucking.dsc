plucking_enchantment:
  type: enchantment
  id: plucking
  slots:
  - mainhand
  rarity: rare
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[1]>
  data:
    effect:
      - Allows you to pluck chickens.
      - <empty>
      - Costs durability to use.
    item_slots:
      - shears
  category: digger
  full_name: <&7>Plucking <context.level.to_roman_numerals>
  min_level: 1
  max_level: 1
  is_tradable: false
  can_enchant: <context.item.advanced_matches[shears]>
##  is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:fortune].not>
  treasure_only: true

plucking_enchant_handler:
  type: world
  debug: false
  events:
    on player right clicks chicken with:item_enchanted:plucking:
      - ratelimit <player> 2t
      - if <context.entity.has_flag[plucked_recently]>:
        - actionbar "<&4>Please wait <context.entity.flag_expiration[plucked.recently].from_now.formatted>"
        - stop
      - drop feather quantity:<util.random.int[1].to[3]> <context.entity.location>
      - flag <context.entity> plucked_recently expire:<util.random.int[30].to[60]>s
      - define slot <player.held_item_slot>
      - if <context.hand> == offhand:
        - define slot <player.inventory.slot[41]>
      - if <context.item.max_durability.sub[<context.item.durability>]> > 1:
        - inventory adjust slot:<[slot]> durability:<[slot].durability.add[1]>
        - stop
      - take slot:<[slot]>
