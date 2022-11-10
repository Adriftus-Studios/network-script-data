new_player_protections:
  type: world
  debug: false
  events:
    on player dies bukkit_priority:lowest priority:-1 flagged:newbie:
      - if <player.mcmmo.level> > 500 || <duration[<player.statistic[PLAY_ONE_MINUTE]>t]> > <duration[20h]>:
        - flag <player> newbie:!
        - stop
      - determine passively cancelled
      - flag player last_location:<player.location>
      - ratelimit <player> 1t
      - teleport <server.worlds.first.spawn_location>
      - title title:<&f><&font[adriftus:overlay]><&chr[1004]><&chr[F801]><&chr[1004]> fade_in:10t stay:2s fade_out:2s "subtitle:<&a>You have been saved from death"
      - narrate "<&a>- <&b>New Player Protection <&a>-"
      - narrate "<&a>You have been saved from death"
    on player damages player:
      - if <context.entity.entity_type> == player && <context.damager.has_flag[newbie]>:
        - flag <context.damager> newbie:!
        - narrate "<&a>- <&b>New Player Protection <&a>-" targets:<context.damager>
        - narrate "     <&c>De-activated" targets:<context.damager>
        - narrate "<&e>you have entered PVP combat." targets:<context.damager>
        - narrate 
    on player damaged bukkit_priority:lowest priority:-1 flagged:newbie:
      - if <player.mcmmo.level> > 500 || <duration[<player.statistic[PLAY_ONE_MINUTE]>t]> > <duration[20h]>:
        - flag <player> newbie:!
        - stop
      - determine <context.final_damage.div[2].round> if:<context.damager.script.exists.not>
    after mcmmo player levels up skill flagged:newbie:
      - if <player.mcmmo.level> >= 500 || <duration[<player.statistic[PLAY_ONE_MINUTE]>t]> > <duration[20h]>:
        - flag player newbie:!
        - narrate "<&a>- <&b>New Player Protection <&a>-"
        - narrate "     <&c>De-activated"
        - narrate "<&e>you are above power level 500"
    after mcmmo player levels down skill:
      - stop if:<duration[<player.statistic[PLAY_ONE_MINUTE]>t].is_more_than[<duration[20h]>]>
      - if <player.mcmmo.level> < 500:
        - flag player newbie
        - narrate "<&a>- <&b>New Player Protection <&a>-"
        - narrate "     <&6>Activated!"
        - narrate "<&e>you are below power level 500"
    after player joins:
      - wait 3s
      - if <player.mcmmo.level> > 500 || <duration[<player.statistic[PLAY_ONE_MINUTE]>t].in_hours> > <duration[20h].in_hours>:
        - flag player newbie:!
      - else:
        - flag player newbie
