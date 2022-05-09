fake_arrow_enchant_handler:
  type: world
  debug: false
  events:
    on player picks up arrow:
      - if <context.entity.has_flag[fake_arrow]>:
        - determine passively cancelled
        - remove <context.entity>

player_damage_enchant_handler:
  type: world
  debug: false
  events:
    on player damages entity:
      - ratelimit <player> 12t
      - if <context.entity.has_flag[temp.custom_enchant_cruelty]>:
        - define level <player.item_in_hand.enchantment_map.get[cruelty].if_null[0]>
        - hurt <context.entity> <[level].mul[1.5]>
      - if !<context.entity.has_flag[temp.custom_enchant_cruelty]> && !<context.entity.has_flag[temp.custom_enchant_cruelty]>:
        - flag <context.entity> temp.custom_enchant_cruelty
      - if <player.health_percentage> > 90:
        - define cowardice_counter 0
        - foreach <list[38|39]> as:slot:
          - if <player.inventory.slot[<[slot]>].material.name> == air:
            - foreach next
          - if <player.inventory.slot[<[slot]>].enchantments.contains_any[cowardice]>:
            - define cowardice_counter <[cowardice_counter].add[<player.inventory.slot[<[slot]>].enchantment_map.get[cowardice]>]>
            - foreach next
        - if <[cowardice_counter]> > 0:
          - hurt <context.entity> <[cowardice_counter].div[4]>

thundering_enchant_immunity:
  type: world
  debug: false
  events:
    on player damaged by lightning:
      - if <player.has_flag[temp.damage_immune_thunder]>:
        - determine passively cancelled

last_stand_enchant_mitigation:
  type: world
  debug: false
  events:
    on player_flagged:temp.custom_enchantment_last_stand damaged:
      - determine <context.final_damage.div[10]>

echo_enchant_handler:
  type: world
  debug: false
  events:
    after entity damaged by player with:item_enchanted:echo:
      - ratelimit <player> 12t
      - if <player.has_flag[temp.custom_enchant_echo_cooldown]>:
        - stop
      - define cooldown <element[6].sub[<player.item_in_hand.enchantment_map.get[echo]>]>
      - wait 10t
      - if <context.entity.is_spawned>:
        - animate <player> animation:ARM_SWING
        - animate <context.entity> HURT
        - flag <player> temp.custom_enchant_echo_cooldown expire:<[cooldown]>
        - define vector <context.entity.location.sub[<context.damager.location>].normalize.mul[0.25]>
        - adjust <context.entity> velocity:<[vector].with_y[0.4]>
        - define sound entity_<context.entity.entity_type>_hurt
        - playsound <context.entity.location> sound:<[sound]>
        - playsound <player.location> sound:entity_player_attack_weak
        - hurt <context.final_damage> <context.entity>

pet_damage_enchant_handler:
  type: world
  debug: false
  events:
    on wolf|cat|axolotl damages entity:
      - if !<context.damager.is_tamed||false> || !<context.damager.owner.is_spawned||false>:
        - stop
      - define owner <context.damager.owner>
      - define beastmaster_counter 0
      - foreach <list[37|38|39|40]> as:slot:
        - if <[owner].inventory.slot[<[slot]>].material.name> == air:
          - foreach next
        - if <[owner].inventory.slot[<[slot]>].enchantments.contains_any[beastmaster]>:
          - define beastmaster_counter <[beastmaster_counter].add[<[owner].inventory.slot[<[slot]>].enchantment_map.get[beastmaster]>]>
          - foreach next
      - if <[beastmaster_counter]> > 0:
        - hurt <context.entity> <[beastmaster_counter].div[3]>

