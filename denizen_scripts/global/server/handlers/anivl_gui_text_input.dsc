anvil_gui_callback_example:
  type: task
  debug: false
  definitions: text_input
  script:
    - narrate <[text_input]>

anvil_gui_text_input:
  type: task
  debug: false
  definitions: title|info|callback
  script:
    - define lore <element[<&b>------------].repeat_as_list[2].insert[<[info]>].at[2].separated_by[<&nl>]>
    - define item <item[anvil_gui_item].with[display=<&a>;lore=<[lore]>;flag=callback:<[callback]>]>
    - openanvil title:<&f><[title]> font:adriftus:guis
    - inventory set d:<player.open_inventory> slot:1 o:<[item]>
    - inventory set d:<player.open_inventory> slot:3 o:air

anvil_gui_handle:
  type: task
  debug: false
  script:
    - inventory set slot:1 o:air d:<context.inventory>
    - inventory close
    - run <context.item.flag[callback]> def:<context.item.flag[text_input]>

anvil_gui_text_events:
  type: world
  debug: false
  events:
    on player prepares anvil craft anvil_gui_item:
      - stop if:<context.inventory.slot[1].script.name.equals[anvil_gui_item].not.if_null[false]>
      - determine passively 0
      - determine <context.item.with[material=paper;custom_model_data=1;display=<&a>Accept;lore=;flag=text_input:<context.new_name>;flag=run_script:anvil_gui_handle]>
    on player clicks in inventory priority:1:
      - determine cancelled if:<context.inventory.slot[3].script.name.equals[anvil_gui_item].if_null[false]>
    on player closes inventory:
      - stop if:<context.inventory.slot[1].script.name.equals[anvil_gui_item].not.if_null[true]>
      - inventory set slot:1 d:<context.inventory> o:air

anvil_gui_item:
  type: item
  material: feather
  display name: <&c>DEBUG
  mechanisms:
    custom_model_data: 3