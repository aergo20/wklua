---
-- wklua
-- wkhtmltopdf ffi wrapper for LuaJIT
-- @version 1.0
-- @date 03/18/2015
-- @author Evandro Costa <evandro.co>
-- @license MIT <opensource.org/licenses/MIT>

local ffi, string = require("ffi"), string

ffi.cdef [[
struct wkhtmltopdf_global_settings;
typedef struct wkhtmltopdf_global_settings wkhtmltopdf_global_settings;
struct wkhtmltopdf_object_settings;
typedef struct wkhtmltopdf_object_settings wkhtmltopdf_object_settings;
struct wkhtmltopdf_converter;
typedef struct wkhtmltopdf_converter wkhtmltopdf_converter;
typedef void (__stdcall *wkhtmltopdf_str_callback)(wkhtmltopdf_converter * converter, const char * str);
typedef void (__stdcall *wkhtmltopdf_int_callback)(wkhtmltopdf_converter * converter, const int val);
typedef void (__stdcall *wkhtmltopdf_void_callback)(wkhtmltopdf_converter * converter);
int wkhtmltopdf_init(int use_graphics);
int wkhtmltopdf_deinit();
int wkhtmltopdf_extended_qt();
const char * wkhtmltopdf_version();
wkhtmltopdf_global_settings * wkhtmltopdf_create_global_settings();
void wkhtmltopdf_destroy_global_settings(wkhtmltopdf_global_settings *);
wkhtmltopdf_object_settings * wkhtmltopdf_create_object_settings();
void wkhtmltopdf_destroy_object_settings(wkhtmltopdf_object_settings *);
int wkhtmltopdf_set_global_setting(wkhtmltopdf_global_settings * settings, const char * name, const char * value);
int wkhtmltopdf_get_global_setting(wkhtmltopdf_global_settings * settings, const char * name, char * value, int vs);
int wkhtmltopdf_set_object_setting(wkhtmltopdf_object_settings * settings, const char * name, const char * value);
int wkhtmltopdf_get_object_setting(wkhtmltopdf_object_settings * settings, const char * name, char * value, int vs);
wkhtmltopdf_converter * wkhtmltopdf_create_converter(wkhtmltopdf_global_settings * settings);
void wkhtmltopdf_destroy_converter(wkhtmltopdf_converter * converter);
void wkhtmltopdf_set_warning_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_str_callback cb);
void wkhtmltopdf_set_error_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_str_callback cb);
void wkhtmltopdf_set_phase_changed_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_void_callback cb);
void wkhtmltopdf_set_progress_changed_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_int_callback cb);
void wkhtmltopdf_set_finished_callback(wkhtmltopdf_converter * converter, wkhtmltopdf_int_callback cb);
int wkhtmltopdf_convert(wkhtmltopdf_converter * converter);
void wkhtmltopdf_add_object(wkhtmltopdf_converter * converter, wkhtmltopdf_object_settings * setting, const char * data);
int wkhtmltopdf_current_phase(wkhtmltopdf_converter * converter);
int wkhtmltopdf_phase_count(wkhtmltopdf_converter * converter);
const char * wkhtmltopdf_phase_description(wkhtmltopdf_converter * converter, int phase);
const char * wkhtmltopdf_progress_string(wkhtmltopdf_converter * converter);
int wkhtmltopdf_http_error_code(wkhtmltopdf_converter * converter);
long wkhtmltopdf_get_output(wkhtmltopdf_converter * converter, const unsigned char **);
struct wkhtmltoimage_global_settings;
typedef struct wkhtmltoimage_global_settings wkhtmltoimage_global_settings;
struct wkhtmltoimage_converter;
typedef struct wkhtmltoimage_converter wkhtmltoimage_converter;
typedef void (__stdcall *wkhtmltoimage_str_callback)(wkhtmltoimage_converter * converter, const char * str);
typedef void (__stdcall *wkhtmltoimage_int_callback)(wkhtmltoimage_converter * converter, const int val);
typedef void (__stdcall *wkhtmltoimage_void_callback)(wkhtmltoimage_converter * converter);
int wkhtmltoimage_init(int use_graphics);
int wkhtmltoimage_deinit();
int wkhtmltoimage_extended_qt();
const char * wkhtmltoimage_version();
wkhtmltoimage_global_settings * wkhtmltoimage_create_global_settings();
int wkhtmltoimage_set_global_setting(wkhtmltoimage_global_settings * settings, const char * name, const char * value);
int wkhtmltoimage_get_global_setting(wkhtmltoimage_global_settings * settings, const char * name, char * value, int vs);
wkhtmltoimage_converter * wkhtmltoimage_create_converter(wkhtmltoimage_global_settings * settings, const char * data);
void wkhtmltoimage_destroy_converter(wkhtmltoimage_converter * converter);
void wkhtmltoimage_set_warning_callback(wkhtmltoimage_converter * converter, wkhtmltoimage_str_callback cb);
void wkhtmltoimage_set_error_callback(wkhtmltoimage_converter * converter, wkhtmltoimage_str_callback cb);
void wkhtmltoimage_set_phase_changed_callback(wkhtmltoimage_converter * converter, wkhtmltoimage_void_callback cb);
void wkhtmltoimage_set_progress_changed_callback(wkhtmltoimage_converter * converter, wkhtmltoimage_int_callback cb);
void wkhtmltoimage_set_finished_callback(wkhtmltoimage_converter * converter, wkhtmltoimage_int_callback cb);
int wkhtmltoimage_convert(wkhtmltoimage_converter * converter);
int wkhtmltoimage_current_phase(wkhtmltoimage_converter * converter);
int wkhtmltoimage_phase_count(wkhtmltoimage_converter * converter);
const char * wkhtmltoimage_phase_description(wkhtmltoimage_converter * converter, int phase);
const char * wkhtmltoimage_progress_string(wkhtmltoimage_converter * converter);
int wkhtmltoimage_http_error_code(wkhtmltoimage_converter * converter);
long wkhtmltoimage_get_output(wkhtmltoimage_converter * converter, const unsigned char **);
]]

