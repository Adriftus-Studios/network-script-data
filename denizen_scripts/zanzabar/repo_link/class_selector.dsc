inventory_class_selector_events:
  type: world
  debug: false
  events:
    on player clicks in inventory_class_selector:
    - if <context.item.script.data_key[data.class_impl].exists>:
      - define impl <context.item.script.data_key[data.class_impl].as_script>
      - define class <[impl].data_key[name]>
      - run class_select def:<[class]>

inventory_class_selector:
  type: inventory
  inventory: chest
  size: 54
  title: <&f><&font[adriftus:guis]><&chr[F808]><&chr[6907]>
  gui: true
  definitions:
    f: <item[standard_filler]>
  slots:
  - [f] [inventory_class_selector_mage_icon] [f] [inventory_class_selector_warrior_icon] [f] [inventory_class_selector_rogue_icon] [f] [inventory_class_selector_ranger_icon] [f]
  - [f] [f] [f] [f] [f] [f] [f] [f] [f]
  - [f] [impl_skill_blast_icon] [f] [impl_skill_leap_icon] [f] [impl_skill_backstab_icon] [f] [impl_skill_disengage_icon] [f]
  - [f] [impl_skill_blink_icon] [f] [impl_skill_second_wind_icon] [f] [impl_skill_poison_dagger_icon] [f] [impl_skill_explosive_arrow_icon] [f]
  - [f] [impl_skill_magic_missile_icon] [f] [impl_skill_strike_icon] [f] [impl_skill_recover_icon] [f] [impl_skill_marksman_shot_icon] [f]
  - [f] [impl_skill_shield_icon] [f] [impl_skill_sword_spin_icon] [f] [impl_skill_sprint_icon] [f] [impl_skill_sick_em_icon] [f]

inventory_class_selector_mage_icon:
  type: item
  material: iron_nugget
  display name: "<&a>Mage"
  data:
    class_impl: impl_skilltree_Mage
  mechanisms:
    custom_model_data: 22

inventory_class_selector_ranger_icon:
  type: item
  material: iron_nugget
  display name: "<&a>Ranger"
  data:
    class_impl: impl_skilltree_Ranger
  mechanisms:
    custom_model_data: 23

inventory_class_selector_rogue_icon:
  type: item
  material: iron_nugget
  display name: "<&a>Rogue"
  data:
    class_impl: impl_skilltree_Rogue
  mechanisms:
    custom_model_data: 24

inventory_class_selector_warrior_icon:
  type: item
  material: iron_nugget
  display name: "<&a>Warrior"
  data:
    class_impl: impl_skilltree_Warrior
  mechanisms:
    custom_model_data: 25
