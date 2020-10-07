negative_spacing:
  type: procedure
  definitions: int
  script:
    - if !<[int].is_integer>:
      - determine "Invalid integer"

    - define spacing <list>

    - while <[int]> > 0:
      - if <[int]> >= 1024:
        - define int:-:1024
        - define spacing <[spacing].include[<&chr[F80E].font[data:default]>]>
      - else if <[int]> >= 512:
        - define int:-:512
        - define spacing <[spacing].include[<&chr[F80D].font[data:default]>]>
      - else if <[int]> >= 128:
        - define int:-:128
        - define spacing <[spacing].include[<&chr[F80C].font[data:default]>]>
      - else if <[int]> >= 64:
        - define int:-:64
        - define spacing <[spacing].include[<&chr[F80B].font[data:default]>]>
      - else if <[int]> >= 32:
        - define int:-:32
        - define spacing <[spacing].include[<&chr[F80A].font[data:default]>]>
      - else if <[int]> >= 16:
        - define int:-:16
        - define spacing <[spacing].include[<&chr[F809].font[data:default]>]>
      - else if <[int]> >= 8:
        - define int:-:8
        - define spacing <[spacing].include[<&chr[F808].font[data:default]>]>
      - else if <[int]> >= 7:
        - define int:-:7
        - define spacing <[spacing].include[<&chr[F807].font[data:default]>]>
      - else if <[int]> >= 6:
        - define int:-:6
        - define spacing <[spacing].include[<&chr[F806].font[data:default]>]>
      - else if <[int]> >= 5:
        - define int:-:5
        - define spacing <[spacing].include[<&chr[F805].font[data:default]>]>
      - else if <[int]> >= 4:
        - define int:-:4
        - define spacing <[spacing].include[<&chr[F804].font[data:default]>]>
      - else if <[int]> >= 3:
        - define int:-:3
        - define spacing <[spacing].include[<&chr[F803].font[data:default]>]>
      - else if <[int]> >= 2:
        - define int:-:2
        - define spacing <[spacing].include[<&chr[F802].font[data:default]>]>
      - else:
        - define int:-:1
        - define spacing <[spacing].include[<&chr[F801].font[data:default]>]>
      
    - determine <[spacing].unseparated>

positive_spacing:
  type: procedure
  definitions: int
  script:
    - if !<[int].is_integer>:
      - determine "Invalid integer"

    - define spacing <list>

    - while <[int]> > 0:
      - if <[int]> >= 1024:
        - define int:-:1024
        - define spacing <[spacing].include[<&chr[F821].font[data:default]>]>
      - else if <[int]> >= 512:
        - define int:-:512
        - define spacing <[spacing].include[<&chr[F822].font[data:default]>]>
      - else if <[int]> >= 128:
        - define int:-:128
        - define spacing <[spacing].include[<&chr[F823].font[data:default]>]>
      - else if <[int]> >= 64:
        - define int:-:64
        - define spacing <[spacing].include[<&chr[F824].font[data:default]>]>
      - else if <[int]> >= 32:
        - define int:-:32
        - define spacing <[spacing].include[<&chr[F825].font[data:default]>]>
      - else if <[int]> >= 16:
        - define int:-:16
        - define spacing <[spacing].include[<&chr[F826].font[data:default]>]>
      - else if <[int]> >= 8:
        - define int:-:8
        - define spacing <[spacing].include[<&chr[F827].font[data:default]>]>
      - else if <[int]> >= 7:
        - define int:-:7
        - define spacing <[spacing].include[<&chr[F828].font[data:default]>]>
      - else if <[int]> >= 6:
        - define int:-:6
        - define spacing <[spacing].include[<&chr[F829].font[data:default]>]>
      - else if <[int]> >= 5:
        - define int:-:5
        - define spacing <[spacing].include[<&chr[F82A].font[data:default]>]>
      - else if <[int]> >= 4:
        - define int:-:4
        - define spacing <[spacing].include[<&chr[F82B].font[data:default]>]>
      - else if <[int]> >= 3:
        - define int:-:3
        - define spacing <[spacing].include[<&chr[F82C].font[data:default]>]>
      - else if <[int]> >= 2:
        - define int:-:2
        - define spacing <[spacing].include[<&chr[F82D].font[data:default]>]>
      - else:
        - define int:-:1
        - define spacing <[spacing].include[<&chr[F82E].font[data:default]>]>
      
    - determine <[spacing].unseparated>
