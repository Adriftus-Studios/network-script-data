web_handler:
  type: world
  debug: true
  Domains:
    Github: 140.82.115
    self: 0:0:0:0:0:0:0:1
  temp:
    - if <yaml.list.contains[discord_links]>:
      - yaml id:discord_links unload
    - if !<server.has_file[data/global/discord/discord_links.yml]>:
      - yaml id:discord_links create
      - yaml id:discord_links savefile:data/global/discord/discord_links.yml
    - else:
      - yaml id:discord_links load:data/global/discord/discord_links.yml
    - if !<server.has_file[data/global/discord/github_links.yml]>:
      - yaml id:github_links create
      - yaml id:github_links savefile:data/global/discord/github_links.yml
    - else:
      - yaml id:github_links load:data/global/discord/github_links.yml
  events:
    on reload scripts:
      - inject locally temp
    on server start:
      - web start port:25580
      - inject locally temp
    on get request:
      - announce to_console "<&c>--- get request ----------------------------------------------------------"
      - inject Web_Debug.Get_Response
      - define query <context.query_map>

      - choose <context.request>:
        - case /oAuth/GitHub:
        # % ██ [ Cache Data                      ] ██
          - define Code <context.query_map.get[code]>
          - define State <context.query_map.get[state]>
          - define discord_id <[state].before[_]>
          - define Platform GitHub
          - define Headers <yaml[oAuth].read[Headers].include[<yaml[oAuth].read[GitHub.Token_Exchange.Headers]>]>

        # % ██ [ Token Exchange                  ] ██
          - define URL <yaml[oAuth].read[URL_Scopes.GitHub.Token_Exchange]>
          - define Data <list[oAuth_Parameters|GitHub.Application|GitHub.Token_Exchange.Parameters]>
          - define Data <[Data].parse_tag[<yaml[oAuth].parsed_key[<[Parse_Value]>]>].merge_maps>
          - define Data <[Data].to_list.parse_tag[<[Parse_Value].before[/]>=<[Parse_Value].after[/]>].separated_by[&]>

          - ~webget <[URL]> Headers:<[Headers]> Data:<[Data]> save:response
          - announce to_console "<&c>--- Token Exchange ----------------------------------------------------------"
          - inject Web_Debug.Webget_Response
          - if <entry[response].failed>:
            - announce to_console "<&c>failed to token exchange"
            - stop
          - flag server Test.GitHub.TokenExchange:<util.parse_yaml[{"Data":<entry[Response].result>}].get[Data]>
          #| notable error: error=bad_verification_code&error_description=The+code+passed+is+incorrect+or+expired.&error_uri=https%3A%2F%2Fdocs.github.com%2Fapps%2Fmanaging-oauth-apps%2Ftroubleshooting-oauth-app-access-token-request-errors%2F%23bad-verification-code
          #| occurs when refreshing the page / using a bad token

        # % ██ [ Save Access Token Response Data ] ██
          - define oAuth_Data <entry[response].result.split[&].parse[split[=].limit[2].separated_by[/]].to_map>
          - define Access_Token <[oAuth_Data].get[access_token]>

        # % ██ [ Obtain User Info                ] ██
          - define headers "<[headers].include[Authorization/token <[Access_Token]>]>"
          - ~webget https://api.github.com/user Headers:<[Headers]> save:response
          - announce to_console "<&c>--- Obtain User Info ----------------------------------------------------------"
          - inject web_debug.webget_response
          - if <entry[response].failed>:
            - announce to_console "<&c>Failure to Obtain User Info"
            - stop
          
        # % ██ [ Verify Discord Link             ] ██
          - if !<yaml[discord_links].contains[discord_ids.<[discord_id]>]>:
            - announce to_console "User does not have discord linked."
            - stop

        # % ██ [ Save User Data                  ] ██
          - define user_data <util.parse_yaml[{"data":<entry[response].result>}].get[data]>
          - define login <[user_data].get[login]>
          - define avatar_url <[user_data].get[avatar_url]>
          - define id <[user_data].get[id]>
          - define created_at <time[<[user_data].get[created_at].replace[-].with[/].before[Z].split[T].separated_by[_]>]>

        # % ██ [ Send to The-Network             ] ██
          - define url http://76.119.243.194:25580
          - define request relay/githubuser

          - define query <map.with[login].as[<[login]>]>
          - define query <[query].with[avatar_url].as[<[avatar_url]>]>
          - define query <[query].with[id].as[<[id]>]>
          - define query <[query].with[created_at].as[<[created_at]>]>
          - define query <[query].with[access_token].as[<[access_token]>]>
          - define query <[query].with[discord_id].as[<[discord_id]>]>

        #^- define query <[query].with[discord].as[<yaml[discord_links].read[discord_ids.<[discord_id]>]>]>
          - define minecraft_uuid <yaml[discord_links].read[discord_ids.<[discord_id]>.uuid]>
          - define query <[query].with[minecraft_uuid].as[<[minecraft_uuid]>]>

        #^- define player_data_yaml global.player.<[minecraft_uuid]>
        #^- define player_data_file data/global/players/<[minecraft_uuid]>.yml
        #^- if <server.has_file[<[player_data_file]>]>:
        #^  - yaml id:<[player_data_yaml]> load:<[player_data_file]>
        #^  - define query <[query].with[minecraft].as[<yaml[<[player_data_yaml]>].read[].get_subset[tab_display_name|display_name|rank]>]>
        #^  - yaml id:<[player_data_yaml]> unload

          - yaml id:github_links set discord_ids.<[discord_id]>:<[query]>
          - yaml id:github_links savefile:data/global/discord/github_links.yml

          - define query <[query].parse_value_tag[<[parse_key]>=<[parse_value].url_encode>].values.separated_by[&]>
          - ~webget <[url]>/<[request]>?<[query]>
        #^- ~webget <[url]>/<[request]> data:<[query].to_json>

        # % ██ [ Obtain User Repository Data     ] ██
          - define Headers "<[Headers].include[Authorization/token <[Access_Token]>]>"
          - ~webget https://api.github.com/user/repos Headers:<[Headers]> save:response
          - announce to_console "<&c>--- Obtain User Repo Data ----------------------------------------------------------"
          - inject Web_Debug.Webget_Response
          - if <entry[response].failed>:
            - announce to_console "<&c>Failure to Obtain User Repo Data"
            - stop
          - flag server Test.GitHub.ObtainUserRepoData:<util.parse_yaml[{"Data":<entry[Response].result>}].get[Data]>

          - define Main_Repo <[Login]>/network-script-data
          - define From_Repo BehrRiley/network-script-data
          - define Repositories <util.parse_yaml[{"Data":<entry[Response].result>}].get[Data].parse_tag[<[Parse_Value].get[full_name]>]>

        # % ██ [ Manage Fork                     ] ██
        #^- if <[Login]||invalid> != Invalid && !<[Repositories].contains[<[Main_Repo]>]>:
        #^  - announce to_console "<&c>-Fork Creation --------------------------------------------------------------"
        #^  - ~webget https://api.github.com/repos/<[From_Repo]>/forks Headers:<[Headers]> method:POST save:response
        #^  - announce to_console "<&c>--- Manage Fork ----------------------------------------------------------"
        #^  - inject Web_Debug.Webget_Response
        #^  - if <entry[response].failed>:
        #^    - announce to_console "<&c>Failure to manage the fork."
        #^    - stop
        #^- else:
        #^  - announce to_console "<&c>-No Fork Being Made ---------------------------------------------------------"

          # % ██ [ Obtain Branch Information     ] ██
        #^- ~webget https://api.github.com/repos/<[Main_Repo]>/branches headers:<[Headers]> save:response method:GET
        #^- announce to_console "<&c>--- Obtain Branch Information ----------------------------------------------------------"
        #^- inject Web_Debug.Webget_Response
        #^- if <entry[response].failed>:
        #^  - announce to_console "<&c>Failure to obtain Branch Information."
        #^  - stop
        #^- announce to_console '<&3>Branches<&6>: <&3><util.parse_yaml[{"Data":<entry[Response].result>}].get[Data].parse_tag[<[Parse_Value].get[name]>]>'

          # % ██ [ Obtain Webhook Information    ] ██
          - ~webget https://api.github.com/repos/<[Main_Repo]>/hooks headers:<[Headers]> save:response method:GET
          - announce to_console "<&c>--- Obtain Webhook Information ----------------------------------------------------------"
          - inject Web_Debug.Webget_Response
          - if <entry[response].failed>:
            - announce to_console "<&c>Failure to obtain Webhook Information."
            - stop
          - announce to_console '<&3>Webhooks<&6>: <&3><util.parse_yaml[{"Data":<entry[Response].result>}].get[Data].parse_tag[<[Parse_Value].get[name]>]>'
          - define Webhook_Data <util.parse_yaml[{"Data":<entry[Response].result>}].get[Data]>
          - define Webhook_IDs <[Webhook_Data].parse_tag[<[Parse_Value].get[id]>]>
          - define Webhooks_Content_Types <[Webooks].parse_tag[<map.with[id].as[<[Parse_Value]>].with[content_type].as[<[Webhook_Data].filter[get[ID].is[==].to[<[Parse_Value]>]].first.get[config].get[content_type]>]>]>
          #| Notable Error: Mapped within each webhook list contains a previous response: {"last_response":[{"code":"200","status":"active","message": "OK"}]
          #| erroneous currently unknown but could use to re-verify DNS records as well as verify port stability

        # % ██ [ Create Webhook                  ] ██
          - if <[Webhooks].is_empty>:
            - announce to_console "<&c>-WebHook Creation --------------------------------------------------------------"
            - define Data '{"config": {"url": "http://76.119.243.194:25580/github/<[Main_Repo]>","content_type": "json"}}'
            - announce to_console "<&4>Connecting: https://api.github.com/repos/<[Main_Repo]>/hooks with a hook to: http://76.119.243.194:25580/github/<[Main_Repo]>"
            - ~webget https://api.github.com/repos/<[Main_Repo]>/hooks Headers:<[Headers]> method:POST data:<[Data]> save:response
            - announce to_console "<&c>--- Create Webhook ----------------------------------------------------------"
            - inject Web_Debug.Webget_Response
          #| Notable Error: Exists already: {"message":"Validation Failed","errors":[{"resource":"Hook","code":"custom","message":"Hook already exists on this repository"}],"documentation_url":"https://docs.github.com/rest/reference/repos#create-a-repository-webhook"}
          #| occurs when the webhook exists already
          

      # % ██ [ Discord oAuth Token Ex ] ██
        - case /oAuth/Discord:
          - inject discord_oauth_token_exchange

      # % ██ [ WebGet Hosting         ] ██
        - case /webget:
          - if <server.has_file[../../../../web/webget/<context.query_map.get[name]||invalid>]>:
            - determine FILE:../../../../web/webget/<context.query_map.get[name]>
          - else:
            - determine CODE:404

      # % ██ [ FavIcon                ] ██
        - case /favicon.ico:
          - determine passively CODE:200
          - determine FILE:../../../../web/favicon.ico

      # % ██ [ CSS Hosting            ] ██
        - case /css:
          - if <server.has_file[../../../../web/css/<context.query_map.get[name]||invalid>.css]>:
            - determine passively CODE:200
            - determine FILE:../../../../web/css/<context.query_map.get[name]>.css

      # % ██ [ Webpages               ] ██
        - case /page:
          - if <server.has_file[../../../../web/pages/<context.query_map.get[name]||invalid>.html]>:
            - determine passively CODE:200
            - determine FILE:../../../../web/pages/<context.query_map.get[name]>.html

      # % ██ [ Images                 ] ██
        - case /image:
          - if <server.has_file[../../../../web/images/<context.query_map.get[name]||invalid>]>:
            - determine passively CODE:200
            - determine FILE:../../../../web/images/<context.query_map.get[name]>

      # % ██ [ Bad Get Request        ] ██
        - default:
          - determine CODE:<list[406|418].random>

    on post request:
      - define Domain <context.address>
      - inject Web_Debug.Post_Request

      - if <[Domain].starts_with[<script.data_key[Domains.Github]>]>:
        - define Map <util.parse_yaml[{"Data":<context.query>}].get[Data]>
        - define Request <context.request.after[github/]>
        - define Script <yaml[shell].read[file.git_pull]>

        - flag server testindex:++
        - yaml id:testindex<server.flag[testindex]> create
        - yaml id:testindex<server.flag[testindex]> set data:<[Map]>
        - yaml id:testindex<server.flag[testindex]> savefile:testindex<server.flag[testindex]>.yml

        #| ACTION key: The action that was performed.
        - if <[Map].contains[action]>:
          #| pull requests can be any of:
          #| opened|edited|closed|assigned|unassigned|review_requested|review_request_removed|ready_for_review|labeled|unlabeled|synchronize|locked|unlocked|reopened
          #| If the action is closed and the pull_request.merged key is true, the pull request was merged.
          #| If the action is closed and the pull_request.merged key is false, the pull request was closed with unmerged commits.

          - if <[Map].contains[pull_request]>:
            - if <[Map].get[action]> == opened:
              - announce to_console "<&a>---- Pull request was created. ---------------------------------------"
              - stop
            - else if <[Map].get[action]> == closed && <[Map].get[pull_request].get[merged]> == true:
              - announce to_console "<&a>---- Pull request was closed with ummerged commits. ------------------"
              - stop
            - else if <[Map].get[action]> == closed && <[Map].get[pull_request].get[merged]> == true:
              - announce to_console "<&a>---- Pull request was merged. ----------------------------------------"
            #| pull request reviews:
            - else if <[Map].get[Action]> == submitted:
              - announce to_console "<&a>---- A pull request review is submitted into a non-pending state. ----"
              - stop
            - else if <[Map].get[Action]> == edited:
              - announce to_console "<&a>---- The body of a review has been edited. ---------------------------"
              - stop
            - else if <[Map].get[Action]> == dismissed:
              - announce to_console "<&a>---- A review has been dismissed. ------------------------------------"
              - stop

          #| Issues:
          #| opened|edited|deleted|pinned|unpinned|closed|reopened|assigned|unassigned|labeled|unlabeled|locked|unlocked|transferred|milestoned|demilestoned.
            - else if <[Map].contains[issue]>:
              - choose <[Map].get[action]>:
                - case opened:
                  - announce to_console "<&a>---- New issued was created. -------------------------------------"
                - case closed:
                  - announce to_console "<&a>---- New issued was closed. --------------------------------------"
              - stop

          - else if <[Map].contains[ref|ref_type]> && <[Map].get[ref_type]> == branch:
            - if <[Map].contains[master_branch]>:
              - announce to_console "<&a>---- New branch was created. -----------------------------------------"
            - else:
              - announce to_console "<&a>---- Branch was deleted. ---------------------------------------------"
            - stop

        - shell <[Script]> <[Request]>


      - else if <[domain]> == <script.data_key[Domains.self]>:
        - bungee <bungee.list_servers.exclude[<bungee.server>]>:
          - reload
        - wait 1t
        - reload
      - else:
        - announce to_console "<&c>--- post request ----------------------------------------------------------"
        - announce to_console "Attempted request from <[Domain]>"
        - determine passively "received"
        - determine passively code:200
