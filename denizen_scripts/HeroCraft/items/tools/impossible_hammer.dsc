impossible_pickaxe:
  type: item
  material: wooden_pickaxe
  display name: <&6>Impos<&k>s<&r><&6>ibl<&k>e<&r><&6> Ha<&k>mm<&r><&6>er
  lore:
    - "<&e>Bending Reality"
    - "<&b>Defies Physics"

impossible_pickaxe_events:
  type: world
  debug: false
  events:
    on player breaks block with:impossible_pickaxe bukkit_priority:HIGHEST:
      - modifyblock <context.location> air no_physics