local wk = ffi.load("wkhtmltox")

function parse(reference, from, to)
  local settings = {}
  for key, value in pairs(from) do
    if type(value) == "table" then
      for key2, value2 in pairs(value) do
        settings[tostring(key) .. "." .. tostring(key2)] = tostring(value2)
      end
    else
      settings[tostring(key)] = tostring(value)
    end
  end
  for key, value in pairs(settings) do
    to(reference, key, value)
  end
  return reference
end

local wklua = {}
wklua.__index = wklua

function wklua.create(callbacks, graphics)
  local self = {}
  setmetatable(self, wklua)

  self.settings = {}
  self.graphics = graphics and 1 or 0
  if callbacks then
    -- self.version = function(lib, value) print(string.upper(lib), value) end
    self.progress = function(_, value) print(value) end
    self.phase = function(value) print(value) end
    self.error = function(value) print("Error", value) end
    self.warning = function(value) print("Warning", value) end
    self.http = function(value) print("HTTP Error Code", value) end
  end

  return self
end

function wklua:image(from, to)

  assert(self.settings, "You need to call \"create()\" first")

  if from then self.settings["in"] = from end
  if to then self.settings.out = to end

  if (not self.settings.fmt) and to then
    self.settings.fmt = string.match(to, "([^%.]+)$")
  end

  if self.settings["in"] and (self.settings["in"] == "-") then
    return false, "Invalid setting: \"in\""
  end

  if self.settings.out and (self.settings.out == "-" or self.settings.out == "") then
    return false, "Invalid setting: \"out\""
  end

  wk.wkhtmltoimage_init(self.graphics)

  if self.version then
    self.version("image", ffi.string(wk.wkhtmltoimage_version()))
  end

  local gs = wk.wkhtmltoimage_create_global_settings()
  parse(gs, self.settings, wk.wkhtmltoimage_set_global_setting)

  local converter =  wk.wkhtmltoimage_create_converter(gs, nil)

  local converter_progress, converter_phase, converter_error, converter_warning

  if self.progress then
    converter_progress = ffi.cast("wkhtmltoimage_int_callback", function(_, value)
      self.progress(value, string.format("%3d%%", value))
    end)
    wk.wkhtmltoimage_set_progress_changed_callback(converter, converter_progress)
  end

  if self.phase then
    converter_phase = ffi.cast("wkhtmltoimage_void_callback", function(value)
      self.phase(ffi.string(wk.wkhtmltoimage_phase_description(value, wk.wkhtmltoimage_current_phase(value))))
    end)
    wk.wkhtmltoimage_set_phase_changed_callback(converter, converter_phase)
  end

  if self.error then
    converter_error = ffi.cast("wkhtmltoimage_str_callback", function(_, value)
      self.error(ffi.string(value))
    end)
    wk.wkhtmltoimage_set_error_callback(converter, converter_error)
  end

  if self.warning then
    converter_warning = ffi.cast("wkhtmltoimage_str_callback", function(_, value)
      self.warning(ffi.string(value))
    end)
    wk.wkhtmltoimage_set_warning_callback(converter, converter_warning)
  end

  wk.wkhtmltoimage_convert(converter)

  if self.http then
    self.http(wk.wkhtmltoimage_http_error_code(converter))
  end

  wk.wkhtmltoimage_destroy_converter(converter)
  wk.wkhtmltoimage_deinit()

  if converter_progress then converter_progress:free() end
  if converter_phase then converter_phase:free() end
  if converter_error then converter_error:free() end
  if converter_warning then converter_warning:free() end

  return true