non_player_death_enchant_handler:
  type: world
  debug: false
  events:
    on entity_flagged:temp.custom_enchant_prospector dies:
      - if <util.random.int[1].to[20].add[<context.entity.flag[temp.custom_enchant_prospector]>]> > 19:
        - define loot_chosen <util.random.int[1].to[100]>
        - if <[loot_chosen]> < 15:
          - define drop_item coal
          - define drop_quantity <util.random.int[1].to[3]>
        - if <[loot_chosen]> > 15 && <[loot_chosen]> <= 25:
          - define drop_item raw_copper
        - if <[loot_chosen]> > 25 && <[loot_chosen]> <= 40:
          - define drop_item glowstone_dust
          - define drop_quantity <util.random.int[1].to[3]>
        - if <[loot_chosen]> > 40 && <[loot_chosen]> <= 55:
          - define drop_item iron_nugget
          - define drop_quantity <util.random.int[1].to[7]>
        - if <[loot_chosen]> > 55 && <[loot_chosen]> <= 65:
          - define drop_item gold_nugget
          - define drop_quantity <util.random.int[1].to[7]>
        - if <[loot_chosen]> > 65 && <[loot_chosen]> <= 75:
          - define drop_item redstone
          - define drop_quantity <util.random.int[1].to[3]>
        - if <[loot_chosen]> > 75 && <[loot_chosen]> <= 85:
          - define drop_item lapis_lazuli
        - if <[loot_chosen]> > 85 && <[loot_chosen]> <= 90:
          - define drop_item diamond
        - if <[loot_chosen]> > 90 && <[loot_chosen]> <= 95:
          - define drop_item emerald
        - if <[loot_chosen]> > 95 && <[loot_chosen]> <= 100:
          - define drop emerald
        - drop <context.entity.location> <[drop_item]||coal> quantity:<[drop_quantity]||1>

on_kill_enchant_handler:
  type: world
  debug: false
  events:
    on player kills entity:
      - if <list[chicken|pig|cow|sheep|horse|bat].contains_any[<context.entity.entity_type>]>:
        - stop
      - define enchants_list <player.item_in_hand.enchantment_types.parse[name]>
      - if <[enchants_list].contains_any[guarding]>:
        - mythicskill <player> ShieldEnchant<player.item_in_hand.enchantment_map.get[guarding]>
      - if <[enchants_list].contains_any[vampirism]>:
        - heal <player> <player.item_in_hand.enchantment_map.get[vampirism]>
        - playeffect <player.location> effect:heart quantity:5f
      - if <[enchants_list].contains_any[Rampaging]> && <util.random.int[1].to[10]> > 8:
        - cast increase_damage amplifier:0 duration:<player.item_in_hand.enchantment_map.get[Rampaging].mul[5]>
      - if <[enchants_list].contains_any[exploding]> && !<player.has_flag[enchantment.temp.explosion_cd]>:
        - define level <player.item_in_hand.enchantment_map.get[exploding]>
        - define location <context.entity.location>
        - playsound <[location].above[1]> sound:ENTITY_GENERIC_EXPLODE
        - playeffect <[location].above[1]> effect:explosion_large
        - flag <player> enchantment.temp.explosion_cd expire:5s
        - foreach <[location].find_entities.within[10]> as:entity:
          - if <list[player|dropped_item|armor_stand|item_frame|arrow|trident|shulker_bullet|experience_orb].contains_any[<[entity].entity_type>]> || !<[entity].is_spawned> || <[entity].is_tamed||false>:
            - foreach next
          - playeffect effect:EXPLOSION_NORMAL <[entity].location.above[0.5]> quantity:3
          - playsound <[entity].location> sound:entity_<context.entity.entity_type>_hurt
          - hurt <[entity]> <[level].mul[2]>
          - foreach next
          - playeffect effect:EXPLOSION_NORMAL <[entity].location.above[0.5]> quantity:5
      - if <[enchants_list].contains_any[poison_cloud]>:
        - if <util.random.int[1].to[10]> > 9:
          - define entity <context.entity>
          - define level <player.item_in_hand.enchantment_map.get[poison_cloud]>
          - define effect_cuboid <[entity].location.block.sub[1,1,1].to_cuboid[<[entity].location.add[1,1,1]>]>
          - repeat 3:
            - playeffect effect:redstone at:<[effect_cuboid].blocks> quantity:10 special_data:2|0,250,0
            - playeffect effect:redstone at:<[effect_cuboid].blocks> quantity:2 special_data:3|0,125,0
            - foreach <[effect_cuboid].entities> as:entity:
              - if <list[player|dropped_item|armor_stand|item_frame|arrow|trident|shulker_bullet|experience_orb].contains_any[<[entity].entity_type>]> || <[entity].is_tamed||false>:
                - foreach next
              - hurt <[entity]> <[level]> cause:POISON
            - wait 15t

