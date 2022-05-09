build_item_enchantment_lore:
  type: procedure
  debug: true
  definitions: item
  script:
    ## Build Enchantments
    - if <[item].is_enchanted>:
      - adjust def:item hides:ENCHANTS
      - if <[item].material.name> == enchanted_book:
        - adjust def:item hides:ITEM_DATA
      - define map <[item].enchantment_map>
      - define enchant_lore:|:<[item].enchantment_types.parse_tag[<[parse_value].full_name[<[map].get[<[parse_value].name>]>].replace_text[<&r>].with[]>]>
      - if <[item].script.is_truthy>:
        - adjust def:item lore:<[item].script.parsed_key[lore].if_null[<list[]>].include[<[enchant_lore].insert[<&7>].at[1]>]>
      - else:
        - adjust def:item lore:<[enchant_lore]>
    - determine <[item]>
