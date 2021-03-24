#Listens for when players right click on a cauldron
disposal_inventory_listener:
  type: world
  debug: false
  blacklist: water_bucket|glass_bottle|potion
  events:
    on player right clicks cauldron:
      - if <queue.script.data_key[blacklist].contains[<player.item_in_hand.material.name>]>:
        - stop
      - else if <context.location.material.level> == 0:
        - determine passively cancelled
        - inventory open d:disposal_inventory
        - playsound <player> sound:BLOCK_WOODEN_DOOR_OPEN volume:1.0 pitch:2.0
        - flag player TrashCanLocation:<context.location.center>

#The disposal command (Commented out permission option for the time being)
disposal_command:
  type: command
  name: disposal
  debug: false
  permission: adriftus.staff
  usage: /disposal
  description: Opens the disposal inventory
  permission message: <&c>Sorry, <&6><player.name><&c>, you can't use <&d><&l>/disposal<&r><&c> because you don't have permission!
  script:
    - inventory open d:disposal_inventory
#The disposal inventory
disposal_inventory:
  type: inventory
  inventory: chest
  debug: false
  title: <&6>◆ <&n><&l>Incinerator<&r> <&6>◆
  size: 45
  definitions:
    trashconfirm: <item[lime_stained_glass_pane].with[display_name=<&a>Confirm?;flag=action:trashconfirm]>
  slots:
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[trashinfo] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [standard_filler] [trashconfirm]"

# Items
trashinfo:
  type: item
  material: player_head
  debug: false
  display name: <&6>Help
  mechanisms:
    skull_skin: d545a15d-96f6-4602-afb2-6cb0f0375ea6|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOGVlZjc4ZWRkNDdhNzI1ZmJmOGMyN2JiNmE3N2Q3ZTE1ZThlYmFjZDY1Yzc3ODgxZWM5ZWJmNzY4NmY3YzgifX19=
  flags:
    action: trashinfo
  lore:
  - <&6><&n>______________________________
  - <&d>Items placed here are destroyed forever!
  - <&d>
  - <&d>Once you have placed your items in the
  - <&c>Trash Destroyer<&d>, press the <&a>green<&d> button.
  - <&d>
  - <&d>If you leave the inventory for any reason
  - <&d>without removing your items, they will
  - <&d>be destroyed nonetheless.

#Disposal Inventory Confirm Message, and steal prevention
disposal_inventory_handler:
  type: world
  debug: false
  events:
    on player clicks item in disposal_inventory:
      - choose <context.item.flag[action]||null>:
        - case trashconfirm:
          - playsound <player> sound:UI_BUTTON_CLICK volume:0.6 pitch:1.4
          - determine passively cancelled
          - inventory close
        - case filler:
          - determine passively cancelled
        - case trashinfo:
          - determine passively cancelled
        - case default:
          - stop
    on player closes disposal_inventory:
      - if <context.inventory.stacks> > 9:
        - playeffect smoke <player.flag[TrashCanLocation].as_location> targets:<player> quantity:20
        - playsound <player> sound:BLOCK_CAMPFIRE_CRACKLE volume:1.0 pitch:0.5
        - playsound <player> sound:BLOCK_FIRE_AMBIENT volume:1.0 pitch:0.5
        - inventory update
      - if <context.inventory.stacks> > 19:
        - playsound <player> sound:ENTITY_BLAZE_SHOOT volume:1.0 pitch:0.5
        - actionbar "<&c>Items Destroyed!"
        - playeffect lava <player.flag[TrashCanLocation].as_location> targets:<player> quantity:10
        - wait 1t
        - inventory update
      - else:
        - stop
      - flag player TrashCanLocation:!
