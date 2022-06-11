anvil_allow_color:
  type: world
  debug: false
  events:
    on player prepares anvil craft item permission:adriftus.anvil.color:
      # Custom Rainbow Color Code
      - define name <context.new_name>
      - if <context.new_name.contains[&z]>:
        - define name <[name].replace[&z].with[<&color[#010000]>]>
      - if <context.new_name.contains[&y]>:
        - define name <[name].replace[&y].with[<&color[#000001]>]>
      - if <context.new_name.contains[&x]>:
        - define name <[name].replace[&x].with[<&color[#000100]>]>
      - determine <context.item.with[display=<[name].parse_color>]> if:<context.item.material.name.equals[air].not>