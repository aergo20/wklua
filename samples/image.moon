package.path ..= ";?.lua;"
wklua = require"wklua".create true
wklua.settings =
  out: "result.jpg"
  in: "http://luajit.org/" -- or C:/path/to/local/file
wklua\image!
