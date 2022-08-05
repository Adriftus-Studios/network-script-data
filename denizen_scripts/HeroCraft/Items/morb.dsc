morb_config:
  type: data
  debug: false
  blacklisted_entities:
    - wither
    - player
    - ender_dragon
    - warden

morb_empty:
  type: item
  debug: false
  material: feather
  display name: <&7>Empty <&a>Morb
  lore:
    - <&b><&l>Single Use Morb
    - <&b>Throw at an Entity to capture it.
    - <&c>Does Not Work On<&co>
    - <&c>- Players
    - <&c>- Wither
    - <&c>- Ender Dragon
    - <&c>- Warden
  mechanisms:
    custom_model_data: 1
  data:
    recipe_book_category: gadgets.morb1
  recipes:
    1:
      type: shaped
      input:
        - diamond|piston|diamond
        - compressed_stone|ghast_tear|compressed_stone
        - obsidian|piston|obsidian

morb_empty_reuseable:
  type: item
  debug: false
  material: feather
  display name: <&a>Reuseable Morb
  lore:
    - <&b><&l>Multiple Use Morb
    - <&b>Throw at an Entity to capture it.
    - <&c>Does Not Work On<&co>
    - <&c>- Players
    - <&c>- Wither
    - <&c>- Ender Dragon
    - <&c>- Warden
  mechanisms:
    custom_model_data: 1
  data:
    recipe_book_category: gadgets.morb2
  flags:
    reuseable: true
  recipes:
    1:
      type: shaped
      input:
        - morb_empty|morb_empty|morb_empty
        - morb_empty|nether_star|morb_empty
        - morb_empty|morb_empty|morb_empty

morb_filled:
  type: item
  debug: false
  material: feather
  display name: <&2>Filled <&a>Morb
  mechanisms:
    custom_model_data: 2

empty_morb_projectile:
  type: entity
  entity_type: snowball
  mechanisms:
    custom_name: <&7>Empty <&a>Morb
    item: feather[custom_model_data=1]

filled_morb_projectile:
  type: entity
  entity_type: snowball
  mechanisms:
    custom_name: <&2>Filled <&a>Morb
    item: feather[custom_model_data=2]

morb_events:
  type: world
  debug: false
  events:
    on player right clicks block with:morb_empty|morb_empty_reuseable:
      - shoot empty_morb_projectile speed:3.7 save:shot
      - flag <entry[shot].shot_entity> morb:<player>
      - flag <entry[shot].shot_entity> reuseable if:<context.item.has_flag[reuseable]>
      - take item:<context.item> quantity:1

    on empty_morb_projectile hits entity:
      - stop if:<context.hit_entity.has_flag[no_morb]>
      - stop if:<script[morb_config].data_key[blacklisted_entities].contains[<context.hit_entity.entity_type>]>
      - define item <item[morb_filled]>
      - if <context.hit_entity.custom_name.is_truthy>:
        - define "list:->:<&e>Name: <&b><context.hit_entity.custom_name>"
      - else:
        - define "list:->:<&e>Name: <&7>Unnamed"
      - define "list:->:<&e>Type: <context.hit_entity.entity_type.replace[_].with[<&sp>].to_titlecase>"
      - if <context.hit_entity.owner.is_truthy>:
        - define "list:->:<&e>Owner: <&b><context.hit_entity.owner.name>"
      - else:
        - define "list:->:<&e>Owner: <&7>Unowned"
      - adjust def:item lore:<[item].lore.if_null[<list>].include[<[list]>]>
      - flag <[item]> reuseable if:<context.projectile.has_flag[reuseable]>
      - flag <context.hit_entity> temp:! if:<context.hit_entity.has_flag[temp]>
      - flag <context.hit_entity> no_modify
      - flag <[item]> describe:<context.hit_entity.describe>
      - drop <[item]> <context.hit_entity.location.above[1]>
      - remove <context.hit_entity>
    on player right clicks block with:morb_filled:
      - take iteminhand quantity:1
      - shoot filled_morb_projectile speed:3.7 save:shot
      - flag <entry[shot].shot_entity> spawn:<context.item.flag[describe]>
    on filled_morb_projectile hits entity:
      - spawn <context.projectile.flag[spawn]> <context.hit_entity.location>
      - drop morb_empty_reuseable if:<context.projectile.has_flag[reuseable]> <context.hit_entity.location>
    on filled_morb_projectile hits block:
      - spawn <context.projectile.flag[spawn]> <context.location.add[<context.hit_face>]>
      - drop morb_empty_reuseable if:<context.projectile.has_flag[reuseable]> <context.location.add[<context.hit_face>]>
