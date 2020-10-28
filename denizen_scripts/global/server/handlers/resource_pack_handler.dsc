
rp_command:
  type: command
  name: rp
  description: Immediately sets your current Resource Pack to the servers resources.
  usage: /rp
  aliases: resourcepack
  script:
  # The resource pack line.
    - define rp_url <server.flag[resourcepackurl]>
    - if <[rp_url]||null> != null:
      - if <context.args.size> >= 1:
        - narrate "<&c>Simply type <&a>/rp<&c>"
      - else:
        - adjust <player> resource_pack:<[rp_url]>

system_override:
  type: world
  events:
    on player joins:
      - define rp_url <server.flag[resourcepackurl]>
      - if <[rp_url]||null> != null:
        - wait 60t
        - adjust <player> resource_pack:<[rp_url]>
        - adjust <player> quietly_discover_recipe:<server.list_recipe_ids>
        - adjust <player> resend_discovered_recipes
    on resource pack status:
      - define rp_url <server.flag[resourcepackurl]>
      - if <[rp_url]||null> != null:
        - if <context.status> == FAILED_DOWNLOAD:
          - narrate "<&6>Please accept the resource pack."
          - narrate "<&6>While our server is playable without it, it makes more sense when you have the resource pack enabled."
          - narrate "<&6>If your download failed, click <&click[/rp]><&7>[HERE]<&end_click>"
        - else if <context.status> == DECLINED:
          - narrate "<&6>Please accept the resource pack."
          - narrate "<&6>While our server is playable without it, it makes more sense when you have the resource pack enabled."
          - if !<player.has_permission[bypass_resourcepack]>:
            - kick <player> "reason:<&c>The resource pack is needed in order to play.<&nl>Please enable resource packs in your server list by following these instructions<&nl><&nl><&a>Click on our server, and select <&b>Edit <&a>on the bottom of the screen.<&nl><&a>click <&b>Server Resource Packs<&co> <&a>option until <&b>enabled<&a> is displayed.<&nl><&a>Then get back in on the action!"
        - else if <context.status> == SUCCESSFULLY_LOADED:
          - narrate "<&6>Resource pack successfully loaded"
        - else if <context.status> == ACCEPTED:
          - narrate "<&6>Thank you for using our resource pack."
          - narrate "<&6>If you are enjoying the server then remember to vote with <&click[/vote]><&a><&l>/vote<&end_click><&6>!"
        - else:
          - narrate to_ops "<&c>Something borked with <&a><player><&c> loading the resource pack! <&4>STATUS<&co><&b> <context.status>"