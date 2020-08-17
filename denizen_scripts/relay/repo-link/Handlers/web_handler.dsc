web_handler:
  type: world
  debug: false
  Domains:
    Github: 140.82.115
    self: 0:0:0:0:0:0:0:1
  events:
    on server start:
      - yaml id:oAuth load:data/global/discord/oAuth_Data.yml
    on get request:
      - if <context.request||invalid> == favicon.ico:
        - stop
      - inject Web_Debug
      - inject Web_Debug.Get_Response

      - choose <context.request>:
        - case /oAuth/GitHub:
        # % ██ [ Cache Data                      ] ██
          - define Code <context.query_map.get[code]>
          - define State <context.query_map.get[state]>
          - define Platform GitHub
          - define Headers <yaml[oAuth].read[Headers].include[<yaml[oAuth].read[GitHub.Token_Exchange.Headers]>]>

        # % ██ [ Token Exchange                  ] ██
          - define URL <yaml[oAuth].read[URL_Scopes.GitHub.Token_Exchange]>
          - define Data <list[oAuth_Parameters|GitHub.Application|GitHub.Token_Exchange.Parameters]>
          - define Data <[Data].parse_tag[<yaml[oAuth].parsed_key[<[Parse_Value]>]>].merge_maps>
          - define Data <[Data].to_list.parse_tag[<[Parse_Value].before[/]>=<[Parse_Value].after[/]>].separated_by[&]>

          - ~webget <[URL]> Headers:<[Headers]> Data:<[Data]> save:response
          - inject Web_Debug.Webget_Response

        # % ██ [ Save Access Token Response Data ] ██
          - define oAuth_Data <entry[response].result.split[&].parse[split[=].limit[2].separated_by[/]].to_map>
          - define Access_Token <[oAuth_Data].get[access_token]>

        # % ██ [ Obtain User Info                ] ██
          - define Headers "<[Headers].include[Authorization/token <[Access_Token]>]>"
          - ~webget https://api.github.com/user Headers:<[Headers]> save:response
          - inject Web_Debug.Webget_Response

        # % ██ [ Save User Data                  ] ██
          - define UserData <util.parse_yaml[{"Data":<entry[Response].result>}].get[Data]>
          - define Login <[UserData].get[login]>
          - define Avatar <[UserData].get[avatar_url]>
          - define ID <[UserData].get[id]>
          - define Creation_Date <[UserData].get[created_at]>

        # % ██ [ Obtain User Repository Info     ] ██
        #^- define Headers "<[Headers].include[Authorization/token <[Access_Token]>]>"
        #^- ~webget https://api.github.com/user/repos Headers:<[Headers]> save:response
        #^- inject Web_Debug.Webget_Response

        #^- define UserData <util.parse_yaml[{<entry[Response].result>}]>

       # % ██ [ Create Fork                      ] ██
        #^- announce to_console "<&c>-Fork Creation --------------------------------------------------------------"
        #^- ~webget https://api.github.com/repos/AuroraInteractive/Telix/forks Headers:<[Headers]> method:POST save:response
        #^- inject Web_Debug.Webget_Response

       # % ██ [ Create Webhook                   ] ██
        #^- announce to_console "<&c>-WebHook Creation --------------------------------------------------------------"
        #^- define Data '{"name": "ATE webhook","config": {"url": "http://76.119.243.194:25580/github/<[User]>/Telix","content-type": "json"}}'
        #^- ~webget https://api.github.com/repos/AuroraInteractive/Telix/forks Headers:<[Headers]> method:POST data:<[Data]> save:response
        #^- inject Web_Debug.Webget_Response

        - case /oAuth/Discord:
        # % ██ [ Cache Data                      ] ██
          - define Code <context.query_map.get[code]>
          - define State <context.query_map.get[state]>
          - define Platform Discord

          - define Headers <yaml[oAuth].read[Headers].include[<yaml[oAuth].read[Discord.Token_Exchange.Headers]>]>
        
          - if !<proc[discord_oauth_validate_state].context[<[state]>]>:
            - stop
          - run discord_oauth_remove_state def:<[state]>
          - determine passively FILE:../../../../web/pages/discord_linked.html

        # % ██ [ Token Exchange                  ] ██
          - define URL <yaml[oAuth].read[URL_Scopes.Discord.Token_Exchange]>
          - define Data <list[oAuth_Parameters|Discord.Application|Discord.Token_Exchange.Parameters]>
          - define Data <[Data].parse_tag[<yaml[oAuth].parsed_key[<[Parse_Value]>]>].merge_maps>
          - define Data <[Data].to_list.parse_tag[<[Parse_Value].before[/]>=<[Parse_Value].after[/]>].separated_by[&]>

          - ~webget <[URL]> Headers:<[Headers]> Data:<[Data]> save:response
          - inject Web_Debug.Webget_Response

        # % ██ [ Save Access Token Response Data ] ██
          - define Access_Token_Response <util.parse_yaml[<entry[response].result>]>
          - define Access_Token <[Access_Token_Response].get[access_token]>
          - define Refresh_Token <[Access_Token_Response].get[refresh_token]>
          - define Expirey <[Access_Token_Response].get[expires_in]>

        # % ██ [ Obtain User Info                ] ██
          - define URL <yaml[oAuth].read[URL_Scopes.Discord.Identify]>
          - define Headers <[Headers].include[<yaml[oAuth].parsed_key[Discord.Client_Credentials.Headers]>]>

          - ~webget <[URL]> headers:<[Headers]> save:response
          - inject Web_Debug.Webget_Response

        # % ██ [ Save User Data                  ] ██
          - define User_Data <util.parse_yaml[<entry[response].result>]>
          - narrate "<&c>User_Data: <&2><[User_Data]>"
          - define User_ID <[User_Data].get[id]>
          - define Avatar https://cdn.discordapp.com/avatars/<[User_ID]>/<[User_Data].get[avatar]>

        # % ██ [ Obtain User Connections         ] ██
          - define URL <yaml[oAuth].read[URL_Scopes.Discord.Connections]>
          - ~webget <[URL]> headers:<[Headers]> save:response
          - inject Web_Debug.Webget_Response

          - define User_Data <util.parse_yaml[{"Data":<entry[response].result>}].get[Data]>
        # % ██ [ WebGet Hosting         ] ██
        - case /webget:
          - if <server.has_file[../../../../web/webget/<context.query_map.get[name]||invalid>]>:
            - determine FILE:../../../../web/webget/<context.query_map.get[name]>
          - else:
            - determine CODE:404
        # % ██ [ FavIcon         ] ██
        - case /favicon.ico:
          - determine FILE:../../../../web/favicon.ico
        # % ██ [ CSS Hosting         ] ██
        - case /css:
          - if <server.has_file[../../../../web/css/<context.query_map.get[name]||invalid>.css]>:
            - determine FILE:../../../../web/css/<context.query_map.get[name]>.css
        # % ██ [ Webpages         ] ██
        - case /page:
          - if <server.has_file[../../../../web/pages/<context.query_map.get[name]||invalid>.html]>:
            - determine FILE:../../../../web/pages/<context.query_map.get[name]>.html
        # % ██ [ Images         ] ██
        - case /image:
          - if <server.has_file[../../../../web/images/<context.query_map.get[name]||invalid>]>:
            - determine FILE:../../../../web/images/<context.query_map.get[name]>
          

    on post request:
      - define Domain <context.address>
      - if <[Domain].starts_with[<script.data_key[Domains.Github]>]>:
        - define Map <util.parse_yaml[{"Data":<context.query>}].get[Data]>
        - if <[Map].get[ref]> != refs/heads/master && <[Map].get[repository].get[full_name]> != AuroraInteractive/network-script-data:
          - stop

        - define Request <context.request.after[github/]>
        - define Script ../network-script-data/system_scripts/github/git-pull
        - shell <[Script]> <[Request]>
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
        - inject Web_Debug.Post_Request
        - announce to_console "Attempted request from <[Domain]>"

