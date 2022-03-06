impl_skilltree_Warrior:
  type: data

  # The internal name of the skill tree (this MUST be unique)
  name: warrior

  # The display item of the skill tree for GUIs
  display_item_script: impl_skillTree_warrior_icon

  # Tags that will be checked to see if a player can have this skill tree
  requirements:
  - "<player.has_flag[class]>"
  - "<player.flag[class].equals[Warrior]>"

  # Base command to use Skills from this Skill Tree
  # Command Script MUST be made in this file
  base_command: warrior

impl_skillTree_warrior_icon:
  type: item
  material: feather
  display name: "<&a>Warrior Skills"
  lore:
  - "<&a>Skills for the Warrior Class"
  mechanisms:
    custom_model_data: 1