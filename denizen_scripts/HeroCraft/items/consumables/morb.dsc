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
  flags:
    right_click_script: morb_throw
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
    right_click_script: morb_throw
    reuseable: true
  recipes:
    1:
      type: shaped
      input:
        - morb_empty|morb_empty|morb_empty
        - morb_empty|nether_star|morb_empty
        - morb_empty|morb_empty|morb_empty

morb_empty_rebounding:
  type: item
  debug: false
  material: feather
  display name: <&a>Rebounding Morb
  lore:
    - <&b><&l>Multiple Use Morb
    - <&b><&l>Rebounds on Use
    - <&c><&l>Does not work at extreme distances
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
    right_click_script: morb_throw
    reuseable: true
    rebounding: true
  #recipes:
    #1:
      #type: shaped
      #input:
        #- morb_empty|morb_empty|morb_empty
        #- morb_empty|nether_star|morb_empty
        #- morb_empty|morb_empty|morb_empty

morb_filled:
  type: item
  debug: false
  material: feather
  display name: <&2>Filled <&a>Morb
  mechanisms:
    custom_model_data: 2
  flags:
    right_click_script: morb_throw_filled

empty_morb_projectile:
  type: entity
  debug: false
  entity_type: snowball
  mechanisms:
    custom_name: <&7>Empty <&a>Morb
    item: feather[custom_model_data=1]

filled_morb_projectile:
  type: entity
  debug: false
  entity_type: snowball
  mechanisms:
    custom_name: <&2>Filled <&a>Morb
    item: feather[custom_model_data=2]

morb_throw:
  type: task
  debug: false
  script:
    - shoot empty_morb_projectile speed:3.7 shooter:<player> save:shot
    - flag <entry[shot].shot_entity> morb:<player>
    - flag <entry[shot].shot_entity> reuseable if:<context.item.has_flag[reuseable]>
    - flag <entry[shot].shot_entity> rebounding if:<context.item.has_flag[rebounding]>
    - flag <entry[shot].shot_entity> owner:<player> if:<context.item.has_flag[rebounding]>
    - flag <entry[shot].shot_entity> on_hit_entity:morb_hits_entity
    - flag <entry[shot].shot_entity> on_hit_block:morb_hits_block
    - take iteminhand quantity:1

morb_hits_entity:
  type: task
  debug: false
  script:
    - stop if:<context.hit_entity.has_flag[no_morb]>
    - if <context.hit_entity.location.town.exists>:
      - if <context.hit_entity.location.town> != <context.projectile.shooter.town.if_null[null]>:
        - inject morb_hits_block
        - stop
    - if <player.worldguard.can_build[<context.hit_entity.location>]>:
      - inject morb_hits_block
      - stop
    - if <context.hit_entity.entity_type> == armor_stand && <context.hit_entity.script.exists>:
      - if <context.projectile.has_flag[rebounding]>:
        - shoot "<entity[dropped_item].with[custom_name=<context.projectile.flag[owner].name>'s Morb;custom_name_visible=true;glowing=true;item=<item[morb_empty_rebounding].with[flag=owner:<context.projectile.flag[owner]>;flag=on_item_pickup:morb_cancel;flag=on_item_pickup_inventory:cancel]>]>" origin:<context.hit_entity.location> destination:<context.projectile.shooter.eye_location> save:shot
      - else:
        - drop morb_empty_reuseable if:<context.projectile.has_flag[reuseable]> <context.hit_entity.location>
    - if <script[morb_config].data_key[blacklisted_entities].contains[<context.hit_entity.entity_type>]> || <context.hit_entity.owner.if_null[null]> != <context.projectile.shooter>:
      - if <context.projectile.has_flag[rebounding]>:
        - shoot "<entity[dropped_item].with[custom_name=<context.projectile.flag[owner].name>'s Morb;custom_name_visible=true;glowing=true;item=<item[morb_empty_rebounding].with[flag=owner:<context.projectile.flag[owner]>;flag=on_item_pickup:morb_cancel;flag=on_item_pickup_inventory:cancel]>]>" origin:<context.hit_entity.location> destination:<context.projectile.shooter.eye_location> save:shot
      - else:
        - drop morb_empty_reuseable if:<context.projectile.has_flag[reuseable]> <context.hit_entity.location>
      - stop
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
    - if <context.projectile.has_flag[rebounding]>:
      - flag <[item]> reuseable
      - flag <[item]> rebounding
      - adjust def:item "display:<&a>Rebounding <[item].display>"
    - else if <context.projectile.has_flag[reuseable]>:
      - flag <[item]> rebounding
      - adjust def:item "display:<&a>Reuseable <[item].display>"
    - flag <context.hit_entity> temp:! if:<context.hit_entity.has_flag[temp]>
    - flag <context.hit_entity> no_modify
    - flag <[item]> describe:<context.hit_entity.describe>
    - if <context.projectile.has_flag[rebounding]>:
      - flag <[item]> on_item_pickup_inventory:cancel
      - flag <[item]> on_item_pickup:morb_cancel
      - flag <[item]> owner:<context.projectile.flag[owner]>
      - shoot "<entity[dropped_item].with[custom_name=<context.projectile.flag[owner].name>'s Morb;custom_name_visible=true;glowing=true;item=<[item]>]>" origin:<context.projectile.location> destination:<context.projectile.shooter.eye_location> save:shot
    - else:
      - drop <[item]> <context.hit_entity.location.above[1]>
    - inventory clear d:<context.hit_entity.inventory> if:<context.hit_entity.inventory.exists>
    - remove <context.hit_entity>

