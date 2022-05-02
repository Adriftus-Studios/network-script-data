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
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTY1MTUyNDQ4ODc4NiwKICAicHJvZmlsZUlkIiA6ICIwMGZiNTRiOWI4NDA0YTA0YTViMmJhMzBlYzBlYTAxMiIsCiAgInByb2ZpbGVOYW1lIiA6ICJrbGxveWQ3MCIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS9kZTgzYWJlNWVmNjA2NjU2MTMzNDU2MjdlZjlmMDhkYjIwZWZlYmUzZGIyMmNlMzUyYzJkYzc0OGVhZWU2N2I1IgogICAgfQogIH0KfQ==;cLl969UPlElqsCKosBKWUK93VGSZKP4rnCO3NHOuKac7TK6y1Aq0hp9QlUx7AQ8yNy7/TiWTepimMef2lI0TzOaSEnRiCWBnpws9248aQ/RE7j1FwTbnAiCU7mnEnY+DIgxuzmhm1P6xUE2ZGbrJK24fdlMhta/Yn3aWulj/lVgvT0E6BAGwIqUl02EfYds0YRKsPCX5z85Y3dpDVSms03Q0cqUzBg0rV3xeRqubduwYjys1mZG9LnmPYhP1c3j2eL2ZqUDXW+/c41YLRWhVvl4Wv1K9dcl2SnjUS1ZXhsMx2xpKMSyYuG9wTvO8poJDN7Uv8x7qt64hvFvN8QJBe3lSgV9d/RAuC3pAtQC1CNUok+JAZhMHn5duAfhpl4E8HOaQtF6RXUSyqSJdhsb1HSfq9nIlXzJx94Wm9Iz/VewDmkGWOBKCP2qrHPu6KZuhtlyjzwb/V7eYNmYc136T95csULtkmB2X5vv6vGhIbCMkaPcwjQ2j3jNbfavp2XynsSojQrD5aB3iQlVRgBHIcylwgtaR3WTdRj3l5yvjecBB1m6Fkb9NgQmCuZJfIl6gkR25wDkxAffP2qlmU7m1pbIsHDPHNc+jVSLgm/7Nq4gTDcxGPQHt0vMrPzp8Fs69zuhB6a/Xqw0wUJHKX5RGeapCdnwY9412aZp7z+5q1H8=

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