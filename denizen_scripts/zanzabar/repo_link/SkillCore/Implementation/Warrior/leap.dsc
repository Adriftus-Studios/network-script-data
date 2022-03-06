impl_skill_leap:
  type: data
  # Internal Name MUST BE UNIQUE
  name: leap

  # Display data used in commands, and GUIs
  display_item_script: impl_skill_leap_icon

  # Skill Tree (uses internal name)
  skill_tree: warrior

  # Unlock Requirements are checked when unlocking the ability
  unlock_requirements:
  - "true"

  # Cooldown
  cooldown: 10s

  # Task Script to bee run when the ability is used successfully
  # This Task Script MUST be within this file, as with any code associated with this skill
  on_cast: impl_skill_leap_task

  # Is the ability harmful? (PvP Action)
  harmful: true

  # Does using this ability flag you for PvP if it succeeds (even if not damaging)
  pvp_flags: true

  # Skill Targetting
  # these tags will be parsed to determine targets
  # Only available context is <player>
  targetting_tags:
  - "<player.precise_target[8]>"

  # Messages are parsed in the script, use tags for colors
  # Each script should make a list in this comment for available context
  messages:
    # Every script should have `no_target` value, unless it is a self target
    no_target: "<&c>You have no target within range."
    not_on_ground: "<&c>You must be on the ground to jump"

  # Balance Values used in the script
  balance:
    vector_multiplier: 2

# Display Icon for the skill itself
# "lore" field might be used in chat diplays, and other GUIs
impl_skill_leap_icon:
  type: item
  material: iron_nugget
  display name: "<&a>Leap"
  lore:
  - "<&b>Leap forward in a range of angles"
  - "<&b>You will not take fall damage for 5 seconds"
  mechanisms:
    custom_model_data: 11


# The On Cast Task script has specific requirements, and limits
# The only reliable context tags in this task will be `<player>`
# The task must `determine` true or false if the ability was successful or not.
impl_skill_leap_task:
  type: task
  debug: false
  definitions: target
  script:
    - if <player.is_on_ground>:
      - adjust <player> velocity:<player.location.with_pitch[<player.location.pitch.min[-35].max[-75]>].direction.vector.normalize.mul[<script[impl_skill_leap].data_key[balance.vector_multiplier]>]>
      - playsound <player.location> sound:ENTITY_GOAT_LONG_JUMP volume:5.0 sound_category:players
      - flag player no_fall_damage_once duration:5s
      - determine true
    - narrate <script[impl_skill_leap].parsed_key[messages.not_on_ground]>
    - determine false
