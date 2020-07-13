Role_Verification:
    type: task
    debug: false
    definitions: Author|Group
    speed: 0
    script:
        - foreach <queue.script.yaml_key[PermissionRoles]> as:Role:
            - foreach <list[Public|Staff]> as:Guild:
                - foreach <script[DDTBCTY].list_keys[<[Guild]>.Roles]> as:ID:
                    - announce "<[Role]> <[Guild]> <[ID]>"
                    - if <script[DDTBCTY].yaml_key[<[Guild]>.Roles.<[ID]>]> == <[Role]>:
                        - define PermissionIDs:->:<[ID]>
        - if <[PermissionIDs].contains_any[<[Author].roles[<[Group]>].parse[ID]>]>
            