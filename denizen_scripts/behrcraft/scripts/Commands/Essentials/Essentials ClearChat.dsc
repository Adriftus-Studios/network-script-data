clearchat_Command:
    type: command
    name: clearchat
    debug: false
    description: Clears your chat, like pressing (F3+D)
    usage: /clearchat or F3+D
    permission: Behrry.Essentials.Clearchat
    script:
        - narrate "<element[].pad_left[100].with[<&nl>]>"