Web_Debug:
  type: task
  debug: false
  script:
    - debug record start
  Get_Response:
    - announce to_console <&3>----------------------------------------------
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>address<&6><&gt> <&b>| <&3><context.address||<&4>Invalid> <&b>| <&a>Returns the IP address of the device that sent the request."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>request<&6><&gt> <&b>| <&3><context.request||<&4>Invalid> <&b>| <&a>Returns the path that was requested."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>query<&6><&gt> <&b>| <&3><context.query||<&4>Invalid> <&b>| <&a>Returns an ElementTag of the raw query included with the request."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>query_map<&6><&gt> <&b>| <&3><context.query_map||<&4>Invalid> <&b>| <&a>Returns a map of the query."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>user_info<&6><&gt> <&b>| <&3><context.user_info||<&4>Invalid> <&b>| <&a>Returns info about the authenticated user sending the request, if any."
    - announce to_console <&3>----------------------------------------------
  Post_Request:
    - announce to_console <&3>----------------------------------------------
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>address<&6><&gt> <&b>| <&3><context.address||<&c>Invalid> <&b>| <&a>Returns the IP address of the device that sent the request."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>request<&6><&gt> <&b>| <&3><context.request||<&c>Invalid> <&b>| <&a>Returns the path that was requested."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>query<&6><&gt> <&b>| <&3><context.query||<&c>Invalid> <&b>| <&a>Returns a ElementTag of the raw query included with the request."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>query_map<&6><&gt> <&b>| <&3><context.query_map||<&c>Invalid> <&b>| <&a>Returns a map of the query."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>user_info<&6><&gt> <&b>| <&3><context.user_info||<&c>Invalid> <&b>| <&a>Returns info about the authenticated user sending the request, if any."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>upload_name<&6><&gt> <&b>| <&3><context.upload_name||<&c>Invalid> <&b>| <&a>returns the name of the file posted."
  #^- announce to_console "<&6><&lt><&e>context<&6>.<&e>upload_size_mb<&6><&gt> <&b>| <&3><context.upload_size_mb||<&c>Invalid> <&b>| <&a>returns the size of the upload in MegaBytes (where 1 MegaByte = 1 000 000 Bytes)."
    - announce to_console <&3>----------------------------------------------
  Webget_Response:
    - announce to_console <&3>----------------------------------------------
    - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>failed<&6><&gt> <&b>| <&3><entry[response].failed||<&c>Invalid> <&b>| <&a>returns whether the webget failed. A failure occurs when the status is no..."
    - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>result<&6><&gt> <&b>| <&3><entry[response].result||<&c>Invalid> <&b>| <&a>returns the result of the webget. This is null only if webget failed to connect to the url."
    - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>status<&6><&gt> <&b>| <&3><entry[response].status||<&c>Invalid> <&b>| <&a>returns the HTTP status code of the webget. This is null only if webget failed to connect to the url."
    - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>time_ran<&6><&gt> <&b>| <&3><entry[response].time_ran||<&c>Invalid> <&b>| <&a>returns a DurationTag indicating how long the web connection processing took."
    - announce to_console <&3>----------------------------------------------
  Submit:
    - ~debug record submit save:mylog
    - announce to_console <entry[mylog].submitted||<&4>Debug_Failure>
