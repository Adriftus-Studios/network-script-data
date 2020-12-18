Role_Verification:
  type: task
  debug: false
  definitions: Author|Group
  script:
    - if <queue.script.list_keys.contains[PermissionRoles]>:
      - foreach <queue.script.data_key[PermissionRoles]> as:Role:
        - foreach <list[Public|Staff]> as:Guild:
          - foreach <script[DDTBCTY].list_keys[<[Guild]>.Roles]> as:ID:
            - announce "<[Role]> <[Guild]> <[ID]>"
            - if <script[DDTBCTY].data_key[<[Guild]>.Roles.<[ID]>]> == <[Role]>:
              - define PermissionIDs:->:<[ID]>
    - if <[Group]> != Is_Direct && !<[PermissionIDs].contains_any[<[Author].roles[<[Group]>].parse[ID]>]>:
      - stop
