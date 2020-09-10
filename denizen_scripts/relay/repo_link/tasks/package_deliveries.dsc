package_deliveries:
  type: task
  debug: false
  script:
    - ~webget <yaml[network_configuration].read[hosts.the_network]> headers:<yaml[saved_headers].read[behrs_post_office]> data:<yaml[packages].parsed_key[bungee_config].to_json>
