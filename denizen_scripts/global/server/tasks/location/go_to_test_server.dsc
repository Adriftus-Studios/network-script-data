go_to_test_server:
  type: task
  debug: false
  script:
    - determine passively cancelled
    - flag player "temp.leave_message:<player.name> has disappeared into a tiny house."
    - adjust <player> send_to:test