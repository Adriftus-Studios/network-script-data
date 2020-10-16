github_updates:
  type: task
  definitions: domain
  script:
  # % ██ [ Cache Data                  ] ██
    - define embed <discordembed>
    - define emoji <&lt>:icons8commitgit641:746943945929523252<&gt>
    - define data <util.parse_yaml[{"data":<context.query>}].get[data]||invalid>

  # % ██ [ Queue-stopping actions                 ] ██
    - if <[data]> == invalid:
        - stop
    - if <[data].contains[action]> && <[data].get[action]> == member_invited:
      - stop

  # % ██ [ Format the color, thumbnail of the Embed ] ██
    - define embed <[embed].color[2815384]>
    - define embed <[embed].thumbnail_url[https://media.discordapp.net/attachments/756255983403270196/756256146427478046/githubico.png]>

  # % ██ [ Format the Sender, Author of the Embed   ] ██
    - define sender <[data].get[sender]>
    - define embed <[embed].author_name[<[sender].get[login]>]>
    - define embed <[embed].author_url[<[sender].get[html_url]>]>
    - define embed <[embed].author_icon_url[<[sender].get[avatar_url]>]>

  # % ██ [ Determine the context channel            ] ██
    - define repository_data <[data].get[repository]>
    - define repository_id <[repository_data].get[id]>
    - define repository_name <[repository_data].get[name]>
    - define repository_full_name <[repository_data].get[full_name]>
    - define owner_data <[repository_data].get[owner]>
    - define owner_type <[owner_data].get[type]>
    - define owner_id <[owner_data].get[id]>
    - define owner_name <[owner_data].get[login]>
    - define channel <script.data_key[channel_map.organization.Adriftus-Studios.<[repository_name]>]>

  # % ██ [ Determine the listening event            ] ██
    - choose <context.headers.get[X-github-event]>:

      - case push:
      # % ██ [ Format the commits                     ] ██
        - define commits <list>
        - foreach <[data].get[commits]> as:commit_data:
          - define commit_url <[commit_data].get[url]>
          - define commit_timestamp <[commit_data].get[timestamp]>
          - define short_commit <[commit_data].get[id].substring[0,7]>
          - define commit_message <[commit_data].get[message].before[<n>]>
          - define commit "[<[Emoji]>`[<[short_commit]>]`](<[commit_url]>) <[commit_message]>"
          - define commits <[commits].include[<[commit]>]>

      # % ██ [ Format the embed message               ] ██
        - define embed <[embed].description[<[commits].separated_by[<n>]>]>
        
      # % ██ [ Format the title                       ] ██
        - if <[commits].size> != 1:
          - define embed "<[embed].title[`<&lb><[data].get[repository].get[full_name]><&rb>` | <[commits].size> new commits]>"
        - else:
          - define embed "<[embed].title[`<&lb><[data].get[repository].get[full_name]><&rb>` | 1 new commit]>"
        - define embed <[embed].url[<[data].get[compare]>]>

      # % ██ [ Send the message                       ] ██
        - ~discord ID:adriftusbot send_embed channel:<[channel]> embed:<[embed]>

      # % ██ [ Update the server                      ] ██
        - choose <[repository_full_name]>:
          - case Adriftus-Studios/network-script-data:
            - shell <yaml[shell].read[file.git_pull]> <context.request.after[github/]>

      - case issues:
      # % ██ [ Cache data                             ] ██
        - define issue_data <[data].get[issue]>
        - define action <[data].get[action]>

      # % ██ [ Queue-stopping actions                 ] ██
        #| allowed: opened|closed|locked|unlocked|reopened
        - if <list[edited|assigned|unassigned|review_requested|review_request_removed|ready_for_review|labeled|unlabeled|synchronize].contains[<[action]>]>:
          - stop

      # % ██ [ Format the title                       ] ██
        - if <[action]> == locked:
          - define embed "<[embed].title[`<&lb><[repository_full_name]><&rb>` | Issue <[action]>: `<&lb><&ns><[issue_data].get[number]><&rb>`<n>`<&lb><[issue_data].get[title].replace_text[`].with['].replace_text[*]><&rb>`:lock:]>"
        - else:
          - define embed "<[embed].title[`<&lb><[repository_full_name]><&rb>` | Issue <[action]>: `<&lb><&ns><[issue_data].get[number]><&rb>`<n>`<&lb><[issue_data].get[title].replace_text[`].with['].replace_text[*]><&rb>`]>"
        - define embed <[embed].url[<[issue_data].get[html_url]>]>

      # % ██ [ Format the message                     ] ██
        - if <[action]> == created:
          - define embed "<[embed].description[<[issue_data].get[body].replace_text[\r<n>- ].with[<[emoji]> ].replace_text[<n>- ].with[<[emoji]> ]>]>"
      
      # % ██ [ Send the message                       ] ██
        - ~discord ID:adriftusbot send_embed channel:<[channel]> embed:<[embed]>

      - case issue_comment:
      # % ██ [ Cache data                             ] ██
        - define action <[data].get[action]>
        - define issue_data <[data].get[issue]>
        - define content_data <[data].get[comment]>

      # % ██ [ Format the title                       ] ██
        - define embed "<[embed].title[`<&lb><[repository_full_name]><&rb>` | Comment <[action]>: `<&lb><&ns><[issue_data].get[number]><&rb>`<n>`<&lb><[issue_data].get[title].replace_text[`].with['].replace_text[*]><&rb>`]>"
        - define embed <[embed].url[<[issue_data].get[html_url]>]>

      # % ██ [ Format the message                     ] ██
        - define description_context <list_single[<[content_data].get[body]>].include_single[<[emoji]>]>
        - define description <proc[Emoji_Bullets].context[<[description_context]>]>
        - define embed <[embed].description[<[description]>]>

      # % ██ [ Send the message                       ] ██
        - ~discord ID:adriftusbot send_embed channel:<[channel]> embed:<[embed]>

      - case pull_request:
      # % ██ [ Cache data                             ] ██
        - define pull_data <[data].get[pull_request]>

      # % ██ [ Format the title                       ] ██
        - define embed "<[embed].title[`<&lb><[data].get[repository].get[full_name]><&rb>` | Pull request <[data].get[action]>: `<&lb><&ns><[data].get[number]><&rb>`<n>`<&lb><[pull_data].get[title].replace_text[`].with['].replace_text[*]><&rb>`]>"
        - define embed <[embed].url[<[pull_data].get[html_url]>]>

      # % ██ [ Format the message                     ] ██
        - define description_context <list_single[<[pull_data].get[body]>].include_single[<[emoji]>]>
        - if <[action]> == closed && !<[pull_data].get[merged]>:
          - define description "<[emoji]>[`[Closed without merging.]`](https://github.com/bAlcoholics/<[data].get[repository].get[name]>/compare/<[pull_data].get[head].get[ref]>)"
        - else:
          - define description "<[emoji]>[`[<proc[GCF].context[<[pull_data].get[additions]>|+]>/<proc[GCF].context[<[pull_data].get[deletions]>|-]> (<[pull_data].get[changed_files]> file changes)]`](https://github.com/bAlcoholics/<[data].get[repository].get[name]>/compare/<[pull_data].get[head].get[ref]>)<n><proc[Emoji_Bullets].context[<[description_context]>]>"
        - define embed <[embed].description[<[description]>]>

      # % ██ [ Send the message                       ] ██
        - ~discord ID:adriftusbot send_embed channel:<[channel]> embed:<[embed]>

      - case pull_request_review:
      # % ██ [ Cache data                             ] ██
        - define action <[data].get[action]>
        - define review_data <[data].get[review]>
        - define pull_data <[data].get[pull_request>

      # % ██ [ Queue-stopping actions                 ] ██
        - if <[review_data].get[body]> == null || <[data].get[action].contains_any[edited]>:
          - stop

      # % ██ [ Format the title                       ] ██
        - define embed "<[embed].title[`<&lb><[repository_full_name]><&rb>` | Pull request review <[action]>: `<&lb><&ns><[pull_data].get[number]><&rb>`<n>`<&lb><[pull_data].get[title].replace_text[`].with['].replace_text[*]><&rb>`]>"
        - define embed <[embed].url[<[review_data].get[html_url]>]>

      # % ██ [ Format the message if not a review req ] ██
        - define ID <[review_data].get[id]>
        - define context <list_single[<[review_data].get[body]>].include_single[<[emoji]>]>
        - define description <proc[Emoji_Bullets].context[<[context]>]>
        - flag server review.id.<[id]>:->:<[description]>
        - wait 3s
        - define timeout <util.time_now.add[10s]>
        - while <server.has_flag[review.wait.<[id]>]> && <[timeout].duration_since[<util.time_now>].in_seconds> != 0:
          - wait 1s
        - define context <server.flag[review.id.<[id]>]>
        - flag server review.id.<[id]>:!

      # % ██ [ Format the message(s)                  ] ██
        #^- define line <n><script[github_data].parsed_key[emojis.line]><n>
        - define line `______________________________________`
        - if <[context].separated_by[<[line]>].length> < 1500:
          # % ██ [ Send the message                   ] ██
          - define embed <[embed].description[<[context].separated_by[<[line]>]>]>
          - ~discord ID:adriftusbot send_embed channel:<[channel]> embed:<[embed]>
        - else:
          - define messages 0
          - while !<[context].is_empty> as:string:
            - repeat <[context].size> as:i:
              - if <[context].first.length> > 1500:
                - define context <[context].remove[first]>
                - repeat stop
              - else if <[context].get[1].to[<[i].add[1]>].separated_by[<[line]>].length> < 1500:
                - repeat next
              - else:
                - define new_embed <[embed].description[<[context].get[1].to[<[i]>].separated_by[<[line]>]>]>
                - ~discord ID:adriftusbot send_embed channel:<[channel]> embed:<[embed]>
                - define context <[context].remove[<util.list_numbers_to[<[i]>]>]>
                - define messages:++
          - if <[messages]> == 0:
          # % ██ [ Send the message                   ] ██
            - ~discord ID:adriftusbot send_embed channel:<[channel]> embed:<[embed]>

      - case pull_request_review_comment:
      # % ██ [ Cache data                             ] ██
        - define comment_data <[data].get[comment]>

      # % ██ [ Format the message                     ] ██
        - define context <list_single[<[comment_data].get[body]>].include_single[<[emoji]>]>
        - define context <proc[Emoji_Bullets].context[<[context]>]>

        - if <[comment_data].get[start_line]> != null:
          - define line_actions `[<&ns><[comment_data].get[start_line]>-<&ns><[comment_data].get[line]>]`
        - else:
          - define line_actions `[<&ns><[comment_data].get[line]>]`
        - define context [<[line_actions]>](<[comment_data].get[html_url]>)<&sp><[context]>
        - flag server review.id.<[id]>:->:<[context]>
        - flag server review.wait.<[id]> duration:1.5s
        
      # % ██ [ Check if not a package review          ] ██
        - wait 4s
        - if <server.has_flag[review.id.<[id]>]>:
          - define embed "<[embed].title[`<&lb><[data].get[repository].get[full_name]><&rb>` | Pull request review <[data].get[action]>: `<&lb><&ns><[data].get[pull_request].get[number]><&rb>`<n>`<&lb><[data].get[pull_request].get[title].replace_text[`].with['].replace_text[*]><&rb>`]>"
          - define embed <[embed].url[<[comment_data].get[html_url]>]>
          - define embed <[embed].description[<[context]>]>
          - flag server review.id.<[id]>:!

      # % ██ [ Send the message                       ] ██
        - ~discord ID:adriftusbot send_embed channel:<[channel]> embed:<[embed]>

  channel_map:
    organization:
      Adriftus-Studios:
        Adriftizen: 650016499502940170

        network-script-data: 650016499502940170
        adriftus-resources: 754034672253665391

        dDiscordBot: 650016499502940170
        Depenizen: 650016499502940170
        dModelEngine: 650016499502940170
        Webizen: 650016499502940170

github_data:
  type: data
  l: <&lt>:40px:756574957349109951<&gt>
  emojis:
    Lock: <&lt>:locked:732707020616237179<&gt>
    Line: <&lt>:l40px:756574815875366913<&gt><script[github_data].parsed_key[l].repeat[10]><&lt>:r40px:756574816118636554<&gt>

  #@old:
  #^  - define Map <util.parse_yaml[{"Data":<context.query>}].get[Data]>
  #^  - if <[Map].contains[action]>:
  #|    #| pull requests can be any of:
  #|    #| opened|edited|closed|assigned|unassigned|review_requested|review_request_removed|ready_for_review|labeled|unlabeled|synchronize|locked|unlocked|reopened
  #|    #| If the action is closed and the pull_request.merged key is true, the pull request was merged.
  #|    #| If the action is closed and the pull_request.merged key is false, the pull request was closed with unmerged commits.
  #^
  #^    - if <[Map].contains[pull_request]>:
  #^    - if <[Map].get[action]> == opened:
  #^      - announce to_console "<&a>---- Pull request was created. ---------------------------------------"
  #^      - stop
  #^    - else if <[Map].get[action]> == closed && <[Map].get[pull_request].get[merged]> == true:
  #^      - announce to_console "<&a>---- Pull request was closed with ummerged commits. ------------------"
  #^      - stop
  #^    - else if <[Map].get[action]> == closed && <[Map].get[pull_request].get[merged]> == true:
  #^      - announce to_console "<&a>---- Pull request was merged. ----------------------------------------"
  #|    #| pull request reviews:
  #^    - else if <[Map].get[Action]> == submitted:
  #^      - announce to_console "<&a>---- A pull request review is submitted into a non-pending state. ----"
  #^      - stop
  #^    - else if <[Map].get[Action]> == edited:
  #^      - announce to_console "<&a>---- The body of a review has been edited. ---------------------------"
  #^      - stop
  #^    - else if <[Map].get[Action]> == dismissed:
  #^      - announce to_console "<&a>---- A review has been dismissed. ------------------------------------"
  #^      - stop
  #^
  #|    #| Issues:
  #|    #| opened|edited|deleted|pinned|unpinned|closed|reopened|assigned|unassigned|labeled|unlabeled|locked|unlocked|transferred|milestoned|demilestoned.
  #^    - else if <[Map].contains[issue]>:
  #^      - choose <[Map].get[action]>:
  #^      - case opened:
  #^        - announce to_console "<&a>---- New issued was created. -------------------------------------"
  #^      - case closed:
  #^        - announce to_console "<&a>---- New issued was closed. --------------------------------------"
  #^      - stop
  #^
  #^    - else if <[Map].contains[ref|ref_type]> && <[Map].get[ref_type]> == branch:
  #^    - if <[Map].contains[master_branch]>:
  #^      - announce to_console "<&a>---- New branch was created. -----------------------------------------"
  #^    - else:
  #^      - announce to_console "<&a>---- Branch was deleted. ---------------------------------------------"
  #^    - stop
  #^
  #^  - shell <yaml[shell].read[file.git_pull]> <context.request.after[github/]>

Emoji_Bullets:
  type: procedure
  debug: false
  definitions: text|emoji
  script:
    - define text "<[text].replace_text[\r<n>- ].with[<[emoji]> ].replace_text[<n>- ].with[<[emoji]> ]>"
    - define strings <list>
    - foreach <[text].split[```]> as:string:
      - if <[loop_index].is_odd>:
        - define strings <[strings].include_single[<[string]>]>
      - else:
        - define strings "<[strings].include_single[```<[string].replace_text[<[Emoji]>].with[- ]>```]>"
    - determine <[strings].unseparated>

GCF:
  type: procedure
  debug: false
  definitions: int|symbol
  script:
    - if <[int]> == 0:
      - determine <[int]>
    - else if <util.list_numbers_to[9].contains[<[int]>]>:
      - determine <[symbol].repeat[1]><[int]>
    - else if <[int]> < 60:
      - determine <[symbol].repeat[2]><[int]>
    - else:
      - determine <[symbol].repeat[3]><[int]>
