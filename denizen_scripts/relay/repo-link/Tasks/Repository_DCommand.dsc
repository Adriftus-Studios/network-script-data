Repository_DCommand:
    type: task
    definitions: Channel
    debug: false
    Context: Color
    script:
# - ██ [ Clean Definitions & Inject Dependencies ] ██
    - define color Code
    - inject Embedded_Color_Formatting
    - define Hook <script[DDTBCTY].data_key[WebHooks.<[Channel]>.hook]>
    - define Headers <yaml[Saved_Headers].read[Discord.Webhook_Message]>

    - define Data <yaml[SDS_Repository].to_json>
    - ~webget <[Hook]> data:<[Data]> headers:<[Headers]>
