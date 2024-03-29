mask_encanto_isabella:
  type: data
  display_data:
    category: Encanto
    material: allium
    display_name: <&b>Encanto<&co> <&d>Isabella
    description: "<&d>Isabella<&e> from <&6>Encanto"
  mask_data:
    id: encanto_isabella
    display_name: <&d>Isabella
    skin_blob: ewogICJ0aW1lc3RhbXAiIDogMTY0MjA2MzgxMjEzMCwKICAicHJvZmlsZUlkIiA6ICJhYjlkYmMzZjk4NGE0ZWI4YTVmY2RlYWMzNzEzZWFkMSIsCiAgInByb2ZpbGVOYW1lIiA6ICJDeWJvcm51dDIiLAogICJzaWduYXR1cmVSZXF1aXJlZCIgOiB0cnVlLAogICJ0ZXh0dXJlcyIgOiB7CiAgICAiU0tJTiIgOiB7CiAgICAgICJ1cmwiIDogImh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYTk4MWRjMWI2NmJjMjg2M2ZlNDBmYTlmZGYwNWNkOWI3OGI4YmZiZjQ5NmE1N2Q0MzZlZGE5MjFmNGY0NWI0NSIsCiAgICAgICJtZXRhZGF0YSIgOiB7CiAgICAgICAgIm1vZGVsIiA6ICJzbGltIgogICAgICB9CiAgICB9CiAgfQp9;rZbtmoEnDxfeFcPSlKWVoI5NszMl8dcwr3p0IQUtSQtn7bXpFL5nnd+GVwaY5MYzqNKvlFAvaFqnqUY0amirZ1vbnHoGKrawOvcfk0uShLeRkm7VgDt7Y6MPrukYClDhBpYYkxs2weYwcsrxV4O6jzj4ENzHlixM/HCQ9wZt+8fCLXzpeua/uV467yA132vsbXpdkSrbhC72ZTWjXE6QzN9cCbnvmOqaKHMtUpk598GVxZj/t6ZyOYj20KAXBF/SYitC8W2BCzA+E62k30I552hlQKhJhOzssG4/jVGjte5Ljki/HxFCztl+VdvU9vExOwZwexUJ4sP1BYf1aR4HxRZmwyLqjj9M+SVSieHfaQ+CuMDIq4aTOt8gd6Or34ZfV04MY6uFBBsggjYG1NowQZZb2y8YjnFS2+5GWY4kkHq7zaodncVprIj5fV34CZuz3NUq15EKXUlRy366/QEL9WHr/ETOb6PLqGbKu8fz586lCggHU9FjB9F5pH+r47mJciCsqtY78Py1Q72pGVRWTa9o7FdCZmI8+1FXHXgk8IMcoz2tMwSAOlN2uHEdylh7ZKZ8V8qkV3/x51iS75vfrcVOIFRGfRqD31pGnFuOu+5V1zhAQDsjXhSn7i9dBhgpSJ+jiYIsfcCNhaKvR2pRSjCGwmehrIu0g4AZOvAM96g=
    ability:
      task: mask_encanto_isabella_vines

mask_encanto_isabella_vines:
  type: task
  debug: false
  script:
    - define target <player.eye_location.precise_cursor_on>
    - define vector <[target].sub[<player.location>].normalize.mul[0.5]>
    - define target <[target].sub[<[vector]>]>
    - define points <player.eye_location.points_between[<[target]>].distance[0.3]>
    - define players <player.location.find_players_within[60]>
    - foreach <[points]>:
      - playeffect effect:TOTEM quantity:3 offset:0.25 at:<[value]> targets:<[players]>
    - define this_block <[target]>
    - while <[this_block].material.name> == air:
      - modifyblock <[this_block]> vine
      - playeffect effect:TOTEM quantity:3 offset:0.25 at:<[this_block]> targets:<[players]>
      - wait 5t
      - define this_block <[this_block].below>
