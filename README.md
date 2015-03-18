# wklua
wkhtmltopdf ffi wrapper for LuaJIT

## Requirements
* LuaJIT

## Installation
* [Download this repository](https://github.com/evandro92/wklua/archive/master.zip)
* [Download the wkhtmltopdf binary](http://wkhtmltopdf.org/downloads.html) and put in the same folder

## Usage
```lua

local wklua = require("wklua").create(true)

wklua.settings = {
  -- see settings
}

-- generate a PDF file
wklua:pdf("from", "to") 

-- generate an image
wklua:image("from", "to")

```
## Settings
