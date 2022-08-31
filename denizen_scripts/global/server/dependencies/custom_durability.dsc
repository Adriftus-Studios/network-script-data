custom_durability_process_task:
  type: task
  debug: false
  definitions: slot|value
  script:
      - define slot <player.held_item_slot> if:<[slot].exists.not>
      - define value 1 if:<[value].exists.not>
      - if !<player.inventory.slot[<[slot]>].has_flag[custom_durability.max]>:
        - stop
      - if <player.inventory.slot[<[slot]>].flag[custom_durability.current].add[<[value]>]> < <player.inventory.slot[<[slot]>].flag[custom_durability.max]>:
        - inventory flag slot:<[slot]> custom_durability.current:<player.inventory.slot[<[slot]>].flag[custom_durability.current].add[<[value]>]>
        - if <player.inventory.slot[<[slot]>].material.max_durability> >= 0:
          - define percent <player.inventory.slot[<[slot]>].flag[custom_durability.current].div[<player.inventory.slot[<[slot]>].flag[custom_durability.max]>]>
          - define current_dur <player.inventory.slot[<[slot]>].material.max_durability.mul[<[percent]>]>
          - inventory adjust slot:<[slot]> durability:<[current_dur].round_up>
        - define durability_lore "Durability<&co> <player.inventory.slot[<[slot]>].flag[custom_durability.max].sub[<player.inventory.slot[<[slot]>].flag[custom_durability.current]>]>/<player.inventory.slot[<[slot]>].flag[custom_durability.max]>"
        - if <player.inventory.slot[<[slot]>].is_enchanted>:
          - inventory adjust slot:<[slot]> hides:ENCHANTS
          - if <player.inventory.slot[<[slot]>].material.name> == enchanted_book:
            - inventory adjust slot:<[slot]> hides:ITEM_DATA
          - define map <player.inventory.slot[<[slot]>].enchantment_map>
          - define enchant_lore:|:<player.inventory.slot[<[slot]>].enchantment_types.parse_tag[<[parse_value].full_name[<[map].get[<[parse_value].name>]>].replace_text[<&r>].with[]>]>
          - define enchant_lore <[enchant_lore]>
        - define item_lore <player.inventory.slot[<[slot]>].script.parsed_key[lore].if_null[<list[]>]>
        - define final_lore <[item_lore].include[<[enchant_lore].if_null[]>].include[<&f><[durability_lore]>].separated_by[<&nl>]>
        - inventory adjust slot:<[slot]> lore:<[final_lore]>
      - else:
        - take slot:<[slot]>
        - playsound sound:item_shield_break <player>

custom_durability_repair:
  type: world
  debug: false
  events:
    on item recipe formed:
      - if <context.recipe_id> == minecraft<&co>repair_item:
        - define script_items <context.recipe.filter[script.exists]>
        - stop if:<[script_items].size.equals[0]>
        - determine cancelled if:<[script_items].size.equals[<context.recipe.exclude[<item[air]>].size>].not>
        - determine cancelled if:<[script_items].parse[script.name].deduplicate.size.equals[1].not>
        - define first <[script_items].first>
        - define valid <[script_items].filter[script.name.equals[<[first].script.name>].not].exclude[true].size>
        - if <[valid]> > 0:
          - determine cancelled
        - define max_durability <[first].flag[custom_durability.max]>
        - define current_durability <[script_items].parse_tag[<[max_durability].sub[<[parse_value].flag[custom_durability.current]>]>].sum.min[<[max_durability]>]>
        - determine <[first].script.name.as_item.with[flag=custom_durability.current:<[current_durability]>;durability=<[current_durability].div[<[max_durability]>].mul[<[first].material.max_durability>].round_up>]>

custom_durability_handler:
  type: world
  debug: true
  events:
    on player item_flagged:custom_durability.max takes damage:
      - define slot <context.slot>
      - define custom_durability <context.item.flag[custom_durability.current].if_null[0].add[<context.damage>]>
      - define custom_percentage <[custom_durability].div[<context.item.flag[custom_durability.max]>]>
      - define vanilla_percentage <context.item.durability.add[1].div[<context.item.max_durability>]>
      - define lore <context.item.lore.if_null[<list>]>
      - define placement <[lore].find_match[<&7>Durability*]>
      - if <[placement]> != -1:
        - define new_lore "<[lore].overwrite[<&7>Durability<&co> <context.item.flag[custom_durability.max].sub[<[custom_durability]>]>/<context.item.flag[custom_durability.max]>].at[<[placement]>]>"
      - else:
        - define new_lore "<[lore].include[<&7>Durability<&co> <context.item.flag[custom_durability.max].sub[<[custom_durability]>]>/<context.item.flag[custom_durability.max]>]>"
      - if <[custom_percentage]> >= 1:
        - determine 1000
      - else if <[custom_percentage]> < <[vanilla_percentage]>:
        - determine passively cancelled
      - else:
        - inventory adjust slot:<[slot]> durability:<[custom_percentage].mul[<context.item.material.max_durability>].round_down>
      - inventory adjust slot:<[slot]> lore:<[new_lore]>
      - inventory flag slot:<[slot]> custom_durability.current:+:<context.damage>