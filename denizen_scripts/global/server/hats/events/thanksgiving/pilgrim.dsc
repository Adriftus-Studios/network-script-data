hat_pilgrim_2022_normal:
  type: data
  hat_data:
    id: pilgrim_2022_normal
    material: clock[custom_model_data=1]
    description: <&a>Thanks for taking the time to celebrate with us!
    display_name: <&a>Pilgrim Hat (2022)
    item: hat_pilgrim_normal_item

hat_pilgrim_normal_item:
  type: item
  material: clock
  display name: <&a>Pilgrim Hat (2022)
  mechanisms:
    custom_model_data: 1
  lore:
  - <&a>Thanks for taking the time to celebrate with us!

pilgrim_normal_unlocker:
  type: world
  debug: false
  events:
    on player right clicks block with:hat_pilgrim_normal_item using:hand:
      - narrate "<&6>You have unlocked the <&e>Oversized Pilgrim Hat<&6>!"
      - narrate "<&6>Thank you for taking the time out of your holidays to celebrate with us here at Adriftus."
      - take iteminhand
      - run hat_unlock def:pilgrim_2022_normal player:<player>
      - playsound sound:ENTITY_CHICKEN_AMBIENT <player.location> pitch:1.5
