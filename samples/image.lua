package.path = package.path .. ";?.lua;"

local wklua = require("wklua").create(true)

wklua.settings = {
  out = "result.jpg",
  ["in"] = "http://luajit.org/" -- or file://path/to/local/file
}

wklua:image()
