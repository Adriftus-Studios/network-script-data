jobs_exp_adding:
  type: task
  debug: false
  script:
  - define player_job_level <[player].flag[jobs.<[job]>.level]>
  ##Stops exp gain over level 100
  - if <[player_job_level]> > 100:
      - stop
  ##Checks if the player exp is greater than whats required to level
  - if <script[Jobs_data_script].data_key[exp_per_level.<[player_job_level]>].sub[<[player].flag[jobs.<[job]>.experience_earned]>].sub[<[total_experience]>]> > 0:
    - flag <[player]> jobs.<[job]>.experience_earned:<[player].flag[jobs.<[job]>.experience_earned].add[<[total_experience]>]>
    ##if player is online, displays a bossbar for 5s then removes it
    - if <[player].is_online>:
      - define bossbar_name <[player]>_<[job]>_level_progress_<util.random.duuid>
      - bossbar create <[bossbar_name]> players:<[player]> progress:<[player].flag[jobs.<[job]>.experience_earned].div[<script[Jobs_data_script].data_key[exp_per_level.<[player_job_level]>]>]> "Title:<&e><[Job].to_titlecase> <&6>progress<&co> <&b><[player].flag[jobs.<[job]>.experience_earned].round_down><&6>/<&3><script[Jobs_data_script].data_key[exp_per_level.<[player_job_level]>]>" color:blue style:segmented_20
      - wait 100t
      - bossbar remove <[bossbar_name]>
  ##if the player is able to level, increases the level flag,
  ##injects the level up task for achievements and work stations,
  ##re-loops through the exp addition in case they level more than once.
  - else:
    - define total_experience <[total_experience].sub[<script[Jobs_data_script].data_key[exp_per_level.<[player_job_level]>].sub[<[player].flag[jobs.<[job]>.experience_earned]>]>]>
    - wait 1t
    - flag <[player]> jobs.<[job]>.level:++
    - flag <[player]> jobs.<[job]>.experience_earned:0
    - inject jobs_level_up_event
    - inject jobs_exp_adding

jobs_level_up_event:
  type: task
  debug: false
  script:
    ##if the player is online, narrates/toasts, plays a firework effect around them
    - if <[player].is_online>:
      - toast targets:<[player]> "<&6>Level Up! <&e><[job].to_titlecase><&6><&co><&e><[player].flag[jobs.<[job]>.level]>" icon:<script[Jobs_data_script].data_key[<[job]>.icon]> frame:goal
      - narrate targets:<[player]> "<&6>Congratulations, you've just increased your <&e><[job].to_titlecase><&6> level! <&nl><&6>Your <&e><[job].to_titlecase><&6> is now level <&e><[player].flag[jobs.<[job]>.level]><&6>."
      - repeat 3 as:f:
        - repeat <[f]>:
          - define fade <color[255,0,0].with_hue[<util.random.int[1].to[255]>]>
          - define primary <color[255,0,0].with_hue[<util.random.int[1].to[255]>]>
          - firework <[player].location.find.surface_blocks.within[4].random> random trail primary:<[primary]> fade:<[fade]> power:<util.random.int[0].to[3]>
          - wait <[f]>t
      ##fires the advancement task for the given multiple of 10
      - if <[player].flag[jobs.<[job]>.level].mod[10]> == 0:
        - define level <[player].flag[jobs.<[job]>.level].div[10]>
        - inject jobs_advancement_compiler
    ##if offline, flags the player to recieve their advancement on their next join.
    - if !<[player].is_online>:
      - if <[player].flag[jobs.<[job]>.level].mod[10]> == 0:
        - flag <[player]> jobs.advancement_due:->:<[job]>~<[level]>
    ##gives the player an increased workstation count if their level is a multiple of 50
    - if <[player].flag[jobs.<[job]>.level].mod[50]> == 0:
      - flag <[player]> jobs.blocks_allowed:++

