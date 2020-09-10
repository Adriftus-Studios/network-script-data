yaml_handler:
  type: world
  load:
    - foreach <yaml[network_configuration].read[configurations]> key:yaml as:file_path:
      - ~run load_yaml def:<[yaml]>|<[file_path]>|false|false
      
    - foreach <server.list_files[data/globalLiveData/discord/webhooks]> as:Json:
      - yaml id:webhook_template_<[Json].before[.]> load:data/globalLiveData/discord/webhooks/<[Json]>

    - foreach "<server.list_files[data/Script Dependency Support]>" as:Yaml:
      - yaml id:SDS_<[Yaml].before[.].replace[<&sp>].with[_]> "load:data/Script Dependency Support/<[Yaml]>"
        
  events:
    on server start:
      - yaml id:network_configuration load:data/global/network/configuration.yml
      - inject locally load
      - inject package_deliveries
    on script reload:
      - inject locally load

load_yaml:
  type: task
  definitions: yaml|file_path|save|force
  script:
    - if <yaml.list.contains[<[yaml]>]>:
      - if <[save]>:
        - yaml id:<[yaml]> savefile:<[file_path]>
        - announce to_console "<&e>Yaml saved<&6>: <&a><[yaml]>"
      - yaml id:<[yaml]> unload
      - announce to_console "<&e>Yaml unloaded<&6>: <&a><[yaml]>"
    - if <server.has_file[<[file_path]>]>:
      - yaml id:<[yaml]> load:<[file_path]>
      - announce to_console "<&e>Yaml loaded<&6>: <&a><[yaml]>"
    - else if <[force]>:
      - yaml id:<[yaml]> create
      - yaml id:<[yaml]> savefile:<[file_path]>
      - announce to_console "<&e>Yaml created<&6>: <&a><[yaml]>"
