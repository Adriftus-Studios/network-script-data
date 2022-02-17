web_handler:
  type: world
  debug: true
  Domains:
    Github: 140.82.115
    self: 127.0.0.1
  events:
    on server start:
      - web start port:25581

    on get request:
      - announce to_console "<&c>--- get request ----------------------------------------------------------"
      - inject Web_Debug.Get_Response
      - define query <context.query_map>

      - choose <context.request>:
      # % ██ [ Github oAuth Token Ex  ] ██
        - case /oAuth/GitHub:
          - inject discord_oauth_token_exchange

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

      # % ██ [ Companion App          ] ██
        - case /companion:
          # Inject the script file with all the companion handlers
          # IP from the web server filtered to show just the numbers
          - define ip <context.address.replace_text[/].with[].split[:]>
          # Ip that was sent from the server to the relay
          - inject companion_get_ip_using_hash
          - define relayIp <proc[companion_get_ip_using_hash].context[<[query].get[hash]>]>
          - if !<[relayIp].equals[null]>:
            - if <[relayIp].equals[<[ip].first>]>:
              - inject companion_get_uuid_using_hash
              - define uuid <proc[companion_get_uuid_using_hash].context[<[query].get[hash]>]>
              - if !<[uuid].equals[null]>:
                - if <[query].contains[request]> && <[query].get[request].equals[data]>:
                  - inject companion_get_data_using_hash
                  - determine passively code:200
                  - determine <proc[companion_get_data_using_hash].context[<[query].get[hash]>]>
                - determine passively code:200
                - determine parsed_file:../../../../web/main.html
              - else:
                - determine "Youre data is missing, please contact administration"
            - else:
              - determine "You must use the same ip address, as the one you used to login to minecraft!"
          - else:
              - determine "You dont have an active session. Please use /companion in game to create one"

      # % ██ [ Companion App Banner   ] ██
        - case /AdriftusMCHalf.png:
          - determine passively code:200
          - determine file:../../../../web/AdriftusMCHalf.png
      # % ██ [ Bad Get Request        ] ██
        - default:
          - determine CODE:<list[406|418].random>

    on post request:
      - announce to_console "<&c>--- post request ----------------------------------------------------------"
      - inject Web_Debug.Post_Request
      - define domain <context.address>

    # % ██ [ Github Content pushes    ] ██
      - if <[domain].starts_with[/<script.data_key[domains.github]>]>:
        - inject github_updates

    # % ██ [ Self Pings               ] ██
      - else if <[domain].starts_with[/<script.data_key[domains.self]>]>:
        - bungee <bungee.list_servers.exclude[<bungee.server>|survival]>:
          - reload
        - wait 1t
        - reload

    # % ██ [ Unrecognized posts       ] ██
      - else:
        - announce to_console "Attempted request from <[domain]>"
        - determine passively received
        - determine passively code:200
