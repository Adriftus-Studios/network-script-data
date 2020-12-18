package_deliveries:
  type: task
  debug: false
  script:
    - ~webget <yaml[network_configuration].read[hosts.the_network]> headers:<yaml[saved_headers].read[adriftus.post_office]> data:<yaml[packages].parsed_key[bungee_config].to_json> save:response
    - if <entry[response].failed>:
      - inject web_debug.webget_response
