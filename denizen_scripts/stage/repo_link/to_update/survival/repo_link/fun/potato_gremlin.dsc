potato_gremlin_spawn:
  type: world
  events:
    on player drops poisonous_potato:
    - wait 2s
    - if <util.random.int[1].to[100]> <= 50:
      - narrate "<&c>A Potato Gremlin has sprung up!"
      - spawn potato_gremlin_entity <context.entity.location> target:<player>
      - remove <context.entity>
    - else:
      - narrate "<&a>You should be more careful where you throw those!"
      - remove <context.entity>

potato_gremlin_entity:
  type: entity
  custom_name: <&c>Potato Gremlin
  custom_name_visible: true
  entity_type: zombie
  age: baby
  item_in_hand: potato_gremlin_potato_stick
  glowing: true
  experience: 5
  armor_bonus: 15

potato_gremlin_potato_stick:
  type: item
  material: wooden_sword
  display name: <&c>Gremlin Poky
  mechanisms:
    hides: all
  enchantments:
  - sharpness:9
  lore:
  - "<&6>Gremlin Skewer"
  - "<&6>Gremlin Like tato!"
