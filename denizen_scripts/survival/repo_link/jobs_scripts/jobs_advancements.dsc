jobs_advancement_compiler:
  type: task
  debug: true
  script:
    - advancement grant:<[player]> id:<[job]>_<[level]>_advancement

jobs_advancement_unloader:
  type: task
  debug: false
  script:
#    on server prestart:
      - advancement delete id:jobs_master_advancement
      - define jobs_list <script[Jobs_data_script].list_keys[jobs_list]>
      - foreach <[jobs_list]> as:job:
        - repeat 10:
            - advancement delete id:<[job]>_<[value]>_advancement
