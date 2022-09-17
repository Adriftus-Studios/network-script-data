custom_mob_suffix_teleporting:
  Type: world
  debug: false
  events:
    after entity_flagged:teleporting targets entity chance:25:
        - ratelimit <context.entity> 10s
        - playsound <context.target.location> sound:entity_enderman_teleport volume:2.0
        - playeffect <context.target.eye_location> effect:item_crack quantity:100 offset:0.5,0.5,0.5 special_data::ender_eye
        - playeffect <context.entity.eye_location> effect:item_crack quantity:100 offset:0.5,0.5,0.5 special_data::ender_eye
        - teleport <context.entity> <context.target.location>