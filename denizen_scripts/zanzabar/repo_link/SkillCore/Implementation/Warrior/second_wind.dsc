impl_skill_second_wind:
  type: data
  # Internal Name MUST BE UNIQUE
  name: second_wind

  # Display data used in commands, and GUIs
  display_item_script: impl_skill_second_wind_icon

  # Skill Tree (uses internal name)
  skill_tree: warrior

  # Unlock Requirements are checked when unlocking the ability
  unlock_requirements:
  - "true"

  # Cooldown
  cooldown: 30s

  # Task Script to bee run when the ability is used successfully
  # This Task Script MUST be within this file, as with any code associated with this skill
  on_cast: impl_skill_second_wind_task

  # Is the ability harmful? (PvP Action)
  harmful: false

  # Does using this ability flag you for PvP if it succeeds (even if not damaging)
  pvp_flags: false

  # Skill Targetting
  # these tags will be parsed to determine targets
  # Only available context is <player>
  targetting_tags:
  - "<player>"

  # Messages are parsed in the script, use tags for colors
  # Each script should make a list in this comment for available context
  messages:
    # Every script should have `no_target` value, unless it is a self target
    no_target: "<&c>You have no target within range."

  # Balance Values used in the script
  balance:
    health: <player.health_max.div[2].round>

# Display Icon for the skill itself
# "lore" field might be used in chat diplays, and other GUIs
impl_skill_second_wind_icon:
  type: item
  material: iron_nugget
  display name: "<&a>Second Wind"
  lore:
  - "<&b>Instantly recover 50<&pc> of your HP"
  mechanisms:
    custom_model_data: 12


# The On Cast Task script has specific requirements, and limits
# The only reliable context tags in this task will be `<player>`
# The task must `determine` true or false if the ability was successful or not.
impl_skill_second_wind_task:
  type: task
  debug: false
  definitions: target
  script:
    - heal <script[impl_skill_second_wind].parsed_key[balance.health]>
    - playeffect effect:totem at:<player.location.above[2]> quantity:20 offset:0.25
    - playsound <player.location> sound:ENTITY_SPLASH_POTION_BREAK volume:5.0 sound_category:players
    - determine true