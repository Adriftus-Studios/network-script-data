dwarf_shop_events:
  type: world
  debug: false
  data:
    shop:
      rotating:
        # Item scripts or materials that should be sold
        items:
          diamond:
            quantity: 5
            price:
              rock_spore_item: 64
        # Slots that rotating items should be in
        slots:
        - 38
        - 39
        - 40
        - 41
        - 42
        - 43
        - 44
      constant:
      # Slot
        11:
          # Item being sold
          item: diamond
          # How many rock spirits
          price:
            rock_spore_item: 10
  reload:
  - note remove as:dwarf_shop
  - note <inventory[dwarf_shop_inventory]> as:dwarf_shop
  - define inv <inventory[dwarf_shop]>
  - foreach <script.data_key[data.shop.constant].keys> as:slot:
    - define item <script.data_key[data.shop.constant.<[slot]>.item].as_item||null>
    - define quantity <script.data_key[data.shop.constant.<[slot]>.quantity].if_null[1]>
    - define item <[item].with_flag[dwarf_shop_item.item:<[item]>].with_flag[dwarf_shop_item.quantity:<[quantity]>].with[quantity=<[quantity]>]>
    - foreach next if:<[item].equals[null]>
    - define lore <[item].lore||<list>>
    - define "lore:|:<n><&e>Price:"
    - foreach <script.data_key[data.shop.constant.<[slot]>.price].keys> as:price_item:
      - define price_quantity <script.data_key[data.shop.constant.<[slot]>.price.<[price_item]>]>
      - define item <[item].with_flag[price.<[price_item]>:<[price_quantity]>]>
      - define price_item <[price_item].as_item>
      - define "lore:|:<&7> - <[price_quantity]> <[price_item].display||<[price_item].material.name>>"
    - define item <[item].with[lore=<[lore]>]>
    - inventory set d:<[inv]> slot:<[slot]> o:<[item]>
  - foreach <script.data_key[data.shop.rotating.slots]> as:slot:
    - define items <script.data_key[data.shop.rotating.items].keys.filter[as_item.is_truthy]>
    - define slots <script.data_key[data.shop.rotating.slots]>
    - define items <[items].random[<[slots].size>]>
    - define i 0
    - foreach <[items]> as:item:
      - define i <[i].add[1]>
      - define slot <[slots].get[<[i]>]>
      - define quantity <script.data_key[data.shop.rotating.items.<[item]>.quantity].if_null[1]>
      - define item_name <[item]>
      - define item <[item].as_item.with[quantity=<[quantity]>]>
      - define price <script.data_key[data.shop.rotating.items.<[item_name]>.price]>
      - define lore <[item].lore||<list>>
      - define "lore:|:<n><&e>Price:"
      - foreach <[price].keys> as:price_item:
        - define price_quantity <script.data_key[data.shop.rotating.items.<[item_name]>.price.<[price_item]>]>
        - define item <[item].with_flag[price.<[price_item]>:<[price_quantity]>]>
        - define price_item <[price_item].as_item>
        - define "lore:|:<&7> - <[price_quantity]> <[price_item].display||<[price_item].material.name>>"
      - inventory set d:<[inv]> slot:<[slot]> o:<[item].with_flag[dwarf_shop_item.item:<[item].as_item>].with_flag[dwarf_shop_item.quantity:<[quantity]>].with[lore=<[lore]>]>
  # - narrate targets:<server.online_players.filter[has_permission[admin]]> "<&e>Dwarf shop inventory <&6>Compiled"
  # - narrate targets:<server.online_players> "Dwarf shop something something restocked something. ##TODO"
  events:
    on player right clicks cow server_flagged:dwarf_active:
    - stop if:<context.entity.mythicmob.internal_name.equals[DwarfSmith].not.if_null[true]>
    - inventory open d:<inventory[dwarf_shop]>
    on player clicks in dwarf_shop_inventory:
    - stop if:<context.item.has_flag[dwarf_shop_item].not>
    - define missing <map>
    - foreach <context.item.flag[price].keys> as:price_item:
      - define price_quantity <context.item.flag[price.<[price_item]>]>
      - define missing <[missing].with[<[price_item]>].as[<[price_quantity]>]> if:<player.inventory.quantity_item[<[price_item]>].is_less_than[<[price_quantity]>]>
    - if <[missing].is_empty.not>:
      - narrate "You are missing items."
      - stop
    - foreach <context.item.flag[price].keys> as:price_item:
      - define price_quantity <context.item.flag[price.<[price_item]>]>
      - take from:<player.inventory> item:<[price_item]> quantity:<[price_quantity]>
    - give to:<player.inventory> <context.item.flag[dwarf_shop_item.item].as_item> quantity:<context.item.flag[dwarf_shop_item.quantity]>
    on script reload:
    - inject <script[dwarf_shop_events].name> path:reload
    on delta time hourly every:2:
    - inject <script[dwarf_shop_events].name> path:reload

dwarf_talk_events:
  type: world
  debug: false
  data:
    lines_to_say:
    - <&e>Home... Oh how I long for the embers of the elders, the halls of Vughalduhr, the scent of burning laurelin logs...
    - <&e>Rock spores are the money of the dwarves, now that you have met me, you might find some...
    - <&e>There once was a dwarf named Balram, In his home city he came across an Orc, He jumped off of a bridge and landed with a slam, Before impaling the orc on his pitchfork!
    - <&e>... And there I was, the beady eye dragon staring into me soul, gold in hand, I turned and ran...
    - <&e>Have you ever heard the tale of the bard who drank with a dwarf?
    - <&e>Home... Oh how I long for the embers of the elders, the halls of Vughalduhr, the scent of burning laurelin logs...
    - <&e>Rock spores are the money of the dwarves, now that you have met me, you might find some...
    - <&e>There once was a dwarf named Balram, In his home city he came across an Orc, He jumped off of a bridge and landed with a slam, Before impaling the orc on his pitchfork!
    - <&e>... And there I was, the beady eye dragon staring into me soul, gold in hand, I turned and ran...
    - <&e>Have you ever heard the tale of the bard who drank with a dwarf?
  events:
    on delta time minutely every:1:
    - foreach <mythicmobs.active_mobs.filter[internal_name.equals[DwarfSmith]]> as:d:
      - define players <[d].entity.location.find_players_within[5]>
      - define line <script.data_key[data.lines_to_say].random.parsed>
      - chat <[line]> targets:<[players]> talkers:<[d].entity> range:5

dwarf_shop_inventory:
  type: inventory
  inventory: chest
  size: 54
  gui: true
  slots:
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []
  - [] [] [] [] [] [] [] [] []

rock_spore_item:
  type: item
  material: feather
  display name: <&e>Rock Spore
  mechanisms:
    custom_model_data: 21

rock_spirit_events:
  type: world
  debug: false
  data:
    drop_chances:
    # Material
    # Chance is a percentage
      stone: 3

  events:
    on player breaks block server_flagged:rock_spores_activated:
    - stop if:<list[survival|adventure].contains[<player.gamemode>].not>
    - define material <context.material.name>
    - stop if:<script.data_key[data.drop_chances.<[material]>].exists.not>
    - define chance <script.data_key[data.drop_chances.<[material]>]>
    - if <util.random_chance[<[chance]>]>:
      - determine <context.location.drops[<player.item_in_hand>].include[<item[rock_spore_item]>]>
