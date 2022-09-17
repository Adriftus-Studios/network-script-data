custom_mob_prefix_evasive:
  Type: world
  debug: false
  events:
    on entity_flagged:evasive damaged by entity:
    - if <util.random.int[1].to[10]> > 8:
      - determine passively cancelled
      - playsound <context.entity.location> sound:ITEM_ARMOR_EQUIP_LEATHER pitch:0.5
      - shoot <context.entity> destination:<context.damager.location.find.surface_blocks.within[2].random.if_null[<context.entity.location.find.surface_blocks.within[2].random>]> speed:2 no_rotate