armor_enchant_passives_handler:
  type: world
  debug: false
  events:
    on entity damages player:
      - if <context.cause> == projectile:
        - define deflection_counter 0
        - foreach <list[38|39]> as:slot:
          - if <player.inventory.slot[<[slot]>].material.name> == air:
            - foreach next
          - if <player.inventory.slot[<[slot]>].enchantments.contains_any[deflection]>:
            - define deflection_counter <[deflection_counter].add[<player.inventory.slot[<[slot]>].enchantment_map.get[deflection].div[5]>]>
            - foreach next
        - if <[deflection_counter]> > 0:
          - if <util.random.int[1].to[10]> < <[deflection_counter]>:
            - determine passively cancelled

player_death_enchant_handler:
  type: world
  debug: false
  events:
    on player dies:
      - foreach <context.drops> as:item:
        - if <[item].has_flag[soulbound]>:
          - define keep:->:<[item]>
        - else if <[item].enchantment_map.keys.contains[soulbound]>:
          - define level <[item].enchantment_map.get[soulbound]>
          - if <[level]> == 1:
            - adjust def:item remove_enchantments:soulbound
            ## BUILD LORE HERE USING <[ITEM]>
            - define keep:->:<[item].proc[build_item_enchantment_lore]>
          - else:
            - define item <[item].with[enchantments=<[item].enchantment_map.with[soulbound].as[<[level].sub[1]>]>]>
            ## BUILD LORE HERE USING <[ITEM]>
            - define keep:->:<[item].proc[build_item_enchantment_lore]>
        - else:
          - define drops:->:<[item]>
      - flag player temp.soulbound_enchant:|:<[keep]>
      - determine <[drops]||air>

spawn_enchant_handler:
  type: world
  debug: false
  events:
    after player respawns flagged:temp.soulbound_enchant:
      #- if <player.has_flag[temp.soulbound_enchant]>:
        #- define item_lore <list[]>
        #- foreach <player.flag[temp.soulbound_enchant]> as:item:
          #- foreach <[item].enchantments> as:enchant:
            #- define enchantment_name <[enchant].to_titlecase>
            #- define enchantment_level <[item].enchantment_map.get[<[enchant]>].proc[arabic_to_roman]>
            #- define item_lore <[item_lore].include[<&7><[enchantment_name].replace[_].with[<&sp>].to_titlecase><&sp><[enchantment_level]>]>
          #- give <[item].with[lore=<[item_lore]>]>
      - give <player.flag[temp.soulbound_enchant]>
      - flag <player> temp.soulbound_enchant:!

enchanted_book_opener:
  type: world
  debug: false
  events:
    on player right clicks block with:enchanted_book:
      - if <server.flag[custom_enchant_data.valid_enchants].contains_any[<context.item.enchantments>]>:
        - define book_pages <list[]>
        - foreach <context.item.enchantments> as:enchant:
          - if <server.flag[custom_enchant_data.valid_enchants].contains[<[enchant]>]>:
            - define slot_number <server.flag[custom_enchant_data.valid_enchants].alphabetical.find[<[enchant]>]>
            - define book_pages <[book_pages].include[<server.flag[enchantment_book_pages].get[<[slot_number]>]>]>
        - adjust <player> show_book:enchantment_explainer_book_item[book_pages=<[book_pages]>]

Shield_enchant_handler:
  type: world
  debug: false
  events:
    on player damaged by entity:
      - ratelimit <player> 2t
      - if <player.item_in_hand.material.name> == shield:
        - define enchants_list <player.item_in_hand.enchantment_types.parse[name]>
      - if <player.item_in_offhand.material.name> == shield:
        - define enchants_list <player.item_in_offhand.enchantment_types.parse[name]>
      - if <[enchants_list]||null> == null:
        - stop
      - if <[enchants_list].contains_any[spikes]>:
        - if !<player.has_flag[temp.spikes.cd]>:
          - flag <player> temp.spikes.cd expire:40t
          - hurt <context.damager> <player.item_in_hand.enchantment_map.get[Spikes]>
      - if <[enchants_list].contains_any[flamebrand]>:
        - if !<player.has_flag[temp.flamebrand.cd]>:
          - flag <player> temp.flamebrand.cd expire:40t
          - burn <context.damager> duration:<player.item_in_hand.enchantment_map.get[flamebrand]>s
      - if <[enchants_list].contains_any[rebuking]>:
        - if !<player.has_flag[temp.rebuking.cd]>:
          - flag <player> temp.rebuking.cd expire:40t
          - if <player.flag[temp.rebuking.stacks]> < 3:
            - flag <player> temp.rebuking.stacks:++

