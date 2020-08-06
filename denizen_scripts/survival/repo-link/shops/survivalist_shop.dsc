survivalistAssignment:
    type: assignment
    actions:
        on assignment:
        - trigger name:click state:true
    interact scripts:
    - survivalistInteraction

survivalistInteraction:
    type: interact
    steps:
        1:
            click trigger:
                script:
                    - inventory open d:

survivalistData:
    type: data
    categories:
        