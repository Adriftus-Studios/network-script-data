web_handler:
  type: world
  Domains:
    Github: 140.82.115
    self: 0:0:0:0:0:0:0:1
  events:
    after get request:
      - announce to_console "<&6><&lt><&e>context<&6>.<&e>address<&6><&gt> <&b>| <&a>Returns the IP address of the device that sent the request."
      - announce to_console "<&6><&lt><&e>context<&6>.<&e>request<&6><&gt> <&b>| <&a>Returns the path that was requested."
      - announce to_console "<&6><&lt><&e>context<&6>.<&e>query<&6><&gt> <&b>| <&a>Returns an ElementTag of the raw query included with the request."
      - announce to_console "<&6><&lt><&e>context<&6>.<&e>query_map<&6><&gt> <&b>| <&a>Returns a map of the query."
      - announce to_console "<&6><&lt><&e>context<&6>.<&e>user_info<&6><&gt> <&b>| <&a>Returns info about the authenticated user sending the request, if any."
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
