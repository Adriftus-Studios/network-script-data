mcmmo_installed:
    type: procedure
    script:
        - determine <server.plugins.parse_tag[<[parse_value].name>].contains[mcMMO]||false>
