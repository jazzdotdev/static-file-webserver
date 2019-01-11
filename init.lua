#!/usr/bin/env torchbear
-- Simple Webserver · Torchbear App

_log.info("Initialize web server")

-- Handler function
return function (request)

  _log.info("Handle request")
  
  if not fs.exists("./static/" .. request.path) then
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

  if fs.is_file("./static/" .. request.path) then

    local _mime = mime.guess_mime_type(request.path)
    return {
        headers = {
          ["content-type"] = _mime,
        },
        body = fs.read_file("static/" .. request.path)
    }

  else

    local contents = fs.read_dir("./static/" .. request.path) or {}
    
    -- Remember to use a glob when using tera to render
    local _tera = tera.new("./templates/*")
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
