OrcWeapon_Crusher:
  type: item
  display name: <&f>Orc Crusher
  lore:
  - <&6>Sometimes brute force is supreme.
  material: iron_axe
  flags:
    custom_durability:
      max: 132
      current: 0
  debug: false
  mechanisms:
    custom_model_data: 3001


orc_crusher_effect:
  type: world
  debug: false
  events:
    on player damages entity with:OrcWeapon_Crusher chance:25:
      - cast slow <context.entity> duration:5s
      - playsound sound:ENTITY_IRON_GOLEM_REPAIR <player.location> pitch:2 <context.entity.location>
