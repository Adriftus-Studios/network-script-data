web_debug:
  type: task
  debug: false
  script:
    - announce execute
  get_response:
    - announce to_console "<&3>-- <queue.script.name> - Get_Response ---------"
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>address<&6><&gt> <&b>| <&3><context.address||<&4>Invalid> <&b>| <&a>Returns the IP address of the device that sent the request."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>request<&6><&gt> <&b>| <&3><context.request||<&4>Invalid> <&b>| <&a>Returns the path that was requested."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>query<&6><&gt> <&b>| <&3><context.query||<&4>Invalid> <&b>| <&a>Returns an ElementTag of the raw query included with the request."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>query_map<&6><&gt> <&b>| <&3><context.query_map||<&4>Invalid> <&b>| <&a>Returns a map of the query."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>user_info<&6><&gt> <&b>| <&3><context.user_info||<&4>Invalid> <&b>| <&a>Returns info about the authenticated user sending the request, if any."
    - announce to_console <&3>-----------------------------------------------
  post_request:
    - announce to_console "<&3>-- <queue.script.name> - Post_Request ---------"
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>address<&6><&gt> <&b>| <&3><context.address||<&c>Invalid> <&b>| <&a>Returns the IP address of the device that sent the request."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>request<&6><&gt> <&b>| <&3><context.request||<&c>Invalid> <&b>| <&a>Returns the path that was requested."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>query<&6><&gt> <&b>| <&3><context.query||<&c>Invalid> <&b>| <&a>Returns a ElementTag of the raw query included with the request."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>query_map<&6><&gt> <&b>| <&3><context.query_map||<&c>Invalid> <&b>| <&a>Returns a map of the query."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>user_info<&6><&gt> <&b>| <&3><context.user_info||<&c>Invalid> <&b>| <&a>Returns info about the authenticated user sending the request, if any."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>upload_name<&6><&gt> <&b>| <&3><context.upload_name||<&c>Invalid> <&b>| <&a>Returns the name of the file posted."
  #^- announce to_console "<&6><&lt><&e>context<&6>.<&e>upload_size_mb<&6><&gt> <&b>| <&3><context.upload_size_mb||<&c>Invalid> <&b>| <&a>returns the size of the upload in MegaBytes (where 1 MegaByte = 1 000 000 Bytes)."
    - announce to_console "<&6><&lt><&e>context<&6>.<&e>headers<&6><&gt> <&b>| <&3><context.headers||<&c>Invalid> <&b>| <&a>Returns a MapTag of the headers of the request."
    - announce to_console <&3>-----------------------------------------------
  webget_response:
    - announce to_console "<&3>-- <queue.script.name> - WebGet_Response ------"
    - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>failed<&6><&gt> <&b>| <&3><entry[response].failed||<&c>Invalid> <&b>| <&a>returns whether the webget failed. A failure occurs when the status is no..."
    - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>result<&6><&gt> <&b>| <&3><entry[response].result||<&c>Invalid> <&b>| <&a>returns the result of the webget. This is null only if webget failed to connect to the url."
    - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>status<&6><&gt> <&b>| <&3><entry[response].status||<&c>Invalid> <&b>| <&a>returns the HTTP status code of the webget. This is null only if webget failed to connect to the url."
    - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>time_ran<&6><&gt> <&b>| <&3><entry[response].time_ran||<&c>Invalid> <&b>| <&a>returns a DurationTag indicating how long the web connection processing took."
    - announce to_console "<&6><&lt><&e>entry<&6>[<&e>response<&6>].<&e>result_headers<&6><&gt> <&b>| <&3><entry[response].result_headers||<&c>Invalid> <&b>| <&a>returns a MapTag of the headers returned from the webserver. Every value in the result is a list."
    - announce to_console <&3>-----------------------------------------------
