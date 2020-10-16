QueueKill_command:
    type: command
    name: queuekill
    description: Kills a named queue, or lists queues to kill.
    usage: /queuekill (QueueID)
    permission: behrry.essentials.queuekill
    debug: false
    tab complete:
        - if <context.args.size> == 0:
            - determine <queue.list.parse[id].exclude[<queue.id>]||>
        - else if <context.args.size> == 1 && !<context.raw_args.ends_with[<&sp>]>:
            - determine <queue.list.parse[id].exclude[<queue.id>].filter[starts_with[<context.args.last>]]||>
    script:
        - if <context.args.size> > 1:
            - inject Command_Syntax Instantly

        - if <queue.list.size> == 1:
            - narrate "<&c>No active queues."
            - stop

        - if <context.args.size> == 0:
            - foreach <queue.list.exclude[<queue>]> as:Queue:
                - define Hover "<&c>Click to kill Queue<&4>:<&nl><&a><[Queue].id><&nl><&e>Script<&6>: <&a><queue.script><&nl><&e>File<&6>: <&a><queue.script.filename>"
                - define Text "<&c>[<&4><&chr[2716]><&c>]<&e> <[Queue].id>"
                - define Command "QueueKill <[Queue].id>"
                - narrate <proc[msg_cmd].context[<[Hover]>|<[Text]>|<[Command]>]>
        - else:
            - if !<queue.exists[<context.args.first>]>:
                - narrate "<&c>Queue has ended or does not exist."
                - stop
            - narrate "<&e>Killing Queue<&6>: <&a><queue.list.exclude[<queue>].first>"
            - queue <queue[<context.args.first>]> stop
