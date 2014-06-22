-- lchan.lua

local http = require 'socket.http'
local thread_url = assert(arg[1], "No url given")
local thread_name = string.match(thread_url, '%d%d%d%d%d%d%d')

os.execute("mkdir " .. thread_name)

local file = ltn12.sink.file(io.open(thread_name .. '/thread_file', 'w'))
http.request {
  url = thread_url,  
  sink = file
}

function readFile()
  local f,err = io.open(thread_name .. '/thread_file', 'r')
  if f == nil then print("Unable to open file " .. err)
  else
    local content = {}
    for line in io.lines(thread_name .. '/thread_file') do 
      content[#content+1] = line
    end
    return content
  end
end 

local imgs = {} -- holds all the images in thread
for i,v in ipairs(readFile()) do
  for ii in string.gmatch(v, '%d%d%d%d%d%d%d%d%d%d%d%d%d%p%a+') do
    imgs[#imgs+1] = ii 
  end
end

local urlStr = "https://i.4cdn.org" .. string.match(thread_url, '/%a/')
for i=1,#imgs do
  local url1 = urlStr .. imgs[i] 
  local file1 = ltn12.sink.file(io.open(thread_name .. '/' .. imgs[i], 'w'))
    http.request {
      url = url1,
      sink = file1
  } 
end
os.remove(thread_name .. '/thread_file')
