mask_adriftus_blood_lord:
  type: data
  display_data:
    category: Adriftus
    material: red_candle
    display_name: <&6>Adriftus<&co> <&5>Blood Lord
    description: "<&5>ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn"
  mask_data:
    on_equip_task: mask_adriftus_blood_lord_equip
    on_unequip_task: mask_adriftus_blood_lord_unequip
    id: adriftus_blood_lord
    display_name: <&4>Blood Lord
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTY1MTUxMzY3OTI5MiwKICAicHJvZmlsZUlkIiA6ICJiMjdjMjlkZWZiNWU0OTEyYjFlYmQ5NDVkMmI2NzE0YSIsCiAgInByb2ZpbGVOYW1lIiA6ICJIRUtUMCIsCiAgInNpZ25hdHVyZVJlcXVpcmVkIiA6IHRydWUsCiAgInRleHR1cmVzIiA6IHsKICAgICJTS0lOIiA6IHsKICAgICAgInVybCIgOiAiaHR0cDovL3RleHR1cmVzLm1pbmVjcmFmdC5uZXQvdGV4dHVyZS82OTIyOWNkZTVjMGQyYWJiODcyNzlhODBjYTU1MTg4YzdiOTlkOGFkOWE5MTRhYTc2YjZjNjZmYzhlMjk1N2UiCiAgICB9CiAgfQp9;Yn7JO61fq3Lt6nRmo4p63nvbl4n3C0g02mzLC0zdIiy/Swjt/qAJJxnUT5FSpf/DNf6vy/ouX5f1WKhxaa+A5GWmKhCpPF40IRdSRvg/jq0SxwzHvZqGRRMLLIux98EjtL0bxz6yMZGNo+CczgO53SGSf0XeV4HsWQxUMtxk7SQImfkkn+FH9xNe5g4EzSS+8xKLaaEl/IqlZzv4q1nm5TCWZ0eUEgTmZkKDBIbmISUveq8XFj5j0eMsQH+C3/4DbQDntu5E8p4d87xqBIxeFSpw8vx14rnqUzJK4BTl9d3WhwB1hDeLijMjta/JWEpNrlk4w2jwkBbyFs9sVJMj+9ltUR0R3jlOIvLlJ40CVzNEs2Mb8To4oLA7eIs0Da/5jHjR6FEjPEiwNbbXS2intN51hGOeABYab2qO4L256WV1IvPWTn9SbZDlyGw4NQtJKOnmCmSccAjtwEdiR09BUmRGwT2Bq2iS/sEfdSJ6nhEjdqVh+2851lH+HS7F6CIVhecVUUnWyMnkyJevUpwqnLvMZ0DfM4h7UX587PecYxR+VdyvJMNuw6sLa4dRZ9vh+J5xTT1nE8/Ez6YSmE3ZWzN9czleBdtrEpFfUpGT41rVjFUKIRRbH+wfA1agtjXrMOksIfRJ+6FW5UAfFEulsPlDpCfny6XUKoCsCF0xmJg=

mask_adriftus_blood_lord_equip:
  type: task
  debug: false
  script:
    - flag <player> on_damaged:BLOOD_MAGIC_DEFLECT_ATTACK
    - flag <player> can_fly:true
    - flag <player> on_target:cancel
    - flag <player> on_hunger_change:cancel

mask_adriftus_blood_lord_unequip:
  type: task
  debug: false
  script:
    - flag <player> on_damaged:!
    - flag <player> can_fly:false
    - flag <player> on_target:!
    - flag <player> on_hunger_change:!
