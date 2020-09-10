channel_cache:
    type: task
    debug: false
    definitions: clean
    script:
        - foreach <yaml[discord_configuration].read[groups]> key:group_name as:group_id:
            - define channels <discordgroup[adriftusbot,<[group_id]>].channels>

            - foreach <[channels]> as:channel:
                - define channel_id <[channel].id>
                - define channel_name <[channel].name>
                # % Save by IDs
                - if !<yaml[discord_channels].contains[<[group_name]>.by_id.<[channel_id]>]>:
                    - yaml id:discord_channels set <[group_name]>.by_id.<[channel_id]>.name:<[channel_name].escaped>
                    - yaml id:discord_channels set <[group_name]>.by_id.<[channel_id]>.position:<[channel].position>
                    - yaml id:discord_channels set <[group_name]>.by_id.<[channel_id]>.channel_type:<[channel].channel_type>
                    - yaml id:discord_channels set <[group_name]>.by_id.<[channel_id]>.topic:<[channel].topic>
                # % Save by Names
                - if !<yaml[discord_channels].contains[<[group_name]>.by_name.<[channel_name].escaped>]>:
                    - yaml id:discord_channels set <[group_name]>.by_name.<[channel_name].escaped>.id:<[channel_id]>
                    - yaml id:discord_channels set <[group_name]>.by_name.<[channel_name].escaped>.position:<[channel].position>
                    - yaml id:discord_channels set <[group_name]>.by_name.<[channel_name].escaped>.channel_type:<[channel].channel_type>
                    - yaml id:discord_channels set <[group_name]>.by_name.<[channel_name].escaped>.topic:<[channel].topic>

            - if !<yaml[discord_channels].list_keys[<[group_name]>.by_id].exclude[<[channels].parse[id]>].is_empty>:
                - foreach <yaml[discord_channels].list_keys[<[group_name]>.by_id].exclude[<[channels].parse[id]>]> as:deprecated_channel_id:
                    - define deprecated_channel <discordchannel[adriftusbot,<[channel_id]>]>
                    - define deprecated_channel_name <discordchannel[adriftusbot,<[channel_id]>].name.escaped>

                    - yaml id:discord_channels set archived.<util.time_now.epoch_millis>.<[group_name]>.by_id.<[deprecated_channel_id]>:<yaml[discord_channels].read[<[group_name]>.by_id.<[deprecated_channel_id]>]>
                    - yaml id:discord_channels set archived.<util.time_now.epoch_millis>.<[group_name]>.by_name.<[deprecated_channel_name]>:<yaml[discord_channels].read[<[group_name]>.by_name.<[deprecated_channel_name]>]>

                    - yaml id:discord_channels set <[group_name]>.by_id.<[deprecated_channel_id]>:!
                    - yaml id:discord_channels set <[group_name]>.by_name.<[deprecated_channel_name]>:!

        - yaml id:discord_channels savefile:<yaml[network_configuration].read[configurations.discord_channels]>
