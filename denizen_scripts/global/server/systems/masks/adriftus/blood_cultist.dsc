mask_adriftus_blood_cultist:
  type: data
  display_data:
    category: Adriftus
    material: end_rod
    display_name: <&6>Adriftus<&co> <&4>Blood Cultist
    description: "<&c>Blood Cultist Character"
  mask_data:
    on_equip_task: mask_adriftus_blood_cultist_equip
    on_unequip_task: mask_adriftus_blood_cultist_unequip
    id: adriftus_blood_cultist
    display_name: <&4>Blood Cultist
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTY1MTUyNDY4Nzk5MywKICAicHJvZmlsZUlkIiA6ICJlM2I0NDVjODQ3ZjU0OGZiOGM4ZmEzZjFmN2VmYmE4ZSIsCiAgInByb2ZpbGVOYW1lIiA6ICJNaW5pRGlnZ2VyVGVzdCIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS81ZmY4MzUxY2QzY2Y2YWE4MmY1MTc5YWRhZmE2OWM2YjA1Mzc5YWY2NDI5NmEyMWJkYmUxZDY5YzJmNmJlNDhkIgogICAgfQogIH0KfQ==;APAElKLqFbpNKYs1S4+niImAZLhE1H4Js0rMGKqmDjg6n/qi0P/yg+TB+4Z+qAvif557IWb0Q5znql3XTEyo5E22TWZY7kUmc9211G3XJrLimVWHK8xIrdW+qmgQchGWpCeOrgS1kjfO8+Zm/zkyL1p2kKJsxQetIELZFK0MzmjD+jHPxefTnU5D/24cvKhm6ADB2ZzViMbssKxzrxDykNfsnQb1/t2IlAVlPJ/nLkmyVsh1L7RtO8PCvMQ/J6B003oTeJG8HHqwmcn/kvzbTSqdWYV6/lz1Juzk++GjQGU+F4FxwLgcRCsUX8Y3xEhInuBnWGpybJxj+BdPrd9lVRCI7HYR/5n3MAnnFo7wjqzudCGCRjS466khuo6ozhE8oghvjBk5uqZPTkVfCZW4PHHQv/RGdGxuC+b2eWF4bWmUbd08bODrZ6SJpkZLJaLMHTi8t5Sao+scTpx3/fnwwXRsv/Hi7K6k9JwcubTQWBImfy00BDGivpihwQZ2E61gs3zmMv8sGzq0kxJtn9RlFRrqqqEAHOUBJU1fW9Qr66RJUaYeN3ftdEzGC9QzA5IjCkuaievNW4znSOPGpRhzhEmfbW/r8K274HwJrSZ2RsVy226Pdpz155+4/2IpcxQPgnCCD84mkz5i+fdmSMVU5aFRVmNksRZ5eGm5fVHhXDU=

mask_adriftus_blood_cultist_equip:
  type: task
  debug: false
  script:
    - flag <player> on_death:mask_adriftus_blood_cultist_death

mask_adriftus_blood_cultist_unequip:
  type: task
  debug: false
  script:
    - flag <player> on_death:!

mask_adriftus_blood_cultist_death:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - define location <player.location>
    - teleport <player> <player.location.world.spawn_location>
    - repeat 10:
      - playeffect at:<[location]> effect:redstone special_data:1|#990000 offset:0.25,1,0.25 quantity:15 targets:<server.online_players>
      - wait 2t
    - run mask_remove def:adriftus_blood_cultist