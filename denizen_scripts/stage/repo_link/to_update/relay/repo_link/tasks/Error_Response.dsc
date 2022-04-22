error_response:
  type: task
  debug: true
  definitions: Data
  script:
  # $ ██ [ Verify Server       ] ██
    - if !<script.list_keys[Channel_Map].contains[<[Data].get[Server]>]>:
      - stop

    - narrate <[data]>
