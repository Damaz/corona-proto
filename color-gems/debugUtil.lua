printTileValues = function(tile)
  local DEBUG_FLAG = true
  if (DEBUG_FLAG) then
    if (tile ~= nil) then
      print ("*** tile ***")
      --for key,value in pairs(tile) do
--         print(key,value)
--      end
      --print("Position (x,y) : " .. tile.x .. "," .. tile.y)
      print("Position (Row,Column) : " .. tile.row .. "," .. tile.col)
      print("Value  : " .. tile.value)
      print("Level  : " .. tile.level)
    end
  end
end

printItemValues = function(item)
  local DEBUG_FLAG = false
  if (DEBUG_FLAG) then
    if (item ~= nil) then
      print ("*** item ***")
      print("Value : " .. item.value)
      print("Level  : " .. item.level)
    end
  end
end

printMsg = function(msg)
  local DEBUG_FLAG = false
  if (DEBUG_FLAG) then
    if (msg ~= nil) then
      print(msg)
    end
  end
end

printGrid = function(grid)
  local DEBUG_FLAG = true
  if (DEBUG_FLAG) then
    if (grid ~= nil) then
      print("********* GRID *********")
      for key,value in pairs(grid) do
        for rowKey, rowValue in pairs(grid[key]) do
          if(rowValue.value ~= "empty") then
            printTileValues(rowValue)
          end
        end
      end
          
    end 
  end
end