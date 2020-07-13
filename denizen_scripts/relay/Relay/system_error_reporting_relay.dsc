system_error_reporting:
  type: yaml data
  events:

  #@on script generates error:
  #^  - if <context.script||null> != null:
  #^    - queue <context.queue> stop
  #^    - run discord_sendMessage "def:AGDev|<server.flag[server.name]>|```yaml&nl---------------ERROR---------------&nlScript&co <context.script.name>&nlLine&co <context.line>&nlAction&co Queue Stopped&nlMessage&co <context.message>.&nl-----------------------------------```"


  #@on server generates exception:
  #^  - if <context.queue||null> != null:
  #^    - queue <context.queue> stop
  #^    - run discord_sendMessage "def:AGDev|<server.flag[server.name]>|```yaml&nl---------------ERROR---------------&nlScript&co <context.queue.script.name>&nlType&co <context.type>&nlAction&co Queue Stopped&nlMessage&co <context.message>.&nl-----------------------------------```"
  #^  - else:
  #^    - run discord_sendMessage "def:AGDev|<server.flag[server.name]>|```yaml&nl---------------PLUGIN-ERROR---------------&nlType&co <context.type>&nlAction&co Plugin Error Reported&nlMessage&co <context.message>.&nl------------------------------------------```"
