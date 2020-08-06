## Beekeeper Job

# /npc assign --set click_on_beekeeper_assignment

# Horse Assignment
click_on_beekeeper_assignment:
  type: assignment
  actions:
    on assignment:
    - trigger name:click state:true
    on click:
    - narrate "<&c>This action will become available in an upcoming update!"
  interact scripts:
  - 1 bee_keeper_interact_handler
  
# Interaction handler
bee_keeper_interact_handler:
  type: interact
  debug: true
  steps:
    1:
      Click trigger:
        script:
         - wait 1t
         - animate <npc> animation:arm_swing

# Beehive interaction
click_on_beehive_spawn:
  type: world
  events:
    on player clicks beehive in:spawn:
      - ratelimit <player> 10s
      - determine passively cancelled
      - narrate "<&c>This action will become available in an upcoming update!"
