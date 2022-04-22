Error_Response_Webhook:
  type: task
  debug: false
  definitions: Data
  script:
  # $ ██ [ Verify Server       ] ██
    - if !<script.list_keys[Channel_Map].contains[<[Data].get[Server]>]>:
      - stop

    - narrate <[data]>
