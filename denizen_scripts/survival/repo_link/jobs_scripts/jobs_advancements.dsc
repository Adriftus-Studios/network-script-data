jobs_advancements_vscode_error_silencer:
  type: task
  script:
  - define player shaddup
  - inject jobs_advancement_compiler

jobs_advancement_compiler:
  type: task
  debug: true
  script:
    - advancement grant:<[player]> id:<[job]>_<[level]>_advancement

jobs_advancement_loader:
  type: world
  debug: true
  events:
      on server prestart:
      - advancement create id:jobs_master_advancement icon:dried_kelp title:Jobs "description:<&6>Earned by claiming your first job." y:0
      - define jobs_list <list[blacksmith|brewer|lumberjack|miner|farmer|enchanter|hunter|chef|archaeologist|fisher]>
      - define y_value 0
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
        - define y_value <[y_value].add[1]>

jobs_advancement_unloader:
  type: task
  debug: false
  script:
#    on server prestart:
      - advancement delete id:jobs_master_advancement
      - define jobs_list <list[blacksmith|brewer|lumberjack|miner|farmer|enchanter|hunter|chef|archaeologist|fisher]>
      - foreach <[jobs_list]> as:job:
        - repeat 10:
            - advancement delete id:<[job]>_<[value]>_advancement

#jobs_advancement_data:
#1             3
#              Fa
#              Lu
#              Mi
#              Ch
#              Br
#First job     Total
#              Ar
#              Bl
#              Fi
#              Hu
#              En




