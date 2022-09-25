fishing_event_retrieve_schedule:
  type: world
  debug: false
  events:
    on server start:
      - choose <util.time_now.day_of_week>:
        - case 1:
          - flag server fishbot.daily.fish_time_boost:0.1 expire:24h
          - flag server fishbot.daily.speed_boost:0.1 expire:24h
#        - case 2:
#          - tuesday
        - case 3:
          - flag server fishbot.daily.good_catch_modifier:25 expire:24h
#        - case 4:
#          - thursday
        - case 5:
          - flag server fishbot.daily.attack_chance_modifier:10 expire:24h
        - case 6:
          - if <util.time_now.month> != <server.flag[fishbot.weekend.month]>:
            - flag server fishbot.weekend.month:<util.time_now.month>
            - flag server fishbot.weekend.counter:1
          - define weekend <server.flag[fishbot.weekend.counter]>
          - choose <[weekend]>:
            - case 1:
              - flag server fishbot.daily.catch_increase:0.2 expire:48h
            - case 2:
              - flag server fishbot.daily.item_increase:20 expire:48h
            - case 3:
              - flag server fishbot.daily.item_decrease:20 expire:48h
            - case 4:
              - flag server fishbot.daily.experience_boost:0.3 expire:48h
            - case 5:
              - flag server fishbot.daily.legendary_modifier:10 expire:48h
#        - case 7:
#          - sunday
        - case default:
          - stop