end

function wklua:pdf(from, to)

  assert(self.settings, "You need to call \"create()\" first")

  if from then self.settings.page = from end
  if to then self.settings.out = to end

  if self.settings.page and (self.settings.page == "-") then
    return false, "Invalid setting: \"page\""
  end

  if self.settings.out and (self.settings.out == "-" or self.settings.out == "") then
    return false, "Invalid setting: \"out\""
  end

  wk.wkhtmltopdf_init(self.graphics)

  if self.version then
    self.version("pdf", ffi.string(wk.wkhtmltopdf_version()))
  end

  local gs = wk.wkhtmltopdf_create_global_settings()
  parse(gs, self.settings, wk.wkhtmltopdf_set_global_setting)
  local os = wk.wkhtmltopdf_create_object_settings()
  parse(os, self.settings, wk.wkhtmltopdf_set_object_setting)

  local converter = wk.wkhtmltopdf_create_converter(gs)

  local converter_progress, converter_phase, converter_error, converter_warning

  if self.progress then
    converter_progress = ffi.cast("wkhtmltopdf_int_callback", function(_, value)
      self.progress(value, string.format("%3d%%", value))
    end)
    wk.wkhtmltopdf_set_progress_changed_callback(converter, converter_progress)
  end

  if self.phase then
    converter_phase = ffi.cast("wkhtmltopdf_void_callback", function(value)
      self.phase(ffi.string(wk.wkhtmltopdf_phase_description(value, wk.wkhtmltopdf_current_phase(value))))
    end)
    wk.wkhtmltopdf_set_phase_changed_callback(converter, converter_phase)
  end

  if self.error then
    converter_error = ffi.cast("wkhtmltopdf_str_callback", function(_, value)
      self.error(ffi.string(value))
    end)
    wk.wkhtmltopdf_set_error_callback(converter, converter_error)
  end

  if self.warning then
    converter_warning = ffi.cast("wkhtmltopdf_str_callback", function(_, value)
      self.warning(ffi.string(value))
    end)
    wk.wkhtmltopdf_set_warning_callback(converter, converter_warning)
  end

  wk.wkhtmltopdf_add_object(converter, os, nil)
  wk.wkhtmltopdf_convert(converter)

  if self.http then
    self.http(wk.wkhtmltopdf_http_error_code(converter))
  end

  wk.wkhtmltopdf_destroy_converter(converter)
  wk.wkhtmltopdf_deinit()

  if converter_progress then converter_progress:free() end
  if converter_phase then converter_phase:free() end
  if converter_error then converter_error:free() end
  if converter_warning then converter_warning:free() end

  return true

end

return wklua
