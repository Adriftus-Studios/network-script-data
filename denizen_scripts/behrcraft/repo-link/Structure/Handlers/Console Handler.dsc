Console_Handler:
    type: world
    debug: false
    events:
        on server start:
            - adjust system redirect_logging:true

        on reload scripts:
            - if <server.match_offline_player[behr_].is_online>:
                - if <context.had_error>:
                    - narrate targets:<server.match_player[behr_riley]> "<&c>Reload Error"
                - else:
                    - narrate targets:<server.match_player[behr_riley]> <&a>Reloaded
 
        on script generates error:
            - if "<context.message.contains_any_text[list_flags|{ braced } command format|'&dot' or '&cm']>":
                - determine cancelled
            - if <context.queue.contains[EXCOMMAND_]||false>:
                - stop

            - if <server.match_offline_player[behr_riley].is_online>:
                - if <queue.exists[<context.queue.id||null>]>:
                    - define Hover0 "<&c>Click to Kill Queue<&4><&nl><context.queue.id>"
                    - define Text0 <&c>[<&4><&chr[2716]><&c>]<&r><&sp>
                    - define Command0 "queuekill <context.queue.id>"
                    - define QK <proc[MsgCmd].context[<[Hover0]>|<[Text0]>|<[Command0]>]>
                - define Hover  "<&e>in <&c><context.queue.script.relative_filename||null><&e><&nl><context.message||null>"
                - define Text "<&4>Script Error<&co> <&c><context.queue.script.name||null> <&e>on line<&6>: <&4>[<&c><context.line||unknown><&4>]"
                - narrate targets:<server.match_player[behr_riley]> <[QK]||><proc[MsgHover].context[<[Hover]>|<[Text]>]>

        on server generates exception:
            - if <server.match_offline_player[behr_].is_online>:
                - if <context.queue.contains[EXCOMMAND_]||false>:
                    - stop
                - narrate targets:<server.match_player[behr_riley]> "<&4>Server generated exception<&co> <&c><context.type>"
