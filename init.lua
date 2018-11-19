-- Torchbear Static Webserver

function file_ext(file)
  return file:match("^.+(%..+)$")
end

-- Handler function
return function (request)
  
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
  -- TODO: Have a function to match the content-type with the extension
    if file_ext(request.path) == ".htm" or file_ext(request.path) == ".html" then
      return {
          headers = {
            ["content-type"] = "text/html",
          },
          body = fs.read_file("static/" .. request.path)
      }
    else
      return {
        headers = {
          ["content-type"] = "application/octet-stream",
        },
        body = fs.read_file("static/" .. request.path)
      }
    end
  else

    local contents = fs.read_dir("./static/" .. request.path) or {}

    return {
          headers = {
            ["content-type"] = "text/html",
          },
          body = render("index.html", {
            contents = contents,
          })
      }
  end
  
end
