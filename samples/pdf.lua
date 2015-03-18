package.path = package.path .. ";?.lua;"

local wklua = require("wklua").create(true)

wklua.settings = {
  out = "result.pdf",
  load = {
    cookieJar = "myjar.jar"
  },
  page = "http://luajit.org/" -- or C:/path/to/local/file
}

wklua:pdf()
