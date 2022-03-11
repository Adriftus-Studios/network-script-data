anvil_allow_color:
  type: world
  debug: false
  events:
    on player prepares anvil craft item permission:adriftus.anvil.color:
      - if <context.new_name.starts_with[&z]>:
        - determine <context.item.with[display=<context.new_name.substring[3].rainbow>]> if:<context.item.material.name.equals[air].not>
      - determine <context.item.with[display=<context.new_name.parse_color>]> if:<context.item.material.name.equals[air].not>