morb_hits_block:
  type: task
  debug: false
  script:
    - if <context.projectile.has_flag[rebounding]>:
      - if <context.projectile.shooter.location.distance[<context.location>]> > 3.9:
        - shoot "<entity[dropped_item].with[custom_name=<context.projectile.flag[owner].name>'s Morb;custom_name_visible=true;glowing=true;item=<item[morb_empty_rebounding].with[flag=owner:<context.projectile.flag[owner]>;flag=on_item_pickup:morb_cancel;flag=on_item_pickup_inventory:cancel]>]>" origin:<context.projectile.location> destination:<context.projectile.shooter.eye_location> save:shot
      - else:
        - spawn "<entity[dropped_item].with[custom_name=<context.projectile.flag[owner].name>'s Morb;custom_name_visible=true;glowing=true;item=<item[morb_empty_rebounding].with[flag=owner:<context.projectile.flag[owner]>;flag=on_item_pickup:morb_cancel;flag=on_item_pickup_inventory:cancel]>]>" <context.projectile.location> save:shot
    - else:
      - drop morb_empty_reuseable <context.projectile.location.center.add[<context.hit_face>]> if:<context.projectile.has_flag[reuseable]>

morb_throw_filled:
  type: task
  debug: false
  script:
    - take iteminhand quantity:1
    - shoot filled_morb_projectile speed:3.7 shooter:<player> save:shot
    - flag <entry[shot].shot_entity> spawn:<context.item.flag[describe]>
    - flag <entry[shot].shot_entity> reuseable if:<context.item.has_flag[reuseable]>
    - flag <entry[shot].shot_entity> rebounding if:<context.item.has_flag[rebounding]>
    - flag <entry[shot].shot_entity> owner:<player> if:<context.item.has_flag[rebounding]>
    - flag <entry[shot].shot_entity> on_hit_entity:filled_morb_hits_entity
    - flag <entry[shot].shot_entity> on_hit_block:filled_morb_hits_block

filled_morb_hits_entity:
  type: task
  debug: false
  script:
    - spawn <context.projectile.flag[spawn]> <context.hit_entity.location>
    - if <context.projectile.has_flag[rebounding]>:
      - shoot "<entity[dropped_item].with[custom_name=<context.projectile.flag[owner].name>'s Morb;custom_name_visible=true;glowing=true;item=<item[morb_empty_rebounding].with[flag=owner:<context.projectile.flag[owner]>;flag=on_item_pickup:morb_cancel;flag=on_item_pickup_inventory:cancel]>]>" origin:<context.hit_entity.location> destination:<context.projectile.shooter.eye_location> save:shot
    - else:
      - drop morb_empty_reuseable if:<context.projectile.has_flag[reuseable]> <context.hit_entity.location>

filled_morb_hits_block:
  type: task
  debug: false
  script:
    - spawn <context.projectile.flag[spawn]> <context.location.add[<context.hit_face>].center.below[0.5]>
    - if <context.projectile.has_flag[rebounding]>:
      - shoot "<entity[dropped_item].with[custom_name=<context.projectile.flag[owner].name>'s Morb;custom_name_visible=true;glowing=true;item=<item[morb_empty_rebounding].with[flag=owner:<context.projectile.flag[owner]>;flag=on_item_pickup:morb_cancel;flag=on_item_pickup_inventory:cancel]>]>" origin:<context.location.add[<context.hit_face.mul[1.5]>]> destination:<context.projectile.shooter.eye_location> save:shot
    - else:
      - drop morb_empty_reuseable if:<context.projectile.has_flag[reuseable]> <context.location.center.add[<context.hit_face>]>

morb_cancel:
  type: task
  debug: false
  script:
    - if <context.item.flag[owner]> == <context.pickup_entity>:
      - determine passively cancelled
      - ratelimit <context.entity> 1s
      - adjust <player> fake_pickup:<context.entity>
      - give <context.item.with[flag=owner:!;flag=on_item_pickup:!;flag=on_item_pickup_inventory:!]> to:<context.pickup_entity.inventory>
      - wait 1t
      - remove <context.entity>
    - else:
      - determine cancelled
