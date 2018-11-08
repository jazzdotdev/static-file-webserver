-- left in due to "fs.entries" not working

_G.file = require "fs"

function file_ext(file)
  return file:match("^.+(%..+)$")
end

-- Handler function
return function (request)
  
  local content = {
    dirs = file.directory_list("./static/" .. request.path), 
    files = file.get_all_files_in("./static/" .. request.path)
  }
  
  if fs.is_file("./static/" .. request.path) then
  -- TODO: Have a function to match the content-type with the extension
    if file_ext(request.path) == ".htm" or file_ext(request.path) == ".html" then
      return {
          headers = {
            ["content-type"] = "text/html",
          },
          body = file.read_file("static/" .. request.path)
      }
    else
      return {
        headers = {
          ["content-type"] = "application/octet-stream",
        },
        body = file.read_file("static/" .. request.path)
      }
    end
  else
    return {
          headers = {
            ["content-type"] = "text/html",
          },
          body = render("index.html", {
            dirs = content.dirs,
            files = content.files
          })
      }
  end



  
end
