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
        - inventory open d:disposal_inventory
        - playsound <player> sound:BLOCK_WOODEN_DOOR_OPEN volume:1.0 pitch:2.0
        - flag player TrashCanLocation:<context.location.center>

#The disposal command (Commented out permission option for the time being)
disposal_command:
  type: command
  name: disposal
  permission: custom.command.dispose
  usage: /disposal
  description: Opens the disposal inventory
  permission message: <&c>Sorry, <&6><player.name><&c>, you can't use <&d><&l>/disposal<&r><&c> because you don't have permission!
  script:
    - inventory open d:disposal_inventory
#The disposal inventory
disposal_inventory:
  type: inventory
  inventory: chest
  title: <&6>◆ <&n><&l>Incinerator<&r> <&6>◆
  size: 45
  definitions:
    filler: <item[white_stained_glass_pane].with[display_name=<&e>;nbt=action/filler]>
    trashconfirm: <item[lime_stained_glass_pane].with[display_name=<&a>Confirm?;nbt=action/trashconfirm]>
  slots:
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[] [] [] [] [] [] [] [] []"
  - "[trashinfo] [filler] [filler] [filler] [filler] [filler] [filler] [filler] [trashconfirm]"

# Items
trashinfo:
  type: item
  material: player_head
  display name: <&6>Help
  mechanisms:
    nbt: action/trashinfo
    skull_skin: d545a15d-96f6-4602-afb2-6cb0f0375ea6|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOGVlZjc4ZWRkNDdhNzI1ZmJmOGMyN2JiNmE3N2Q3ZTE1ZThlYmFjZDY1Yzc3ODgxZWM5ZWJmNzY4NmY3YzgifX19=
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
      - choose <context.item.nbt[action]||null>:
        - case trashconfirm:
          - playsound <player> sound:UI_BUTTON_CLICK
          - determine passively cancelled
          - inventory close
        - case filler:
          - determine cancelled
        - case trashinfo:
          - determine cancelled
        - case default:
          - stop
    on player closes disposal_inventory:
      - if <context.inventory.stacks> == 9:
        - playeffect smoke <player.flag[TrashCanLocation].as_location> targets:<player> quantity:20
        - flag player TrashCanLocation:!
      - else:
        - playsound <player> sound:ENTITY_BLAZE_SHOOT volume:1.0 pitch:0.5
        - narrate "<&6>Items Destroyed!"
        - playeffect lava <player.flag[TrashCanLocation].as_location> targets:<player> quantity:10
        - title "subtitle:<&c>Items Destroyed" fade_in:2s stay:1s fade_out:1s targets:<player>
        - flag player TrashCanLocation:!
        - wait 1t
        - inventory update
