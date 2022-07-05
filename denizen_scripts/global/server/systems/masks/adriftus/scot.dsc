mask_adriftus_scot:
  type: data
  display_data:
    category: Adriftus
    material: cobweb
    display_name: <&6>Adriftus<&co> <&4>Scot
    description: "<&c>Burn them all!"
  mask_data:
    on_equip_task: mask_adriftus_scot_equip
    on_unequip_task: mask_adriftus_scot_unequip
    permission: adriftus.scot
    id: adriftus_scot
    display_name: <&4>Dark-Lord Scot
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTYyODU0NzEzODc5OCwKICAicHJvZmlsZUlkIiA6ICI3NzI3ZDM1NjY5Zjk0MTUxODAyM2Q2MmM2ODE3NTkxOCIsCiAgInByb2ZpbGVOYW1lIiA6ICJsaWJyYXJ5ZnJlYWsiLAogICJzaWduYXR1cmVSZXF1aXJlZCIgOiB0cnVlLAogICJ0ZXh0dXJlcyIgOiB7CiAgICAiU0tJTiIgOiB7CiAgICAgICJ1cmwiIDogImh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMjAwNGIyNDM4ZjE3NWIwZTRhZjhlMWVkODU4ZWNiN2YzNmQ3NDU5MWQxOThlZTIzNzg5NjhiZDQ0NDdjZTA3MyIKICAgIH0KICB9Cn0=;JmGUgjVW+Q6Arwh1YJN8sLXqxBC98CPSSVVLDFl/T4ds8I5Nnw2q0Vs0dHcoeZ1aApt9M85O2tfUkBwHzXGMot375Ced8znwFLWXREnK3Ds02nqU/cvZVEvciWfEPBUXFGhY1d1p8BOKkfFnwVAXvAHmjjWQcskD+FpoUZIWPRC5KN/TI4wSQfwox4aGEPsadd1gyaszv/JMGUSOG/ybiuY8YgGAqer26DACs3eXcg5RcC6yfPyh04rgbXmkqfGn3rE6n63G19Y3S/jfzaEl8RvRt/61ZzaYBlBQK1ZGGfJthMMJS1FbtAg2OSu58MT9inxSl/QvjfPaYkBzACXacHz/xfzxGs+ivRcdDIxOqqbYGVFrq3Ghs/QxzOO/ZBhAbc3R+DLjJ610VtmuHlyGkLoh3SEFA5u0+kEYvkZ3oqiojfR+Ay/HMF2ku70dgMTtGh4Xymj7bAW3rVWggX0tZ9DdEQlH6zQ8vBC92v2iA1u7t4phjU/hwp5uAWn2KKKgxIsyYeKeAUWB887yBSjsx1qZi7CZHEAkUvjKcjZeWkuZRjqsseU62wdZDDGon15UI3MuYQxsBx6vwWjH3Jenr2Qtd8Vq/GzMAFXRu/cVAqIQbSVqh/SgOUBRFMtQ54Kt6+MxkKWrTqmrzUxX3bMiURikp/8k1DstcSuggiVM9ng=

mask_adriftus_scot_equip:
  type: task
  debug: false
  script:
    - heal
    - feed
    - flag player on_hunger_change:->:cancel
    - flag player on_damaged:->:cancel
    - adjust <player> can_fly:true
    - cast night_vision duration:9999h no_ambient hide_particles
    - wait 10t
    - adjust player can_fly:true

mask_adriftus_scot_unequip:
  type: task
  debug: false
  script:
    - heal
    - feed
    - flag player on_hunger_change:<-:cancel
    - flag player on_damaged:<-:cancel
    - adjust <player> can_fly:false
    - cast night_vision cancel
    - wait 10t
    - adjust player can_fly:true