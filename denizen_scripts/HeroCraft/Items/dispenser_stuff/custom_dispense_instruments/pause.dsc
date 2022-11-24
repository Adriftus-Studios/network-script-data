dispenser_pause:
  type: item
  material: feather
  mechanisms:
    custom_model_data: 2016
  display name: <&b>Dispenser Pause
  flags:
    custom_dispense: pause
    pause_duration: 5
  lore:
  - <&6>Current Pause<&co> <&e>5 Ticks <&6>(<&e>0.25s<&6>)
  recipes:
    1:
      type: shaped
      output_quantity: 1
      input:
        - steel_ingot|white_wool/orange_wool/magenta_wool/light_blue_wool/yellow_wool/lime_wool/pink_wool/gray_wool/light_gray_wool/cyan_wool/purple_wool/blue_wool/brown_wool/green_wool/red_wool/black_wool|steel_ingot
        - white_wool/orange_wool/magenta_wool/light_blue_wool/yellow_wool/lime_wool/pink_wool/gray_wool/light_gray_wool/cyan_wool/purple_wool/blue_wool/brown_wool/green_wool/red_wool/black_wool|diamond|white_wool/orange_wool/magenta_wool/light_blue_wool/yellow_wool/lime_wool/pink_wool/gray_wool/light_gray_wool/cyan_wool/purple_wool/blue_wool/brown_wool/green_wool/red_wool/black_wool
        - steel_ingot|white_wool/orange_wool/magenta_wool/light_blue_wool/yellow_wool/lime_wool/pink_wool/gray_wool/light_gray_wool/cyan_wool/purple_wool/blue_wool/brown_wool/green_wool/red_wool/black_wool|steel_ingot
  data:
    recipe_book_category: decor.instrument.pause

dispenser_pause_incrementer:
  type: world
  debug: false
  events:
    on player right clicks block with:dispenser_pause:
      - determine passively cancelled
      - ratelimit <player> 5t
      - define current_duration <context.item.flag[pause_duration]>
      - choose <[current_duration]>:
        - case 5:
          - define new_pause 10
        - case 10:
          - define new_pause 15
        - case 15:
          - define new_pause 20
        - case 20:
          - define new_pause 5
      - inject pause_feedback_task

dispenser_pause_decrementer:
  type: world
  debug: false
  events:
    on player left clicks block with:dispenser_pause:
      - determine passively cancelled
      - ratelimit <player> 5t
      - define current_duration <context.item.flag[pause_duration]>
      - choose <[current_duration]>:
        - case 5:
          - define new_pause 20
        - case 10:
          - define new_pause 5
        - case 15:
          - define new_pause 10
        - case 20:
          - define new_pause 15
      - inject pause_feedback_task

pause_feedback_task:
  type: task
  debug: false
  script:
    - inventory flag slot:<player.held_item_slot> pause_duration:<[new_pause]>
    - inventory adjust slot:<player.held_item_slot> "lore:<&6>Current Pause<&co> <&e><[new_pause]> Ticks <&6>(<&e><[new_pause].div[20]>s<&6>)"
    - narrate "<&6>Current Pause<&co> <&e><[new_pause]> Ticks <&6>(<&e><[new_pause].div[20]>s<&6>)"
