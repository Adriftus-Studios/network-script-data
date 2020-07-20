Embedded_Color_Formatting:
    type: task
    debug: false
    speed: 0
    script:
        - if <[Color].exists>:
            - define Color <script[DDTBCTY].yaml_key[Colors.<[Color]>]||0>