Fuse_Shot_enchantment:
  type: enchantment
  id: Fuse_Shot
  debug: false
  slots:
  - mainhand
  rarity: very_rare
  min_cost: <context.level.mul[2]>
  max_cost: <context.level.mul[3]>
  data:
    effect:
      - Has a small chance to spawn a TNT block at the victims location.
      - <empty>
      - Will not destroy blocks. Deals 3 damage per level.
    item_slots:
      - bows
  category: bow
  full_name: <&7>Fuse Shot <context.level.to_roman_numerals>
  min_level: 1
  max_level: 5
  treasure_only: true
  is_curse: false
  is_tradable: false
  is_discoverable: true
  can_enchant: <context.item.advanced_matches[bow|crossbow]>
  after attack:
  - ratelimit <player> 12t
  - if <context.victim.is_spawned> && <util.random.int[1].to[10]> > 9:
      - fakespawn primed_tnt <context.victim.location> duration:20t save:fake_n_t
      - define location <entry[fake_n_t].faked_entity.location>
      - playsound sound:ENTITY_TNT_PRIMED <[location]>
      - wait 19t
      - playsound sound:ENTITY_GENERIC_EXPLODE <[location]>
      - playeffect effect:explosion_large at:<[location]> quantity:5
      - playeffect effect:explosion_huge at:<[location]> quantity:1
      - foreach <[location].find_entities.within[4]> as:entity:
        - if !<list[player|wolf|cat|axolotl|villager|dropped_item|armor_stand|item_frame|arrow|trident|shulker_bullet|experience_orb].contains_any[<[entity].entity_type>]> && <[entity].is_Spawned>:
          - define loc2 <[entity].location>
          - hurt <[entity]> cause:entity_explosion source:<player> <context.level.mul[3]>
          - playeffect effect:explosion_normal at:<[loc2]> quantity:3
