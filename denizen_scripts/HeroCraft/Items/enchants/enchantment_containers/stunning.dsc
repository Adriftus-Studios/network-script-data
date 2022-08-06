stunning_enchantment:
  type: enchantment
  id: stunning
  debug: false
  slots:
  - mainhand
  rarity: uncommon
  min_cost: <context.level.mul[1]>
  max_cost: <context.level.mul[2]>
  data:
    effect:
      - Can stun monsters on hit for 0.5 seconds per level.
    item_slots:
      - sword
      - axe
  category: breakable
  full_name: <&7>Stunning <context.level.to_roman_numerals>
  min_level: 1
  max_level: 3
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[*_sword|*_axe]>
  after attack:
    - ratelimit <player> 12t
    - if <util.random.int[1].to[10]> > 9 && !<context.victim.has_flag[temp.enchantment_nostun]> && <context.victim.is_spawned>:
      - if <context.victim.entity_type> == player:
        - if !<context.victim.is_npc>:
          - stop
      - playeffect effect:CRIT <context.victim.location> quantity:25
      - playsound sound:entity_<context.victim.entity_type>_hurt <context.victim.location> pitch:0.5
      - define has_ai <context.victim.has_ai>
      - define stun_duration <player.item_in_hand.enchantment_map.get[stunning].mul[10]>
      - flag <context.victim> temp.enchantment_nostun expire:<[stun_duration]>t
      - adjust <context.victim> has_ai:false
      - wait <[stun_duration]>t
      - if !<context.victim.is_spawned>:
        - stop
      - adjust <context.victim> has_ai:<[has_ai]>
