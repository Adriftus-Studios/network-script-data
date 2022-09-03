reload_all_scripts:
  type: task
  debug: false
  script:
    - announce "<&c>Server is being updated, there will be a large lag spike in 10 seconds."
    - wait 10s
    - reload