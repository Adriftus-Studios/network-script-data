time_Command:
  type: command
  name: time
  debug: false
  description: Changes the time of day
  usage: /time <&lt>time of day/0-23999<&gt>
  permission: behr.essentials.time
  tab completions:
    1: start|day|noon|sunset|bedtime|dusk|night|midnight|sunrise|dawn
  script:
  # % ██ [ Check Args ] ██
    - if <context.args.is_empty>:
      - narrate "<&a>The current world time of day is <player.world.time>"
      - stop

  # % ██ [ Check if Arg is a number ] ██
    - else if <context.args.first.is_integer>:
      - define time <context.args.first>

    # % ██ [ Check if number is a valid number for usage ] ██
      - if <[time]> < 0:
        - narrate "<&c>Time cannot be negative"
        - stop

      - if <[time]> >= 24000:
        - narrate "<&c>Time cannot exceed 23999"
        - stop

      - if <[time].contains[.]>:
        - narrate "<&c>Time cannot contain decimals"
        - stop

      - time <[time]>t
      - define time_name <[time]>
      - narrate "Time set to <[time]>"

  # % ██ [ Match time with time of day by name ] ██
    - else:
      - define Arg <context.args.first>
      - choose <[Arg]>:
        - case start:
          - time 0
          - define name Start

        - case day:
          - time 1000t
          - define name Day

        - case noon:
          - time 6000t
          - define name Noon

        - case sunset:
          - time 11615t
          - define name Sunset

        - case bedtime:
          - time 12542t
          - define name Bedtime

        - case dusk:
          - time 12786t
          - define name Dusk

        - case night:
          - time 13000t
          - define name Night

        - case midnight:
          - time 18000t
          - define name Midnight

        - case sunrise:
          - time 22200t
          - define name Sunrise

        - case dawn:
          - time 23216t
          - define name Dawn

        - default:
          - inject Command_Syntax

      - narrate "<&a>Time set to <[name]>"
