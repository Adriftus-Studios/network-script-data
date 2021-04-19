Backpack_9:
  type: item
  material: player_head
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>9
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/9|backpack_contents/<list>|unique/<server.current_time_millis>
    skull_skin: b9eac001-a6a5-cf7d-7d87-a1904f88b4ef|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWZiNmEzZDdkYmE5N2JiNmU3Zjc5YTE1NjI3YWVjNjM2OTc5MTIzM2Y4MzNmYTc0OWVmMjFiZWQ3OWU1OWU5OCJ9fX0=

Backpack_18:
  type: item
  material: player_head
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>18
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/18|backpack_contents/<list>|unique/<server.current_time_millis>
    skull_skin: 67f93558-defe-3842-7c5e-dfc2a2e95184|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZGY3MGZhYjMyNDZmZTAyN2NlMGJiYTg4NWE3M2M2ZTgyZDhmZjhmMzU4MjMxZTg0NjFmOTU2NTYwY2ZhNThmIn19fQ==

Backpack_27:
  type: item
  material: player_head
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>27
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/27|backpack_contents/<list>|unique/<server.current_time_millis>
    skull_skin: 80bf8295-f158-d4ac-19bd-561923bbe9b8|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTk5MDlhOTc3OWI5NDZiOTc4NzQ0MmZhNDgzYWY0ZGU0YjJmMTlmZDQwZGMyMzcwZjdhOWI4ZjUyMWYyMWRkYyJ9fX0=

Backpack_36:
  type: item
  material: player_head
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>36
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/36|backpack_contents/<list>|unique/<server.current_time_millis>
    skull_skin: c161c548-3dee-f25c-04b4-8eae38d5c861|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTI1NGFhY2JmNjIzMTc1ZmY5OGRmN2FlMzY2ZTBiODllOTE3MTM0NDE3NTJmM2NkZjk2NWYwMzhiMTc0YjUifX19

Backpack_45:
  type: item
  material: player_head
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>45
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/18|backpack_contents/<list>|unique/<server.current_time_millis>
    skull_skin: f577e5c9-bd41-c61d-35f7-39f5881e8c0d|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYmRkYWZkY2IxYThkZjQyNjIyOWQ3ODc5YjFlNGEzMzZmYzlhYjNiZGMxNDZiYjRlZDNiZTRiYmY3YjViODM1In19fQ==

Backpack_54:
  type: item
  material: player_head
  display name: <&a>Backpack
  lore:
    - <&e>Slots<&co> <&a>54
    - <&a>
    - <&e>Hold in Hand
    - <&b>Place block to open
  mechanisms:
    nbt: backpack_slots/54|backpack_contents/<list>|unique/<server.current_time_millis>
    skull_skin: 5b699579-5444-a846-b7f9-dc0693b09586|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZWJkZjhkNTNiZGI5MzJjMjIzYzYyN2JiYjhjMWUwYzVlMzUxYTYxNmNkODA1NjkyOWM2NmU2ZGNlNDQ0MzNkYiJ9fX0=

Backpack_events:
  type: world
  debug: false
  events:
    on player right clicks block with:Backpack_* ignorecancelled:true:
      - determine passively cancelled
      - wait 1t
      - if <player.item_in_hand.has_script> && <player.item_in_hand.scriptname.starts_with[Backpack_]>:
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
      - if <context.click> == NUMBER_KEY:
        - if <player.inventory.slot[<context.hotbar_button>].scriptname.starts_with[Backpack_]||false>:
          - determine cancelled
    on player drops backpack_*:
    - determine cancelled
    on player prepares anvil craft backpack_*:
    - determine air

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
  debug: false
  script:
    - if <player.item_in_hand.scriptname.starts_with[Backpack]||false>:
      - define slot <player.held_item_slot>
    - else:
      - define slot 41
    - inventory adjust slot:<[slot]> nbt:backpack_contents/<context.inventory.list_contents.escaped>

Backpack_open:
  type: task
  debug: false
  script:
    - if <player.item_in_hand.scriptname.starts_with[Backpack]||false>:
      - define item <player.item_in_hand>
    - else:
      - define item <player.item_in_offhand>
    - define inventory <inventory[Backpack_inventory_<[item].nbt[backpack_slots]>]>
    - if !<[item].nbt[backpack_contents].as_list.is_empty||true>:
      - inventory set o:<[item].nbt[backpack_contents]> d:<[inventory]>
    - inventory open d:<[inventory]>
