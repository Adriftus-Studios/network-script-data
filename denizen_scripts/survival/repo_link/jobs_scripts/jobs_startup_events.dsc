server_double_xp_setting:
  type: world
  debug: false
  events:
    on server start:
      ##Flags the server to have a weekend jobs boost, then triggers the server to calculate the boost rate
      - if <util.time_now.day_of_week> == 6:
        - flag server jobs.weekend_boost:2 duration:48h
        - wait 10t
      - inject server_jobs_reward_multiplier

jobs_advancement_loader:
  type: world
  debug: true
  events:
      on server prestart:
      ##Creates the base advancement
      - advancement create id:jobs_master_advancement icon:dried_kelp title:Jobs "description:<&6>Earned by claiming your first job." y:0
      - define jobs_list <script[Jobs_data_script].list_keys[jobs_list]>
      - define y_value 0
      ##Loops through the jobs list creating advancements for each job in multiples of 10
      - foreach <[jobs_list]> as:job:
        - repeat 10:
          - if <[value]> == 1:
            - advancement create id:<[job]>_<[value]>_advancement icon:<script[Jobs_data_script].data_key[<[job]>.icon]> parent:jobs_master_advancement x:<[value].add[1]> y:<[y_value]>  "title:<&6>Level <&e><[value]>0 <[job].to_titlecase><&6>!" "description:<&6>Earned by reaching level <&e><[value]>0<&6> in this profession." hidden: true
            - repeat next
          - if <[value]> == 5:
            - advancement create id:<[job]>_<[value]>_advancement icon:<script[Jobs_data_script].data_key[<[job]>.icon]> parent:<[job]>_<[value].sub[1]>_advancement x:<[value].add[1]> y:<[y_value]> "title:<&6>Level <&e><[value]>0 <[job].to_titlecase><&6>!" "description:<&6>Earned by reaching level <&e><[value]>0<&6> in this profession." frame:goal hidden:true
            - repeat next
          - if <[value]> == 10:
             - advancement create id:<[job]>_<[value]>_advancement icon:<script[Jobs_data_script].data_key[<[job]>.icon]> parent:<[job]>_<[value].sub[1]>_advancement x:<[value].add[1]> y:<[y_value]> "title:<&6>Level <&e><[value]>0 <[job].to_titlecase><&6>!" "description:<&6>Earned by reaching level <&e><[value]>0<&6> in this profession." frame:challenge hidden:true
             - repeat next
          - else:
            - advancement create id:<[job]>_<[value]>_advancement icon:<script[Jobs_data_script].data_key[<[job]>.icon]> parent:<[job]>_<[value].sub[1]>_advancement x:<[value].add[1]> y:<[y_value]> "title:<&6>Level <&e><[value]>0 <[job].to_titlecase><&6>!" "description:<&6>Earned by reaching level <&e><[value]>0<&6> in this profession." hidden:true
            - repeat next
        ##moves the location down by 1 each job
        - define y_value <[y_value].add[1]>
