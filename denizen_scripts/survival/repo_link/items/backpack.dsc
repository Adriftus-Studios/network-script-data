Backpack_9:
  type: item
  material: chest
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>9
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/9|backpack_contents/<list>|unique/<server.current_time_millis>
    
Backpack_18:
  type: item
  material: chest
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>18
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/18|backpack_contents/<list>|unique/<server.current_time_millis>
    
Backpack_27:
  type: item
  material: chest
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>27
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/27|backpack_contents/<list>|unique/<server.current_time_millis>
    
Backpack_36:
  type: item
  material: chest
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>36
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/36|backpack_contents/<list>|unique/<server.current_time_millis>
    
Backpack_45:
  type: item
  material: chest
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>45
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/18|backpack_contents/<list>|unique/<server.current_time_millis>
    
Backpack_54:
  type: item
  material: chest
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>54
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/54|backpack_contents/<list>|unique/<server.current_time_millis>

Backpack_events:
  type: world
  events:
    on player right clicks block with:Backpack_* ignorecancelled:true:
      - determine passively cancelled
      - wait 1t
      - if <player.item_in_hand.scriptname.starts_with[Backpack_]>:
        - inject Backpack_open
    on player places backpack_*:
      - determine passively cancelled
      - wait 1t
      - inject Backpack_open
    on player closes Backpack_inventory_*:
      - inject Backpack_save
    on player clicks Backpack_* in Backpack_inventory_*:
      - determine cancelled
    on player clicks in Backpack_inventory_*:
      - if <context.item.scriptname.starts_with[Backpack_]||false>:
        - determine cancelled

Backpack_inventory_9:
  type: inventory
  inventory: chest
  size: 9
  title: <&a>Backpack

Backpack_inventory_18:
  type: inventory
  inventory: chest
  size: 18
  title: <&a>Backpack

Backpack_inventory_27:
  type: inventory
  inventory: chest
  size: 27
  title: <&a>Backpack

Backpack_inventory_36:
  type: inventory
  inventory: chest
  size: 36
  title: <&a>Backpack

Backpack_inventory_45:
  type: inventory
  inventory: chest
  size: 45
  title: <&a>Backpack

Backpack_inventory_54:
  type: inventory
  inventory: chest
  size: 54
  title: <&a>Backpack

Backpack_save:
  type: task
  script:
    - if <player.item_in_hand.scriptname.starts_with[Backpack]||false>:
      - define slot <player.held_item_slot>
    - else:
      - define slot 41
    - inventory adjust slot:<[slot]> nbt:backpack_contents/<context.inventory.list_contents.escaped>

Backpack_open:
  type: task
  script:
    - if <player.item_in_hand.scriptname.starts_with[Backpack]||false>:
      - define item <player.item_in_hand>
    - else:
      - define item <player.item_in_offhand>
    - define inventory <inventory[Backpack_inventory_<[item].nbt[backpack_slots]>]>
    - if !<[item].nbt[backpack_contents].as_list.is_empty||true>:
      - inventory set o:<[item].nbt[backpack_contents]> d:<[inventory]>
    - inventory open d:<[inventory]>
