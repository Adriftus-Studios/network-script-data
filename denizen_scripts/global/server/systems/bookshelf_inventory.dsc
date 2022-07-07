bookshelf_inventory:
  type: inventory
  debug: false
  inventory: chest
  size: 36
  title: <&f><&font[adriftus:guis]><&chr[F808]><&chr[6928]>
  gui: true
  data:
    on_close: bookshelf_inventory_save
    click_script_slots:
      12: bookshelf_transform
      13: bookshelf_transform
      14: bookshelf_transform
      15: bookshelf_transform
      16: bookshelf_transform
      30: bookshelf_transform
      31: bookshelf_transform
      32: bookshelf_transform
      33: bookshelf_transform
      34: bookshelf_transform

bookshelf_display:
  type: item
  material: feather
  display name: <&a>
  flags:
    run_script: cancel
  mechanisms:
    custom_model_data: 3

bookshelf_inventory_open:
  type: task
  debug: false
  script:
    - stop if:<player.item_in_hand.material.name.equals[air].not>
    - define inventory <inventory[bookshelf_inventory]>
    - if <context.location.has_flag[bookshelf_inventory]>:
      - inventory set o:<context.location.flag[bookshelf_inventory]> d:<[inventory]>
    - inventory set slot:5 o:<item[bookshelf_display].with[flag=location:<context.location>]> d:<[inventory]>
    - inventory open d:<[inventory]>

bookshelf_transform:
  type: task
  debug: false
  data:
    acceptable_materials:
      enchanted_book: true
      air: true
  script:
    - stop if:<script.data_key[data.acceptable_materials.<context.cursor_item.material.name>].exists.not>
    - if <context.item.material.name> != air:
      - determine passively <context.item.with[custom_model_data=2]>
    - if <context.cursor_item.material.name> != air:
      - adjust <player> item_on_cursor:<context.cursor_item.with[custom_model_data=1]>
    - determine cancelled:false

bookshelf_inventory_no_piston:
  type: world
  debug: false
  events:
    after server start:
      - adjust <material[bookshelf]> piston_reaction:block

bookshelf_inventory_on_place:
  type: task
  debug: false
  script:
    - flag <context.location> on_break:<list[bookshelf_inventory_drop|location_remove_flags]>
    - flag <context.location> on_explodes:cancel
    - flag <context.location> remove_flags:<list[on_break|on_explodes|bookshelf_inventory|remove_flags]>

bookshelf_inventory_drop:
  type: task
  debug: false
  script:
    - if <context.location.has_flag[bookshelf_inventory]>:
      - determine passively <context.location.drops[<player.item_in_hand>].include[<context.location.flag[bookshelf_inventory].values>]>

bookshelf_inventory_save:
  type: task
  debug: false
  script:
    - define location <context.inventory.slot[5].flag[location]>
    - flag <[location]> bookshelf_inventory:<context.inventory.map_slots.exclude[5]>