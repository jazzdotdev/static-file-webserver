#!/usr/bin/env torchbear
-- Simple Webserver · Torchbear App

web_path = table.remove(arg, 2) or ""

if torchbear.os == "android" then
  default_path = "/data/data/com.termux/files/usr/share/simple-webserver/" 
elseif torchbear.os == "linux" then
  default_path = "/usr/share/simple-webserver/"
end

if not fs.exists(default_path) then
  _log.error("Path does not exist")
end

_log.info("Initialize web server")

if not fs.exists(web_path) then
  web_path = default_path .. "/static/"
end

templates_path = default_path .. "/templates/"

-- Handler function
return function (request)

  _log.info("Handle request")
  
  if not fs.exists(web_path .. request.path) then
    return {
      headers = {
        ["content-type"] = "application/json",
      },
      body = json.from_table({
        message = "No such file or directory",
        status = 404
      })
    }
  end

  if fs.is_file(web_path .. request.path) then

    local _mime = mime.guess_mime_type(request.path)
    return {
        headers = {
          ["content-type"] = _mime,
        },
        body = fs.read_file(web_path .. request.path)
    }

  else

    local contents = fs.read_dir(web_path .. request.path) or {}
    
    -- Remember to use a glob when using tera to render
    local _tera = tera.new(templates_path .. "/*")
    return {
          headers = {
            ["content-type"] = "text/html",
          },
          body = _tera:render("index.html", {
            contents = contents,
          })
      }
  end
  
end
