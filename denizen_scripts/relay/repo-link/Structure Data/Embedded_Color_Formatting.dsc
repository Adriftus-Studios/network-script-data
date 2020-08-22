Embedded_Color_Formatting:
    type: task
    debug: false
    definitions: Color
    script:
        - if <[Color]||null> != null:
            - define Color <script[DDTBCTY].data_key[Colors.<[Color]>]||0>
