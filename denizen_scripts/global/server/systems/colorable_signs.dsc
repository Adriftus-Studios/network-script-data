colorable_signs:
  type: world
  debug: true
  events:
    on player changes sign permission:adriftus.sign.color bukkit_priority:LOWEST priority:-1:
      - determine <context.new.parse[parse_color]>
    on player changes sign permission:adriftus.sign.advanced_color bukkit_priority:LOWEST:
      - define contents <context.new>
      - define contents <[contents].parse[replace[&z].with[<&color[#010000]>]]>
      - define contents <[contents].parse[replace[&y].with[<&color[#000001]>]]>
      - define contents <[contents].parse[replace[&x].with[<&color[#000100]>]]>
      - determine <[contents]>