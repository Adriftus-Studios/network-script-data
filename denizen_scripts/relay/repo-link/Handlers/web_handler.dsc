web_handler:
  type: world
  Domains:
    Github: 140.82.115
    self: 0:0:0:0:0:0:0:1
  events:
    after get request:
      - announce to_console "<&6><&lt><&e>context<&6>.<&e>address<&6><&gt> <&b>| <&3><context.address> <&b>| <&a>Returns the IP address of the device that sent the request."
      - announce to_console "<&6><&lt><&e>context<&6>.<&e>request<&6><&gt> <&b>| <&3><context.request> <&b>| <&a>Returns the path that was requested."
      - announce to_console "<&6><&lt><&e>context<&6>.<&e>query<&6><&gt> <&b>| <&3><context.query> <&b>| <&a>Returns an ElementTag of the raw query included with the request."
      - announce to_console "<&6><&lt><&e>context<&6>.<&e>query_map<&6><&gt> <&b>| <&3><context.query_map> <&b>| <&a>Returns a map of the query."
      - announce to_console "<&6><&lt><&e>context<&6>.<&e>user_info<&6><&gt> <&b>| <&3><context.user_info> <&b>| <&a>Returns info about the authenticated user sending the request, if any."

      - announce to_console <&3>----------------------------------------------
      - if <context.request> != /oAuth/Discord:
        - stop

      - define Code <context.query_map.get[code]>
      - define UUID <context.query_map.get[state]>

    #^- define Headers <list[user-agent/behrrison|application/x-www-form-urlencoded]>
      - define Headers <yaml[discord_response].read[Headers]>
      - define URL <yaml[discord_response].read[URL]>
      - define data <yaml[discord_response].parsed_key[Response]>

      - announce to_console <&3>----------------------------------------------
      - announce to_console "<&6><&lt>[<&e>Headers<&6>]<&gt> <&b> <[Headers]>"
      - announce to_console "<&6><&lt>[<&e>URL<&6>]<&gt> <&b> <[URL]>"
      - announce to_console "<&6><&lt>[<&e>data<&6>]<&gt> <&b> <[data]>"

      - ~webget <[URL]> Headers:<[Headers]> Data:<[Data].to_json> save:response

      - announce to_console <&3>----------------------------------------------
      - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>failed<&6><&gt> <&b>| <&3><entry[response].failed> <&b>| <&a>returns whether the webget failed. A failure occurs when the status is no..."
      - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>result<&6><&gt> <&b>| <&3><entry[response].result> <&b>| <&a>returns the result of the webget. This is null only if webget failed to connect to the url."
      - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>status<&6><&gt> <&b>| <&3><entry[response].status> <&b>| <&a>returns the HTTP status code of the webget. This is null only if webget failed to connect to the url."

    after post request:
      - define Domain <context.address>
      - define Context "**<&lt>context.address<&gt>**: `<context.address>`<&nl>**<&lt>context.query<&gt>**: `<context.query>`"
      - discord id:adriftusbot message channel:626098849127071746 <[Context]>
      - announce to_console <[Context]>
      - if <[Domain].starts_with[<script.data_key[Domains.Github]>]>:
        - announce to_console success

        - define Request <context.request.after[github/]>
        - define Script ../network-script-data/system_scripts/github/git-pull

        - shell <[Script]> <[Request]>
        - announce to_console "Webhook received!"
        - announce to_console "Script ran: <[script]>"
        - announce to_console "Request received: <[request]>"

        - define Hook <script[DDTBCTY].data_key[WebHooks.650016499502940170.hook]>
        - define data <yaml[webhook_template_git-pull].to_json>
        - define headers <list[User-Agent/really|Content-Type/application/json]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
      - else if <[domain]> == <script.data_key[Domains.self]>:
        - bungee <bungee.list_servers.exclude[<bungee.server>]>:
          - reload
        - wait 1t
        - reload
      - else:
        - announce to_console "Attempted request from <[Domain]>"
