mask_adriftus_downbad_floyd:
  type: data
  display_data:
    category: Adriftus
    material: redstone
    display_name: <&6>Adriftus<&co> <&f>Downbad Floyd
    description: "<&e>Downbad Floyd Character"
  mask_data:
    permission: adriftus.admin
    id: adriftus_downbad_floyd
    on_equip_task: mask_adriftus_downbad_floyd_equip
    on_unequip_task: mask_adriftus_downbad_floyd_unequip
    display_name: <&f>Downbad Floyd
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTY1MDkyMjE5MzgwOSwKICAicHJvZmlsZUlkIiA6ICI5MGQ1NDY0OGEzNWE0YmExYTI2Yjg1YTg4NTU4OGJlOSIsCiAgInByb2ZpbGVOYW1lIiA6ICJFdW4wbWlhIiwKICAic2lnbmF0dXJlUmVxdWlyZWQiIDogdHJ1ZSwKICAidGV4dHVyZXMiIDogewogICAgIlNLSU4iIDogewogICAgICAidXJsIiA6ICJodHRwOi8vdGV4dHVyZXMubWluZWNyYWZ0Lm5ldC90ZXh0dXJlLzZmMzQ4M2U1NzcyYzkzOTlmYThmMThhOTU4NjI1MGFmOWNmYjYxZDUyZjA4NzEyZjMxMDQxOTJjMTVhN2NlYmMiCiAgICB9CiAgfQp9;p8pKPeM47QsD3NBxPmQYz9JrHY3evv188DmBJrJqZ0YBcJw4w1ur1Nn4ZBjg9zpcGfn7zm6Pk2/Kmlm1MtRuNhAI7yqqWpMn4WDSYuYKAJxqHTNLjVeT/QwoEJUnwi7XxFBCmwoEHTw3utDbisio/M7XMpmt8xCM5EqI8/SoedrIqANzZsaxX8xLb9Pc/7LuRTMLmZ50cIA1hn0P8BoQ0s//3qxRWj0A88a0WYyoQKVChybwVanevsVzWRi55E0Uu5TQ5OCDDOhDu/ooyUYXruVaOqFCxj1d15SCUYifCH1EPIsXeTMbyKbUQ4eHqMQauP5iHhUHKykxpU6Thnmo5D9yIQvplN81+Wpir+t8JJePddpQUzLDnEZLkfCxWelVm1kFxG4HGXzwIz3XH/2DjL2SyisflI074f9AsC2cKVND6sMUGNuoPgnM5ANk0rmVif4FUjDDSvFNdK6dVpymqxWFq6N1jTWjgO5AqBeaQ6jxR4E/A9whWNurWU4oeCuxElwK3toPqUnw49dITOo679goybuhw305O3pB91sWQEKV4laRc00TBJOpfLyb8zQU8jekAuJum3uWi2pI8sqSjbPaLBdb9/xhh7OrvumWo86Ys4hjPsX+AmMhjFy2E0cC6a47NZkyFZ9dEWrD1i6A/uKd7HB1HqURZNeeRgL/JxY=

mask_adriftus_downbad_floyd_equip:
  type: task
  debug: false
  script:
    - flag <player> no_damage
    - adjust <player> walk_speed:0.1
    - wait 10t
    - adjust <player> body_arrows:10

mask_adriftus_downbad_floyd_unequip:
  type: task
  debug: false
  script:
    - flag <player> no_damage:!
    - adjust <player> walk_speed:0.2
    - wait 10t
    - adjust <player> body_arrows:0