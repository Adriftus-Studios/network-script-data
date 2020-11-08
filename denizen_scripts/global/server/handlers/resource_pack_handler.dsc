
rp_command:
  type: command
  name: rp
  description: Immediately sets your current Resource Pack to the servers resources.
  usage: /rp
  aliases: resourcepack
  script:
  # The resource pack line.
    - if <server.has_flag[resourcepackurl]>:
      - if <context.args.size> >= 1:
        - narrate "<&c>Simply type <&a>/rp<&c>"
      - else:
        - adjust <player> resource_pack:<server.flag[resourcepackurl]>

system_override:
  type: world
  events:
    on player joins:
      - if <server.has_flag[resourcepackurl]>:
        - wait 60t
        - adjust <player> resource_pack:<server.flag[resourcepackurl]>
        - adjust <player> quietly_discover_recipe:<server.list_recipe_ids>
        - adjust <player> resend_discovered_recipes
    on resource pack status:
      - if <server.has_flag[resourcepackurl]>:
        - choose <context.status>:
          - case FAILED_DOWNLOAD:
            - narrate "<&6>Please accept the resource pack."
            - narrate "<&6>While our server is playable without it, it makes more sense when you have the resource pack enabled."
            - narrate "<&6>If your download failed, click <&click[/rp]><&7>[HERE]<&end_click>"
          - case DECLINED:
            - narrate "<&6>Please accept the resource pack."
            - narrate "<&6>While our server is playable without it, it makes more sense when you have the resource pack enabled."
            - if !<player.has_permission[bypass_resourcepack]>:
              - kick <player> "reason:<&c>The resource pack is needed in order to play.<&nl>Please enable resource packs in your server list by following these instructions<&nl><&nl><&a>Click on our server, and select <&b>Edit <&a>on the bottom of the screen.<&nl><&a>click <&b>Server Resource Packs<&co> <&a>option until <&b>enabled<&a> is displayed.<&nl><&a>Then get back in on the action!"
          - case SUCCESSFULLY_LOADED:
            - narrate "<&6>Resource pack successfully loaded"
          - case ACCEPTED:
            - narrate "<&6>Thank you for using our resource pack."
            - narrate "<&6>If you are enjoying the server then remember to vote with <&click[/vote]><&a><&l>/vote<&end_click><&6>!"
