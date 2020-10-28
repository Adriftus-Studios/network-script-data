web_handler:
  type: world
  debug: false
  Domains:
    Github: 140.82.115
    self: 0:0:0:0:0:0:0:1
  events:
    on server start:
      - web start port:25580

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

      # % ██ [ Bad Get Request        ] ██
        - default:
          - determine CODE:<list[406|418].random>

    on post request:
      - announce to_console "<&c>--- post request ----------------------------------------------------------"
      - inject Web_Debug.Post_Request
      - define domain <context.address>

    # % ██ [ Github Content pushes    ] ██
      - if <[domain].starts_with[<script.data_key[domains.github]>]>:
        - inject github_updates

    # % ██ [ Self Pings               ] ██
      - else if <[domain]> == <script.data_key[domains.self]>:
        - bungee <bungee.list_servers.exclude[<bungee.server>|survival]>:
          - reload
        - wait 1t
        - reload

    # % ██ [ Unrecognized posts       ] ██
      - else:
        - announce to_console "Attempted request from <[domain]>"
        - determine passively received
        - determine passively code:200
