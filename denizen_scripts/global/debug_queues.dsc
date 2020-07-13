queue_report:
  type: command
  name: queue_report
  permission: not.a.perm
  script:
    - foreach <server.list_scripts> as:script:
      - if <[script].list_queues.size> != 0:
        - narrate "<&e><[script].name><&co><&sp><[script].list_queues.size>"