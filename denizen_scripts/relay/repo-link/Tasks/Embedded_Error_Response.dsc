Embedded_Error_Response:
  type: task
  definitions: Message|Channel|Author|Group
  debug: false
  Context: Color
  speed: 0
  script:
    - define Description "Command: `/Reload` | Reloads a server's scripts."
    - define Syntax "/Reload <&lt>Server<&gt>/All"
    - define Context <bungee.list_servers.parse[To_Titlecase].include[All].comma_separated>
    - define Footer "You typed: <[Message]>"
    - run Embedded_Discord_Message def:Command_Error_Support_Syntax_Context1|<[Channel]>|<list[Color/red|Description/<[Description].escaped>|Syntax/<[Syntax].escaped>|Context/<[Context].escaped>|Footer/<[Footer].escaped>].escaped>
    - stop
