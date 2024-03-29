item_fixer:
  type: task
  debug: true
  definitions: inventory
  script:
    - ratelimit <player> 5t
    - define inventory <player.open_inventory> if:<[inventory].exists.not>
    - foreach <[inventory].map_slots>:
      - if <[value].script.exists>:
        - if <[value].script> == fix_items_button:
          - foreach next
        - inventory set slot:<[key]> o:<[value].script.name.as_item.with[quantity=<[value].quantity>]> d:<[inventory]>

item_fixer_give_back:
  type: task
  debug: false
  script:
    - give <context.inventory.map_slots.exclude[50].values> to:<player.inventory>

item_fixer_inventory:
  type: inventory
  debug: false
  inventory: chest
  size: 54
  title: <&color[#010000]>Item Fixer!
  data:
    on_close: item_fixer_give_back
    click_script_slots:
      50: cancel
  slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [fix_items_button] [] [] [] []

fix_items_button:
  type: item
  debug: false
  material: paper
  display name: <&c>Fix These Items!
  lore:
    - <&a>Put items in this inventory
    - <&b>Click me to fix them.
  mechanisms:
    custom_model_data: 1
  flags:
    run_script: item_fixer

item_fixer_assignment:
  type: assignment
  debug: false
  actions:
    on assignment:
      - trigger name:click state:true
    on click:
      - inventory open d:item_fixer_inventory