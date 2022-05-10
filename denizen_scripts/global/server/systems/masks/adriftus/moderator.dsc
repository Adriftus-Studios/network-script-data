mask_adriftus_moderator:
  type: data
  display_data:
    category: Adriftus
    material: iron_pickaxe[custom_model_data=1]
    display_name: <&6>Adriftus<&co> <&c>Moderator
    description: "<&d>We r da Law!"
  mask_data:
    on_equip_task: mask_adriftus_moderator_equip
    on_unequip_task: mask_adriftus_moderator_unequip
    permission: adriftus.moderator
    id: adriftus_moderator
    display_name: <&c>Moderator
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTY1MjE4OTQ2MDg5NiwKICAicHJvZmlsZUlkIiA6ICIwZWQ2MDFlMDhjZTM0YjRkYWUxZmI4MDljZmEwNTM5NiIsCiAgInByb2ZpbGVOYW1lIiA6ICJOZWVkTW9yZUFjY291bnRzIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlL2Y3MGNmOGJkYjFmYTNkNDczNTQ5Mjk0YjMzYWMxZmMxM2FiYjY2MTJmY2YyMWU5NmQ1ZTNmYjM1YWYzZTllNTUiCiAgICB9CiAgfQp9;te/RBAUb7ndJn1tqrza2lQh5O0gH0UgQT3ep5az3eqFeg0l15I2bQV5uSCm6nBS/ttEJFU8PEfGLi0svyPk/iFqgdoSZzr1I+F7iuoIs0Z+LYgMp38Iv6PXXS4L6ECjj+4R4SRNcjXfDkX+3VrEQqtnCCJhJFzPnDYxOv8QIwJmr1CbAk9MmKJwVHJUR8ebAVk3N2c5D7dyf+FbdG8guVU9qZQUVx9NfuLN2e8HNTa3K7I+ThfO29NldMyuemfg+q2u66hJl2TTFGn/QckcpXKyHew8dIy674ZedpzYB9u+ej77B987arfwFnU0fuz+478ZEMn0e5NUc6SURr4+p6b8zojEOM1qBqhE0n4xnZepd9Hpz/hh95dsAVGCL3k+68Ye72gmfYdxLFLfcc5N7Z0tJkgdvtcSbpEATjUkCGEPTPFaKqvKDASZYZAHqHjjBkB881WZd82qk9Dyxc91V6rLi/4vwmRmntDVlFO6JNmq136XXyAQ6KlFxn2ShfY7aKxNpGVEYRaJW924iKkAV4JrVKDJYiCooZDMZ1D1JT596NVRRp4dVMWecXD931GU6WPglescQl+mT6OZkTzC5HH1ZtKU7x8qLFbBQ5Hs2Or8SqgsXkj3QAee6vbug/DmV0RgBJKMxGfBDxkUaVSdNgoNBsdF7y66J1lltGxWGDlY=

mask_adriftus_moderator_equip:
  type: task
  debug: false
  script:
    - flag player moderator_mask.location:<player.location>
    - flag player moderator_mask.health:<player.health>
    - flag player moderator_mask.hunger:<player.food_level>
    - heal
    - feed
    - flag player on_hunger_change:->:cancel
    - flag player on_damaged:->:cancel
    - run SAVED_INVENTORY_LOAD def:moderator
    - wait 2t
    - adjust player can_fly:true

mask_adriftus_moderator_unequip:
  type: task
  debug: false
  script:
    - flag player on_hunger_change:<-:cancel
    - flag player on_damaged:<-:cancel
    - adjust player can_fly:false
    - adjust <player> health:<player.flag[moderator_mask.health]>
    - adjust <player> food_level:<player.flag[moderator_mask.hunger]>
    - adjust <player> location:<player.flag[moderator_mask.location]>
    - flag player moderator_mask.health:!
    - flag player moderator_mask.hunger:!
    - flag player moderator_mask.location:!
    - run SAVED_INVENTORY_LOAD def:default