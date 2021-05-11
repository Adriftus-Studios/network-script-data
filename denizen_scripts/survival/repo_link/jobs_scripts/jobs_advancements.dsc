jobs_advancement_compiler:
  type: task
  debug: true
  definitions: player|job|level
  script:
  ## Used to grant the advancements every X levels from the jobs leveling script.
    - advancement grant:<[player]> id:<[job]>_<[level]>_advancement

jobs_advancement_unloader:
  type: task
  debug: false
  script:
      ##for test/debug purposes only. will remove all advancements it loads on start.
      - advancement delete id:jobs_master_advancement
      - define jobs_list <script[Jobs_data_script].list_keys[jobs_list]>
      - foreach <[jobs_list]> as:job:
        - repeat 10:
            - advancement delete id:<[job]>_<[value]>_advancement
