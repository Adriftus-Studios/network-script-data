custom_mob_suffix_steelskinned:
  Type: world
  debug: false
  events:
    on entity_flagged:steelskinned damaged:
        - playsound <context.entity.location> sound:block_anvil_land pitch:2.0 volume:2.0
        - determine <context.damage.div[4]>
    on entity_flagged:steelskinned dies:
        - determine passively <context.drops.include[<item[steel_ingot].repeat_as_list[5].if_null[]>]>