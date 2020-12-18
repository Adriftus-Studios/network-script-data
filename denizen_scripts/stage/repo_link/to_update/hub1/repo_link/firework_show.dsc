firework_show:
  type: command
  name: firework_show
  description: Launches a firework show.
  usage: /firework_show
  permission: adriftus.admin
  script:
    - define locations <player.location.find.surface_blocks.within[15].parse[above]>
    - define colors <list[red|blue|green|yellow|purple|orange]>
    - repeat 120:
      - choose <util.random.int[1].to[4]>:
        - case 1:
          - firework <[locations].random> power:<util.random.decimal[1].to[3]> random primary:<[colors].random> fade:<[colors].random>
        - case 2:
          - firework <[locations].random> power:<util.random.decimal[1].to[3]> random primary:<[colors].random> fade:<[colors].random> trail
        - case 3:
          - firework <[locations].random> power:<util.random.decimal[1].to[3]> random primary:<[colors].random> fade:<[colors].random> flicker trail
        - case 4:
          - firework <[locations].random> power:<util.random.decimal[1].to[3]> random primary:<[colors].random> fade:<[colors].random> flicker
      - wait 1s
