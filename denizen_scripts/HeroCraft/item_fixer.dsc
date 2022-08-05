item_fixer:
  type: task
  debug: false
  definitions: inventory
  script:
    - define inventory <player.open_inventory> if:<[inventory].exists.not>
    - foreach <[inventory].map_slots>:
      - if <[value].script.exists>:
        - if <[value].script> == fix_items_button:
          - foreach next
        - inventory set slot:<[key]> o:<[value].script.name.as_item.with[quantity=<[value].quantity>]> d:<[inventory]>

item_fixer_inventory:
  type: inventory
  debug: false
  inventory: chest
  size: 54
  title: <&color[#010000]>Item Fixer!
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
    run_script:
      - item_fixer
      - cancel

item_fixer_assignment:
  type: assignment
  actions:
    on assignment:
      - trigger name:click state:true
    on click:
      - inventory open d:item_fixer_inventory