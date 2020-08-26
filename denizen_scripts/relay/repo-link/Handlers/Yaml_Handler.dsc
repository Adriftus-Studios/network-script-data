Template_Handler:
  type: world
  load:
    - foreach <server.list_files[data/globalLiveData/discord/webhooks]> as:Json:
      - yaml id:webhook_template_<[Json].before[.]> load:data/globalLiveData/discord/webhooks/<[Json]>
    - yaml id:bungee.config load:../../../../bungee/config.yml
    - foreach "<server.list_files[data/Script Dependency Support]>" as:Yaml:
      - yaml id:SDS_<[Yaml].before[.].replace[<&sp>].with[_]> "load:data/Script Dependency Support/<[Yaml]>"
    - yaml id:saved_headers load:data/global/discord/saved_headers.yml
    - yaml id:shell load:data/global/discord/shell_directories.yml
    - yaml id:oAuth load:data/global/discord/oAuth_Data.yml
        
  events:
    on server start:
      - inject locally load
    on script reload:
      - inject locally load
