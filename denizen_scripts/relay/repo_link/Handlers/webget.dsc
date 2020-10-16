WebGet_Handler:
  type: world
  events:
    on script generates error:
      - if <context.script.name||invalid> == Webget_DCommand && <server.has_flag[WebGet.Log_Queue]> && <server.flag[WebGet.Log_Queue]> == <context.queue||invalid>:
        - determine passively cancelled
        - flag server WebGet.Log_Queue:!
        - flag server WebGet.Log_Response:<context.message>
        - narrate "<&6><&lt>context<&6>.<&e>message<&6><&gt> <&3>| <&3><context.message>"
