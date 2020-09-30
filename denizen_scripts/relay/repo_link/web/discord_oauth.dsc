discord_oauth_token_exchange:
  type: task
  debug: false
  definitions: query
  script:
  # % ██ [ Cache Data                      ] ██
    - if <[Query].contains[error]> && <[Query].get[error]> == access_denied:
      - announce to_console "<&c>The resource owner or authorization server denied the request"
      - determine passively CODE:300
      - determine FILE:../../../../web/redirects/discord_decline.html
    - if !<[Query].contains[code|state]>:
      - announce to_console "<&c>State and Code are missing."
      - determine CODE:<list[418|406].random>

    - define code <context.query_map.get[code]>
    - define state <context.query_map.get[state]>
    - define uuid <[state].before[_]>
    - define Platform Discord

    - define Headers <yaml[oAuth].read[Headers].include[<yaml[oAuth].read[Discord.Token_Exchange.Headers]>]>
  
    - if !<yaml[discord_oauth].contains[accepted_states.<[state]>]>:
      - announce to_console <&c>invalid_state
      - determine CODE:<list[418|406].random>
    - run discord_oauth def:<[state]>|remove
    - determine passively FILE:../../../../web/pages/discord_linked.html

  # % ██ [ Token Exchange                  ] ██
    - define URL <yaml[oAuth].read[URL_Scopes.Discord.Token_Exchange]>
    - define Data <list[oAuth_Parameters|Discord.Application|Discord.Token_Exchange.Parameters]>
    - define Data <[Data].parse_tag[<yaml[oAuth].parsed_key[<[Parse_Value]>]>].merge_maps>
    - define Data <[Data].to_list.parse_tag[<[Parse_Value].before[/]>=<[Parse_Value].after[/]>].separated_by[&]>

    - ~webget <[URL]> Headers:<[Headers]> Data:<[Data]> save:response
    - announce to_console "<&c>--- Token Exchange ----------------------------------------------------------"
    - inject Web_Debug.Webget_Response
    - if <entry[response].failed>:
      - announce to_console "<&c>failure; ending queue."
      - stop

  # % ██ [ Save Access Token Response Data ] ██
    - define access_token_response <util.parse_yaml[<entry[response].result>]>
    - define access_token <[access_token_response].get[access_token]>
    - define refresh_token <[access_token_response].get[refresh_token]>
    - define expires_in <[access_token_response].get[expires_in]>

  # % ██ [ Obtain User Info                ] ██
    - define URL <yaml[oAuth].read[URL_Scopes.Discord.Identify]>
    - define Headers <[Headers].include[<yaml[oAuth].parsed_key[Discord.Client_Credentials.Headers]>]>

    - ~webget <[URL]> headers:<[Headers]> save:response
    - announce to_console "<&c>--- Obtain User Info ----------------------------------------------------------"
    - inject Web_Debug.Webget_Response
    - if <entry[response].failed>:
      - announce to_console "<&c>failure; ending queue."
      - stop

  # % ██ [ Save User Data                  ] ██
    - define User_Data <util.parse_yaml[<entry[response].result>]>
    - narrate "<&c>User_Data: <&2><[User_Data]>"
    - define User_ID <[User_Data].get[id]>
    - define avatar https://cdn.discordapp.com/avatars/<[User_ID]>/<[User_Data].get[avatar]>

  # % ██ [ Send to The-Network             ] ██
    - define url http://76.119.243.194:25580
    - define request relay/discorduser

    - define query <map.with[uuid].as[<[uuid]>]>
    - define query <[query].with[access_token].as[<[access_token]>]>
    - define query <[query].with[refresh_token].as[<[refresh_token]>]>
    - define query <[query].with[expires_in].as[<[expires_in]>]>
    - define query <[query].with[id].as[<[User_Data].get[id]>]>
    - define query <[query].with[username].as[<[User_Data].get[username]>]>
    - define query <[query].with[avatar].as[<[avatar]>]>
    - define query <[query].with[discriminator].as[<[User_Data].get[discriminator]>]>
    - define query <[query].with[mfa_enabled].as[<[User_Data].get[mfa_enabled]>]>

    - if <server.has_file[data/global/players/<[uuid]>.yml]>:
      - yaml id:global.player.<[uuid]> load:data/global/players/<[uuid]>.yml
      - define query <[query].with[minecraft].as[<yaml[global.player.<[uuid]>].read[].get_subset[Tab_Display_name|Display_Name|rank]>]>
      - yaml id:global.player.<[uuid]> unload

    - yaml id:discord_links set minecraft_uuids.<[uuid]>:<[query]>
    - yaml id:discord_links set discord_ids.<[query].get[id]>:<[query]>
    - yaml id:discord_links savefile:data/global/discord/discord_links.yml

    - define query <[query].parse_value_tag[<[parse_key]>=<[parse_value].url_encode>].values.separated_by[&]>
    - ~webget <[url]>/<[request]>?<[query]>

  # % ██ [ Obtain User Connections         ] ██
    - define URL <yaml[oAuth].read[URL_Scopes.Discord.Connections]>
    - ~webget <[URL]> headers:<[Headers]> save:response
    - announce to_console "<&c>--- Obtain User Connections ----------------------------------------------------------"
    - inject Web_Debug.Webget_Response
    - if <entry[response].failed>:
      - announce to_console "<&c>failure; ending queue."

    - define User_Data <util.parse_yaml[{"Data":<entry[response].result>}].get[Data]>
