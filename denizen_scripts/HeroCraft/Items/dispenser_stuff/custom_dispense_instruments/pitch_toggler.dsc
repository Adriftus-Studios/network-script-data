dispenser_note_block_pitch_incrementer:
  type: world
  debug: false
  events:
    on player right clicks block with:dispenser_instrument_*:
      - determine passively cancelled
      - ratelimit <player> 5t
      - define current_pitch <context.item.flag[pitch]>
      - choose <[current_pitch]>:
        - case 0.5:
          - define new_pitch 0.529
        - case 0.529:
          - define new_pitch 0.561
        - case 0.561:
          - define new_pitch 0.594
        - case 0.594:
          - define new_pitch 0.629
        - case 0.629:
          - define new_pitch 0.667
        - case 0.667:
          - define new_pitch 0.707
        - case 0.707:
          - define new_pitch 0.749
        - case 0.749:
          - define new_pitch 0.793
        - case 0.793:
          - define new_pitch 0.840
        - case 0.840:
          - define new_pitch 0.890
        - case 0.890:
          - define new_pitch 0.943
        - case 0.943:
          - define new_pitch 1.0
        - case 1.0:
          - define new_pitch 1.059
        - case 1.059:
          - define new_pitch 1.122
        - case 1.122:
          - define new_pitch 1.189
        - case 1.189:
          - define new_pitch 1.259
        - case 1.259:
          - define new_pitch 1.334
        - case 1.334:
          - define new_pitch 1.414
        - case 1.414:
          - define new_pitch 1.498
        - case 1.498:
          - define new_pitch 1.587
        - case 1.587:
          - define new_pitch 1.681
        - case 1.681:
          - define new_pitch 1.781
        - case 1.781:
          - define new_pitch 1.887
        - case 1.887:
          - define new_pitch 2.0
        - case 2.0:
          - define new_pitch 0.5
      - inject pitch_feedback_task

dispenser_note_block_pitch_decrementer:
  type: world
  debug: false
  events:
    on player left clicks block with:dispenser_instrument_*:
      - determine passively cancelled
      - ratelimit <player> 5t
      - define current_pitch <context.item.flag[pitch]>
      - choose <[current_pitch]>:
        - case 0.5:
          - define new_pitch 2.0
        - case 0.529:
          - define new_pitch 0.5
        - case 0.561:
          - define new_pitch 0.529
        - case 0.594:
          - define new_pitch 0.561
        - case 0.629:
          - define new_pitch 0.594
        - case 0.667:
          - define new_pitch 0.629
        - case 0.707:
          - define new_pitch 0.667
        - case 0.749:
          - define new_pitch 0.707
        - case 0.793:
          - define new_pitch 0.749
        - case 0.840:
          - define new_pitch 0.793
        - case 0.890:
          - define new_pitch 0.840
        - case 0.943:
          - define new_pitch 0.890
        - case 1.0:
          - define new_pitch  0.943
        - case 1.059:
          - define new_pitch 1.0
        - case 1.122:
          - define new_pitch 1.059
        - case 1.189:
          - define new_pitch 1.122
        - case 1.259:
          - define new_pitch 1.189
        - case 1.334:
          - define new_pitch 1.259
        - case 1.414:
          - define new_pitch 1.334
        - case 1.498:
          - define new_pitch 1.414
        - case 1.587:
          - define new_pitch 1.498
        - case 1.681:
          - define new_pitch 1.587
        - case 1.781:
          - define new_pitch 1.681
        - case 1.887:
          - define new_pitch 1.781
        - case 2.0:
          - define new_pitch 1.887
      - inject pitch_feedback_task

pitch_feedback_task:
  type: task
  debug: false
  script:
    - define instrument <context.item.script.name.after[dispenser_instrument_]>
    - playsound sound:block_note_block_<[instrument]> pitch:<[new_pitch]> <player>
    - inventory flag slot:<player.held_item_slot> pitch:<[new_pitch]>
    - inventory adjust slot:<player.held_item_slot> "lore:<&6>Current Pitch<&co> <&e><script[pitch_data_key].data_key[pitch_name.<[new_pitch].before[.]><[new_pitch].after[.]>]> <&6>(<&e><[new_pitch]><&6>)"
    - narrate "<&6>Current Pitch<&co> <&e><script[pitch_data_key].data_key[pitch_name.<[new_pitch].before[.]><[new_pitch].after[.]>]> <&6>(<&e><[new_pitch]><&6>)"

pitch_data_key:
  type: data
  pitch_name:
    05: F♯
    0529: G
    0561: G♯
    0594: A
    0629: A♯
    0667: B
    0707: C
    0749: C♯
    0793: D
    0840: D♯
    0890: E
    0943: F
    10: F♯
    1059: G
    1122: G♯
    1189: A
    1259: A♯
    1334: B
    1414: C
    1498: C♯
    1587: D
    1681: D♯
    1781: E
    1887: F
    20: F♯
