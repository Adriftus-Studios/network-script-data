web_handler:
  type: world
  debug: true
  Domains:
    Github: 140.82.115
    self: 127.0.0.1
  events:
    on server start:
      - web start port:25579

    on get request:
      - announce to_console "<&c>--- get request ----------------------------------------------------------"
      - inject Web_Debug.Get_Response
      - define query <context.query_map>

      - choose <context.request>:

      # % ██ [ Resource Pack  ] ██
        - case /resource_pack.zip:
          - determine passively FILE:mnt/sdb/web/resource-pack/hosted-rp-main.zip
          - determine CODE:200

      # % ██ [ Staff Resource Pack  ] ██
        - case /resource_pack_staff.zip:
          - determine passively FILE:/mnt/sdb/web/resource-pack/hosted-rp-staff.zip
          - determine CODE:200

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
          - inject companion_web_handler

      # % ██ [ Companion App Banner   ] ██
        - case /AdriftusMCHalf.png:
          - determine passively code:200
          - determine file:scripts/relay/repo_link/web/AdriftusMCHalf.png

      # % ██ [ Bad Get Request        ] ██
        - default:
          - determine CODE:<list[406|418].random>

    on post request:
      - announce to_console "<&c>--- post request ----------------------------------------------------------"
      - inject Web_Debug.Post_Request
      - define domain <context.headers.get[Nginx.remote_addr]>

    # % ██ [ Github Content pushes    ] ██
      - if <[domain].starts_with[<script.data_key[domains.github]>]>:
        - inject github_updates

    # % ██ [ Self Pings               ] ██
      - else if <[domain].starts_with[<script.data_key[domains.self]>]>:
        - choose <context.request>:
          - case /reload/main:
            - bungee <bungee.list_servers.exclude[<bungee.server>]>:
              - reload
            - wait 1t
            - reload
          - case /reload/test:
            - bungee test:
              - reload
          - case /reload/RP:
            - if <context.query.parsed.get[adriftus_sha].exists>:
              - bungeerun hub resource_pack_sha def:<context.query.parsed.get[adriftus_sha].before[<&sp>]>|<context.query.parsed.get[adriftus_staff_sha].before[<&sp>]>

      # % ██ [ Denizen Interactions   ] ██
      - else if <context.headers.contains[X-signature-ed25519]>:
        - ~webget http://127.0.0.1:8000 data:<context.query> headers:<context.headers> save:response

      # hang server intentionally
        - announce to_console <entry[response].code>
        - if <entry[response].failed||nil> == nil || <entry[response].failed>:
          - determine code:401

        - inject discord_interaction_handler

    # % ██ [ Unrecognized posts       ] ██
      - else:
        - announce to_console "Attempted request from <[domain]>"
        - determine passively received
        - determine passively code:200

#<context.query> | {"application_id":"716381772610273430","id":"965683671787008015","token":"aW50ZXJhY3Rpb246OTY1NjgzNjcxNzg3MDA4MDE1Olo2UWc5MHEwTWVkcDEwUnhtbnBqOVNSZFl2enBudHlFdXhKdVBzU2s2UWZicWNkdFVQZHh4UGlKVDBubU9vSXN3d3hnTkhWRndnZmd1M3ZGV3pwWVU2ZEhrVVI0MGNqM3V5S3VOVnJ0MzZPSGhabFJoS0d6QVJNR3NmT2FqMTFy","type":1,"user":{"avatar":"bd4db22679fa4e3381ea2b5c79553b3b","discriminator":"0001","id":"565536267161567232","public_flags":0,"username":"Xeane"},"version":1}
#  map@[X-signature-ed25519=556ece60b5f211bd2562889fa3bf701fa772690fd110be7cb5b181853da99a756e95c0b6713a6379b599ed605e580099601a9c057f6b2f2a2a9d8ce059ef6d0f;Connection=close;Nginx.remote_addr=35.237.4.214;Host=127.0.0.1:25579;User-agent=Discord-Interactions/1.0 (+https://discord.com);Content-type=application/json;X-signature-timestamp=1650309675;Content-length=447]