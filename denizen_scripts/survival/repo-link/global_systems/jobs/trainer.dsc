## Trainer Job

# /npc assign --set click_on_horse_assignment
##Temporary

# Horse Assignment
click_on_horse_assignment:
  type: assignment
  actions:
    on assignment:
    - trigger name:click state:true
    on click:
    - narrate "<&c>This action will become available in an upcoming update!"
  interact scripts:
  - 1 horse_trainer_interact_handler
  
# Interaction handler
horse_trainer_interact_handler:
  type: interact
  debug: true
  steps:
    1:
      Click trigger:
        script:
         - wait 1t
         - animate <npc> animation:horse_buck
