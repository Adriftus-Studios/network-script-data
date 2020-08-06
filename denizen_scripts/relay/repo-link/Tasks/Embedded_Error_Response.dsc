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
    - define map <map.with[Color].as[red].with[Description].as[<[Description]>].with[Syntax].as[<[Syntax]>].with[Context].as[<[Context]>].with[Footer].as[<[Footer]>]>
    - run Embedded_Discord_Message def:<list[Command_Error_Support_Syntax_Context1|<[Channel]>].include_single[<[Map]>]>
    - stop
