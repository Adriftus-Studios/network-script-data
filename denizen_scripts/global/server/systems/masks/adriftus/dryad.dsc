mask_adriftus_dryad:
  type: data
  display_data:
    category: Adriftus
    material: oak_leaves
    display_name: <&6>Adriftus<&co> <&6>Dryad
    description: "<&c>Dryad Character"
  mask_data:
    on_equip_task: mask_adriftus_dryad_equip
    on_unequip_task: mask_adriftus_dryad_unequip
    id: adriftus_dryad
    display_name: <&2>Dryad
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTY1MTUyNDU4NzUwNSwKICAicHJvZmlsZUlkIiA6ICIxZjEyNTNhYTVkYTQ0ZjU5YWU1YWI1NmFhZjRlNTYxNyIsCiAgInByb2ZpbGVOYW1lIiA6ICJtbl9raSIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS9kMjNlNDIxNDZjYzg1ZmIwZGQyYTQ5YWRhYTBhN2M3ZTAyZDYyNWJiZTBmMjdhMzk4MWM1NTAxOTdjMzIzOTAiLAogICAgICAibWV0YWRhdGEiIDogewogICAgICAgICJtb2RlbCIgOiAic2xpbSIKICAgICAgfQogICAgfQogIH0KfQ==;bkfyjgZMNQqfOe0wHrwhNT0v/nuMso3fUrWQF6Y/jqLApzuCvAV5SbvJkQAIkRhlcN+/JEDinZu3qJPk1gB4uJ2bd5UeTpV+SmQNSjUhm2YmuojCJlWu6lKMr8Xepl7OVzUQDWJ8gwmfsswRlhIf0l7dTpMya/2hRc1SKUt8LKk2M8xY2yWrY3lVI024YCRbqdpha9S5EUHg/bKtn0QqD4FiecACfUQoU7TQuncL9iVVTJhrJADRGwKmwrMzXQGVzMwBkYLSrIm7w4yq+P8eSacStp29tsZaHbg0v1Uw2Z7QMU4kOsUdk15g4ChsUW9yM5yoeGPUvz4kOUHFyHbRPfiR65bIMKJhrOD7GhkD9tQ+tKF6bnNvbwXU7iYQu8/p2r3nkpUC8LjDB9Q5l+Pk1MGUyMz+VJ5sJLMeEyZlz3xjYKHN3s/uM05mSi9ALtgt1Rvr5lH29SqJKhx4DHrnNaykrqY1teQmkXneACZAMmdUrwa1qAwNYApPibztxyTYaBWEOoyZQgRF5jrRzcunj/Z5U9+wBvsMaj3CE+GFsdTrrRCBV2Ne/Vfx4Tk9kuk3UZi4z6o2DEkXw1MH+oa6VEfQmistsKnjFjiKY8BgEtBasl2EJv8vfhhAaCDNRQnXx9zOpnzkYSz1pvCm9DIS7p1BSbTCNEFLOp8gVFEvGj8=

mask_adriftus_dryad_equip:
  type: task
  debug: false
  script:
    - flag <player> on_damaged:mask_dryad_deflect_attack

mask_adriftus_dryad_unequip:
  type: task
  debug: false
  script:
    - flag <player> on_damaged:!


mask_dryad_deflect_attack:
  type: task
  debug: false
  script:
    - playeffect effect:redstone quantity:5 offset:0.05 special_data:1|#009900 at:<context.damager.precise_target_position> visibility:100
    - determine cancelled