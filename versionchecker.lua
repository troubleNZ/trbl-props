CreateThread(function(resourceName)
    local resourceName = GetCurrentResourceName()
    PerformHttpRequest('https://raw.githubusercontent.com/troubleNZ/trbl-versions/main/trbl-props.json', function (err, result, headers)
      if not result then return end
      local data  = json.decode(result)
      local version  = data["version"]
      local currentVersion  = GetResourceMetadata(resourceName, "version", 0)
      local upToDateMsg = data["up-to-date"]["message"]
      local updateMsg  = data["requires-update"]["message"]
      if version ~= currentVersion then
        local updMessage = "^3 - Update here: " .. GetResourceMetadata(resourceName, "repository", 0) .. " (current: v" .. currentVersion .. ", newest: v" .. version .. ")^0"
        if data["requires-update"]["important"] and updateMsg ~= nil then
          --print("  ^1Important Message:^0")
          print((updateMsg):format(resourceName))
          print(updMessage)
        elseif updateMsg ~= nil then
          print((updateMsg):format(resourceName) .. "^0")
          print(updMessage)
        end
      elseif upToDateMsg ~= nil then
        print((upToDateMsg):format(resourceName) .. "^0")
      end
    end, 'GET')
  end)