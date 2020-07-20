web_handler:
  type: world
  Domains:
    Github: 140.82.115
  events:
    on post request:
      - define Domain <context.address>
      - if <[Domain].starts_with[<script.data_key[Domains.Github]>]>:
        - announce to_console success

        - define Request <context.request.after[github/]>
        - define Script ../network-script-data/system_scripts/github/git-pull

        - shell <[Script]> <[Request]>

        - define Hook <script[DDTBCTY].data_key[WebHooks.650016499502940170.hook]>
        - define data <yaml[webhook_template_git-pull].to_json>
        - define headers <list[User-Agent/really|Content-Type/application/json]>
        - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
