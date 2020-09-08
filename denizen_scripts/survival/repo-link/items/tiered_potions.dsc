# -- Tiered Potions data script
tiered_potions_data:
  type: data
  tiered_potion_2:
    item: brown_mushroom
    uses: 3
    heals: 10
  tiered_potion_3:
    item: glowstone_dust
    uses: 5
    heals: 15
  tiered_potion_4:
    item: fire_charge
    uses: 8
    heals: 20
  tiered_potion_5:
    item: redstone_block
    uses: 12
    heals: 25
  tiered_potion_6:
    item: ancient_debris
    uses: 18
    heals: 30
  tiered_potion_7:
    item: nether_star
    uses: 25
    heals: 45
  tiered_potion_8:
    item: diamond_block
    uses: 35
    heals: 70
  tiered_potion_9:
    item: netherite_ingot
    uses: 40
    heals: 90
  tiered_potion_10:
    item: glistering_melon_slice
    uses: 50
    heals: 512

# -- Tiered Potions world events
tiered_potions_events:
  type: world
  debug: false
  events:
    # -- When the player crafts a tiered potion, the items don't have any NBT data.
    # -- This is because `<item[grass_block]> != <item[grass_block].with[nbt=<list[has/nbt]>]>`.
    # -- We fallback to `1` when adding one to the defined item's NBT.
    on player consumes tiered_potion_*:
      # Heal and add one to the usage counter.
      - determine passively cancelled
      - define item <context.item>
      - heal <script[tiered_potions_data].data_key[<context.item.script.name>.heals].mul[2]>
      - adjust <[item]> nbt:<list[uses/<[item].nbt[uses].add[1]||1>]>
      - if <[item].nbt[uses]> >= <script[tiered_potions_data].data_key[<context.item.script.name>.uses]>:
        # -- If `- determine <[item]>` doesn't work, try `- determine <context.item>` or `- determine cancelled:false`.
        - playsound <player> sound:ENTITY_ITEM_BREAK
        - determine <[item]>
      # Wait one tick, then update the potion's NBT.
      - wait 1t
      - inventory adjust slot:<player.held_item_slot> nbt:<list[uses/<[item].nbt[uses]>]>


# -- Tiered Potions
# - 2
tiered_potion_2:
  type: item
  debug: false
  material: potion
  display name: <&f>Potion of Healing
  lore:
    - <&9>Instant Health
    - <&r>
    - <&e>Tier II
  enchantments:
    - infinity:1
  mechanisms:
    color: <color[255,0,128]>
    hides: ALL
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - <item[potion].with[potion_effects=<list[INSTANT_HEAL,false,false]>]>|<script[tiered_potions_data].data_key[<script.name>.item]>|<item[potion].with[potion_effects=<list[INSTANT_HEAL,false,false]>]>
    2:
      type: shaped
      output_quantity: 1
      input:
      - <item[potion].with[potion_effects=<list[INSTANT_HEAL,true,false]>]>|<script[tiered_potions_data].data_key[<script.name>.item]>|<item[potion].with[potion_effects=<list[INSTANT_HEAL,true,false]>]>

# - 3
tiered_potion_3:
  type: item
  debug: false
  material: potion
  display name: <&f>Potion of Healing
  lore:
    - <&9>Instant Health
    - <&r>
    - <&e>Tier III
  enchantments:
    - infinity:1
  mechanisms:
    color: <color[255,0,120]>
    hides: ALL
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - tiered_potion_<script.name.after_last[_].sub[1]>|<script[tiered_potions_data].data_key[<script.name>.item]>|tiered_potion_<script.name.after_last[_].sub[1]>

# - 4
tiered_potion_4:
  type: item
  debug: false
  material: potion
  display name: <&f>Potion of Healing
  lore:
    - <&9>Instant Health
    - <&r>
    - <&e>Tier IV
  enchantments:
    - infinity:1
  mechanisms:
    color: <color[255,0,112]>
    hides: ALL
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - tiered_potion_<script.name.after_last[_].sub[1]>|<script[tiered_potions_data].data_key[<script.name>.item]>|tiered_potion_<script.name.after_last[_].sub[1]>

# - 5
tiered_potion_5:
  type: item
  debug: false
  material: potion
  display name: <&f>Potion of Healing
  lore:
    - <&9>Instant Health
    - <&r>
    - <&e>Tier V
  enchantments:
    - infinity:1
  mechanisms:
    color: <color[255,0,104]>
    hides: ALL
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - tiered_potion_<script.name.after_last[_].sub[1]>|<script[tiered_potions_data].data_key[<script.name>.item]>|tiered_potion_<script.name.after_last[_].sub[1]>

# - 6
tiered_potion_6:
  type: item
  debug: false
  material: potion
  display name: <&f>Potion of Healing
  lore:
    - <&9>Instant Health
    - <&r>
    - <&e>Tier VI
  enchantments:
    - infinity:1
  mechanisms:
    color: <color[255,0,96]>
    hides: ALL
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - tiered_potion_<script.name.after_last[_].sub[1]>|<script[tiered_potions_data].data_key[<script.name>.item]>|tiered_potion_<script.name.after_last[_].sub[1]>

# - 7
tiered_potion_7:
  type: item
  debug: false
  material: potion
  display name: <&f>Potion of Healing
  lore:
    - <&9>Instant Health
    - <&r>
    - <&e>Tier VII
  enchantments:
    - infinity:1
  mechanisms:
    color: <color[255,0,80]>
    hides: ALL
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - tiered_potion_<script.name.after_last[_].sub[1]>|<script[tiered_potions_data].data_key[<script.name>.item]>|tiered_potion_<script.name.after_last[_].sub[1]>

# - 8
tiered_potion_8:
  type: item
  debug: false
  material: potion
  display name: <&f>Potion of Healing
  lore:
    - <&9>Instant Health
    - <&r>
    - <&e>Tier VIII
  enchantments:
    - infinity:1
  mechanisms:
    color: <color[255,0,64]>
    hides: ALL
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - tiered_potion_<script.name.after_last[_].sub[1]>|<script[tiered_potions_data].data_key[<script.name>.item]>|tiered_potion_<script.name.after_last[_].sub[1]>

# - 9
tiered_potion_9:
  type: item
  debug: false
  material: potion
  display name: <&f>Potion of Healing
  lore:
    - <&9>Instant Health
    - <&r>
    - <&e>Tier IX
  enchantments:
    - infinity:1
  mechanisms:
    color: <color[255,0,48]>
    hides: ALL
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - tiered_potion_<script.name.after_last[_].sub[1]>|<script[tiered_potions_data].data_key[<script.name>.item]>|tiered_potion_<script.name.after_last[_].sub[1]>

# - 10
tiered_potion_10:
  type: item
  debug: false
  material: potion
  display name: <&f>Potion of Healing
  lore:
    - <&9>Instant Health
    - <&r>
    - <&e>Tier X
  enchantments:
    - infinity:1
  mechanisms:
    color: <color[255,0,32]>
    hides: ALL
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
      - tiered_potion_<script.name.after_last[_].sub[1]>|<script[tiered_potions_data].data_key[<script.name>.item]>|tiered_potion_<script.name.after_last[_].sub[1]>
