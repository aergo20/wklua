# wklua
* Take screenshots of websites
* Save any website to a PDF file

## Requirements
* LuaJIT

## Installation
* Download this repository
* [Download the wkhtmltopdf binary](http://wkhtmltopdf.org/downloads.html) and put in the same folder

## Usage
```lua

local wklua = require("wklua").create(true)

wklua.settings = {

  -- Web page specific settings

  web = {
    background = "", -- Should we print the background? Must be either "true" or "false".
    loadImages = "", -- Should we load images? Must be either "true" or "false".
    enableJavascript = "", -- Should we enable javascript? Must be either "true" or "false".
    enableIntelligentShrinking = "", -- Should we enable intelligent shrinkng to fit more content on one page? Must be either "true" or "false". Has no effect for wkhtmltoimage.
    minimumFontSize = "", -- The minimum font size allowed. E.g. "9"
    printMediaType = "", -- Should the content be printed using the print media type instead of the screen media type. Must be either "true" or "false". Has no effect for wkhtmltoimage.
    defaultEncoding = "", -- What encoding should we guess content is using if they do not specify it properly? E.g. "utf-8"
    userStyleSheet = "", -- Url er path to a user specified style sheet.
    enablePlugins = "" -- Should we enable NS plugins, must be either "true" or "false". Enabling this will have limited success.
  },

  -- Object Specific loading settings

  load = {
    username = "", -- The user name to use when loging into a website, E.g. "bart"
    password = "", -- The password to used when logging into a website, E.g. "elbarto"
    jsdelay = "", -- The mount of time in milliseconds to wait after a page has done loading until it is actually printed. E.g. "1200". We will wait this amount of time or until, javascript calls window.print().
    zoomFactor = "", -- How much should we zoom in on the content? E.g. "2.2".
    customHeaders = "", -- TODO
    repertCustomHeaders = "", -- Should the custom headers be sent all elements loaded instead of only the main page? Must be either "true" or "false".
    cookies = "", -- TODO
    post = "", -- TODO
    blockLocalFileAccess = "", -- Disallow local and piped files to access other local files. Must be either "true" or "false".
    stopSlowScript = "", -- Stop slow running javascript. Must be either "true" or "false".
    debugJavascript = "", -- Forward javascript warnings and errors to the warning callback. Must be either "true" or "false".
    loadErrorHandling = "", -- How should we handle obejcts that fail to load. Must be one of:
    -- "abort" Abort the convertion process
    -- "skip" Do not add the object to the final output
    -- "ignore" Try to add the object to the final output.
    proxy = "", -- String describing what proxy to use when loading the object.
    runScript = "", -- TODO
    cookieJar = "" -- Path of file used to load and store cookies.
  },

  -- Header and footer settings

  header = {
    fontSize = "", -- The font size to use for the header, e.g. "13"
    fontName = "", -- The name of the font to use for the header. e.g. "times"
    left = "", -- The string to print in the left part of the header, note that some sequences are replaced in this string, see the wkhtmltopdf manual.
    center = "", -- The text to print in the center part of the header.
    right = "", -- The text to print in the right part of the header.
    line = "", -- Whether a line should be printed under the header (either "true" or "false").
    spacing = "", -- The amount of space to put between the header and the content, e.g. "1.8". Be aware that if this is too large the header will be printed outside the pdf document. This can be corrected with the margin.top setting.
    htmlUrl = "" -- Url for a HTML document to use for the header.
  },

  -- Pdf global settings

  size = {
    paperSize = "", -- The paper size of the output document, e.g. "A4".
    width = "", -- The with of the output document, e.g. "4cm".
    height = "" -- The height of the output document, e.g. "12in".
  },
  orientation = "", -- The orientation of the output document, must be either "Landscape" or "Portrait".
  colorMode = "", -- Should the output be printed in color or gray scale, must be either "Color" or "Grayscale"
  resolution = "", -- Most likely has no effect.
  dpi = "", -- What dpi should we use when printing, e.g. "80".
  pageOffset = "", -- A number that is added to all page numbers when printing headers, footers and table of content.
  copies = "", -- How many copies should we print?. e.g. "2".
  collate = "", -- Should the copies be collated? Must be either "true" or "false".
  outline = "", -- Should a outline (table of content in the sidebar) be generated and put into the PDF? Must be either "true" or false".
  outlineDepth = "", -- The maximal depth of the outline, e.g. "4".
  dumpOutline = "", -- If not set to the empty string a XML representation of the outline is dumped to this file.
  out = "", -- The path of the output file, if "-" output is sent to stdout, if empty the output is stored in a buffer.
  documentTitle = "", -- The title of the PDF document.
  useCompression = "", -- Should we use loss less compression when creating the pdf file? Must be either "true" or "false".
  margin = {
    top = "", -- Size of the top margin, e.g. "2cm"
    bottom = "", -- Size of the bottom margin, e.g. "2cm"
    left = "", -- Size of the left margin, e.g. "2cm"
    right = "" -- Size of the right margin, e.g. "2cm"
  },
  margin.right = "", -- Size of the right margin, e.g. "2cm"
  imageDPI = "", -- The maximal DPI to use for images in the pdf document.
  imageQuality = "", -- The jpeg compression factor to use when producing the pdf document, e.g. "92".

  -- Pdf object settings

  toc = {
    useDottedLines = "", -- Should we use a dotted line when creating a table of content? Must be either "true" or "false".
    captionText = "", -- The caption to use when creating a table of content.
    forwardLinks = "", -- Should we create links from the table of content into the actual content? Must be either "true or "false.
    backLinks = "", -- Should we link back from the content to this table of content.
    indentation = "", -- The indentation used for every table of content level, e.g. "2em".
    fontScale = "" -- How much should we scale down the font for every toc level? E.g. "0.8"
  },

  page = "", -- The URL or path of the web page to convert, if "-" input is read from stdin.
  useExternalLinks = "", -- Should external links in the HTML document be converted into external pdf links? Must be either "true" or "false.
  useLocalLinks = "", -- Should internal links in the HTML document be converted into pdf references? Must be either "true" or "false"
  replacements = "", -- TODO
  produceForms = "", -- Should we turn HTML forms into PDF forms? Must be either "true" or file".
  includeInOutline = "", -- Should the sections from this document be included in the outline and table of content?
  pagesCount = "", -- Should we count the pages of this document, in the counter used for TOC, headers and footers?
  tocXsl = "", -- If not empty this object is a table of content object, "page" is ignored and this xsl style sheet is used to convert the outline XML into a table of content.

  --Image settings

  crop = {
    left = "", -- left/x coordinate of the window to capture in pixels. E.g. "200"
    top = "", -- top/y coordinate of the window to capture in pixels. E.g. "200"
    width = "", -- Width of the window to capture in pixels. E.g. "200"
    height = "" -- Height of the window to capture in pixels. E.g. "200"
  },
  transparent = "", -- When outputting a PNG or SVG, make the white background transparent. Must be either "true" or "false"
  ["in"] = "", -- The URL or path of the input file, if "-" stdin is used. E.g. "http://google.com"
  out = "", -- The path of the output file, if "-" stdout is used, if empty the content is stored to a internalBuffer.
  fmt = "", -- The output format to use, must be either "", "jpg", "png", "bmp" or "svg".
  screenWidth = "", -- The with of the screen used to render is pixels, e.g "800".
  smartWidth = "", -- Should we expand the screenWidth if the content does not fit? must be either "true" or "false".
  quality = "" -- The compression factor to use when outputting a JPEG image. E.g. "94". 

}

-- generate a PDF file
wklua:pdf("from", "to") 

-- generate an image
wklua:image("from", "to")

```

## License
```
The MIT License (MIT)

Copyright (c) 2015 Evandro Costa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
