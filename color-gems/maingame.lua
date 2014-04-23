
module(..., package.seeall)

-- Main function - MUST return a display.newGroup()
function new()
  
  local splashDisplayGroup
  local localGroup = display.newGroup()
  local gameGroup = display.newGroup()
	local hudGroup = display.newGroup()
      
  local gemValues = {}
  local maxItemLevel = 6
  local minItemLevel = 1
  
  local itemGrid = {}
  local backgroundGrid = {}
  
  local tilesToDelete = {}
  local tempTilesToDelete = {}
  
  local gameIsActive = false
  local hasChangeOccured = true

  local nextItemInQueue
  local nextItemInQueueTile
  
  local splashscreen
  local restartBtn
  
  -- in ms, the shorter the better
  local droppingSpeed = 2000
  
  require ('itemConfig')
  require ('util')
  require ('debugUtil')
  require ('levelLoader')
  
  local currentLevel = level_1
  
  
  local getRandomColor = function () 
    return gemValues[ math.random( #gemValues ) ]
  end
  
  local getRandomLevel = function () 
  
    local randomLevel = 1
    
    local randomNumber = math.random(1000)
    if (randomNumber == 1) then
      randomLevel = 6
    elseif (randomNumber >= 2 and randomNumber <= 10) then
      randomLevel = 5
    elseif (randomNumber > 10 and randomNumber <= 50) then
      randomLevel = 4
    elseif (randomNumber > 50 and randomNumber <= 150) then
      randomLevel = 3
    elseif (randomNumber > 250 and randomNumber <= 500) then
      randomLevel = 2
    end
    
    
    return math.max(math.min(randomLevel, maxItemLevel), minItemLevel)
  end
  
  -- main game algorithm
  -- warning : self is the background tile linked to the touch event.
  local matchCheck
  matchCheck = function(self)
    printMsg("begin matchCheck")
    
    printTileValues(itemGrid[self.row][self.col])
    
    itemGrid[self.row][self.col].isMarkedToTransform = true
    table.insert(tempTilesToDelete, itemGrid[self.row][self.col])
    
    --check on right
    if (itemGrid[self.row][self.col+1] ~= nil and itemGrid[self.row][self.col+1].isMarkedToTransform == false and itemGrid[self.row][self.col+1].value == itemGrid[self.row][self.col].value and itemGrid[self.row][self.col+1].level == itemGrid[self.row][self.col].level) then 
      printMsg ("right")
      matchCheck(itemGrid[self.row][self.col+1])
    end
    -- check below
    if (itemGrid[self.row+1] ~= nil and itemGrid[self.row+1][self.col].isMarkedToTransform == false and itemGrid[self.row+1][self.col].value == itemGrid[self.row][self.col].value and itemGrid[self.row+1][self.col].level == itemGrid[self.row][self.col].level) then
      printMsg ("below")
      matchCheck(itemGrid[self.row+1][self.col])
    end
    -- check on left
    if (itemGrid[self.row][self.col-1] ~= nil and itemGrid[self.row][self.col-1].isMarkedToTransform == false and itemGrid[self.row][self.col-1].value == itemGrid[self.row][self.col].value and itemGrid[self.row][self.col-1].level == itemGrid[self.row][self.col].level) then
      printMsg ("left")
      matchCheck(itemGrid[self.row][self.col-1])
    end
    -- check above
    if (itemGrid[self.row-1] ~= nil and itemGrid[self.row-1][self.col].isMarkedToTransform == false and itemGrid[self.row-1][self.col].value == itemGrid[self.row][self.col].value and itemGrid[self.row-1][self.col].level == itemGrid[self.row][self.col].level) then
      printMsg ("above")
      matchCheck(itemGrid[self.row-1][self.col])
    end

    printMsg("end matchCheck")
  end
  
  local checkTiles = function(row, col)
    if(itemGrid[row][col].value ~= firstLevelTable["empty"].value and not itemGrid[row][col].isMarkedToTransform) then
      tempTilesToDelete = {}
      matchCheck(itemGrid[row][col])
      if (#tempTilesToDelete >= MATCHING_NUMBER) then
        for key,value in pairs(tempTilesToDelete) do
          table.insert(tilesToDelete, value)
        end
      end 
      for key,value in pairs(tempTilesToDelete) do
          itemGrid[value.row][value.col].isMarkedToTransform = false
      end
    end
  end
  
  local updateTile = function (row, col, item)
    itemGrid[row][col]:removeSelf()
    itemGrid[row][col] = nil
    
    local newItem = display.newImageRect( item.img , GRID_TILE_WIDTH, GRID_TILE_HEIGHT )
    itemGrid[row][col] = newItem
    itemGrid[row][col].x = backgroundGrid[row][col].x
    itemGrid[row][col].y = backgroundGrid[row][col].y
    itemGrid[row][col].level =  item.level
    itemGrid[row][col].value = item.value
    itemGrid[row][col].isMarkedToTransform = false
    itemGrid[row][col].row = row
    itemGrid[row][col].col = col
    hasChangeOccured = true
  end
  
  
  
  
  local dropItem = function (row, col, finalRow, finalCol, item) 
    local newItem = display.newImageRect( item.img , GRID_TILE_WIDTH, GRID_TILE_HEIGHT )
    newItem.x = backgroundGrid[row][col].x
    newItem.y = backgroundGrid[row][col].y
    
    gameIsActive = false
    transition.to(newItem, {x = backgroundGrid[finalRow][finalCol].x, y = backgroundGrid[finalRow][finalCol].y, time = droppingSpeed ,onComplete = function(obj)
          newItem:removeSelf()
          newItem = nil
          updateTile(finalRow, finalCol, item)
          gameIsActive = true
        end
        })
    return finalRow
  end
  
  local dropNewItem = function (col, item)
    local finalRow = 0
    while (itemGrid[finalRow+1] ~= nil and itemGrid[finalRow+1][col] ~= nil and itemGrid[finalRow+1][col].value == firstLevelTable["empty"].value) do
      finalRow = finalRow + 1
    end
    dropItem(0,col, finalRow, col, item)
    return finalRow
  end
  
  
  -- update next item to be placed on grid
  local updateNextItemInQueue = function ()
    nextItemInQueue = getItem(getRandomColor(), getRandomLevel())
    
    local previousPosX = nextItemInQueueTile.x
    local previousPosY = nextItemInQueueTile.y 
    nextItemInQueueTile:removeSelf()
    nextItemInQueueTile = nil
    
    nextItemInQueueTile = display.newImageRect( nextItemInQueue.img , GRID_TILE_WIDTH, GRID_TILE_HEIGHT )
    nextItemInQueueTile.x = previousPosX
    nextItemInQueueTile.y = previousPosY
    
  end
  
  -- delete a the tile from the grid
  local deleteTile = function(tile)
    printMsg("begin deleteTile")
    updateTile(tile.row, tile.col, firstLevelTable["empty"])
    printMsg("end deleteTile")
    return tile.col
  end
  
  gameLoop = function(event)
    if ((event.time%1000) >= 950) then 
      --updateGame()
    end
   --print (event.time%1000 .. " seconds since app started." )
  end
  
  -- update game  
  updateGame = function (column)
    printMsg ("begin updateGame")
    printGrid(itemGrid)
    if (gameIsActive and hasChangeOccured) then
      gameIsActive = false
      hasChangeOccured = false
      for i=0, GRID_ROWS-1, 1 do
        if (column == nil) then
          for j=0, GRID_COLS-1, 1 do
            checkTiles(i,j)
          end
        else
          checkTiles(i,column)
        end
      end
      
      local columnChanged = {}
      if (#tilesToDelete > 0) then
        for key,value in pairs(tilesToDelete) do
          itemGrid[value.row][value.col].isMarkedToTransform = false
          deleteCol = deleteTile(value)
          if(not setContains(columnChanged, deleteCol)) then
            addToSet(columnChanged, deleteCol)
          end
        end
      end
      
      -- reset search for a match
      tilesToDelete = {}
      
      
      for j = 0, GRID_COLS-1, 1 do
        local tilesToMoveDown = {}
        for i=GRID_ROWS-1, 0, -1 do
           if(itemGrid[i][j].value ~= firstLevelTable["empty"].value) then
             table.insert(tilesToMoveDown, itemGrid[i][j])
           end
        end
        if (#tilesToMoveDown > 0) then
          if(not setContains(columnChanged, j)) then
            addToSet(columnChanged, j)
          end
          for m=0, GRID_ROWS -#tilesToMoveDown-1, 1 do
            deleteTile(itemGrid[m][j])
          end
          for n=GRID_ROWS-1 , GRID_ROWS-1-#tilesToMoveDown , -1 do
            if (tilesToMoveDown[GRID_ROWS - n] ~= nil) then  
              local itemToDrop = tilesToMoveDown[GRID_ROWS  - n]
              dropItem(itemToDrop.row, itemToDrop.col, n, j, getItem(itemToDrop.value, itemToDrop.level))
              
            end
          end
        end
      end 
      
     -- local isEmptyTileExist = false
--      local isNotEmptyTileExist = false
--      for i=GRID_ROWS-1, 1, -1 do
--        for j=0, GRID_COLS-1, 1 do
--          local emptyRow = 0
--          if (itemGrid[i][j].value ~= firstLevelTable["empty"].value and itemGrid[i+1] ~= nil and itemGrid[i+1][j] ~= nil and itemGrid[i+1][j].value == firstLevelTable["empty"].value) then
--            isEmptyTileExist = true
--            print ("test")
--          else 
--            isNotEmptyTileExist = true
--          end
--        end
--      end
      --if (not isEmptyTileExist) then
--        printMsg("Lost game")
--        losingSplashScreen()
--      elseif(not isNotEmptyTileExist and currentLevel.victoryCondition == "clean") then
--        printMsg("Won game")
--        winningSplashScreen()
--      end  
      
    end
    gameIsActive = true
    printMsg ("end updateGame")
  end

  
  onTileTouch = function (event)
    if (gameIsActive) then
      if event.phase == "began" then
        -- drop item in queue in touched column
        local finalRow = dropNewItem(event.target.col, nextItemInQueue)
        updateNextItemInQueue()
      elseif event.phase == "ended" then
      end
    end
  end 
  
  onUpdateTouch = function (event)
    if (gameIsActive) then
      if event.phase == "began" then
        updateGame()
      elseif event.phase == "ended" then
      end
    end
  end  
  
  local onScreenTouch = function( event )
    if gameIsActive then
    end
  end
  
  
  local createItemGrid = function(level, itemGrid, displayGroup)
    for i=0, #level.grid-1 do
      itemGrid[i] = {}
      for j=0, #level.grid[i+1]-1 do
        
        local itemInfo = level.grid[i+1][j+1]
        
        local item
        if (itemInfo == "") then
          item = firstLevelTable["empty"]
        else
          item = getItem(string.sub(itemInfo,3), tonumber(string.sub(itemInfo,2,2)))
        end
        itemGrid[i][j] = display.newImageRect( item.img, GRID_TILE_WIDTH, GRID_TILE_HEIGHT )
        itemGrid[i][j].x = (j) * GRID_TILE_WIDTH + horizontalOffset 
        itemGrid[i][j].y = (i) * GRID_TILE_HEIGHT + verticalOffset
        itemGrid[i][j].value = item.value
        itemGrid[i][j].isMarkedToTransform = false
        itemGrid[i][j].row = i
        itemGrid[i][j].col = j
        itemGrid[i][j].level = item.level
        displayGroup:insert( itemGrid[i][j] )
      end
    end
end
  
  
  local initGrid = function()
    printMsg("begin initGrid")
    local i,j
    for i=0, GRID_ROWS-1, 1 do
      itemGrid[i] = {}
      backgroundGrid[i] = {}
      for j=0, GRID_COLS-1, 1 do
        
        -- load background tiles
        local backgroundTile = display.newRect(0,0,38,38)
        backgroundTile.strokeWidth = 2
        backgroundTile.alpha = 0.50
        backgroundTile:setFillColor(171, 171, 171)
        backgroundTile:setStrokeColor(100, 100, 100)
        backgroundTile.isHitTestable = true
        backgroundTile.x = j * GRID_TILE_WIDTH + horizontalOffset 
        backgroundTile.y = i * GRID_TILE_HEIGHT + verticalOffset
        backgroundTile.row = i
        backgroundTile.col = j
        backgroundTile:addEventListener("touch", onTileTouch)
        backgroundGrid[i][j] = backgroundTile
        
        gameGroup:insert( backgroundTile )
      end
    end
    
    
    createItemGrid(currentLevel, itemGrid, gameGroup)
    printMsg("end initGrid")
  end
  
  local initNextItemInQueue = function()
    
    local nextItemInQueueBackground = display.newRect(0,0,38,38)
    nextItemInQueueBackground.strokeWidth = 1
    nextItemInQueueBackground.alpha = 0.50
    nextItemInQueueBackground.x = display.contentWidth / 2
    nextItemInQueueBackground.y = display.contentHeight -30
    nextItemInQueueBackground:setFillColor(171, 171, 171)
    nextItemInQueueBackground:setStrokeColor(100, 100, 100)
    
    gemValues = currentLevel.colors
    maxItemLevel = currentLevel.maxItemLevel
    minItemLevel = currentLevel.minItemLevel
    nextItemInQueue = getItem(getRandomColor(), getRandomLevel())
    
    nextItemInQueueTile = display.newImageRect( nextItemInQueue.img, GRID_TILE_WIDTH, GRID_TILE_HEIGHT )
    nextItemInQueueTile.x = display.contentWidth / 2
    nextItemInQueueTile.y = display.contentHeight -30
    nextItemInQueueTile:addEventListener( "touch", onUpdateTouch )
    
    hudGroup:insert(nextItemInQueueBackground)
    hudGroup:insert(nextItemInQueueTile)
  end
  

  local start = function ()
    -- BACKGROUND IMAGE
    backgroundImage = display.newImageRect( "resources/images/display/background.png", display.contentWidth, display.contentHeight )
    backgroundImage:setReferencePoint(display.CenterReferencePoint)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY
		
		localGroup:insert( backgroundImage )

    initGrid()
    initNextItemInQueue()
    
    --gameGroup:addEventListener("touch", onGridTouch)
    gameGroup:setReferencePoint(display.CenterReferencePoint)
    
--    Runtime:addEventListener( "touch", onScreenTouch )
    gameIsActive = true
    Runtime:addEventListener( "enterFrame", gameLoop )
--		Runtime:addEventListener( "system", onSystem )
  end
  
  local restart = function( event )
    if event.phase == "release" and restartBtn.isActive then		
      gameIsActive = true
      splashDisplayGroup:removeSelf()
      for i=0, GRID_ROWS-1, 1 do
        local rows = itemGrid[i]
        for j=0, GRID_COLS-1, 1 do
          deleteTile(rows[j])
        end
      end
      updateNextItemInQueue()
    end
  end
  
  -- losingSplashScreen
  losingSplashScreen = function()
        
    local splashBox = display.newImage("resources/images/display/splashBox.png")
    splashBox.x = display.contentCenterX; splashBox.y = display.contentCenterY
    transition.from(splashBox, {time = 500, xScale = 0.5, yScale = 0.5, transition = easing.outExpo})
    splashBox.alpha = 0.95
    local conditionDisplay = display.newText("You lose", 0, 0, MAIN_FONT, 62)
    conditionDisplay:setTextColor(0,0,0,255)
    conditionDisplay.xScale = 0.5
    conditionDisplay.yScale = 0.5
    conditionDisplay:setReferencePoint(display.CenterReferencePoint)
    conditionDisplay.x = display.contentCenterX
    conditionDisplay.y = display.contentCenterY - 15
    
    local restartText = display.newText("restart", 0, 0, BUTTON_FONT, 30)
    restartText:setTextColor(255,255,255,255)
    restartText.xScale = 0.5
    restartText.yScale = 0.5
    restartText:setReferencePoint(display.CenterReferencePoint)
    restartText.x = display.contentCenterX
    restartText.y = display.contentCenterY + 15
    
    restartBtn = ui.newButton{
			defaultSrc = "resources/images/display/button.png",
			defaultX = 100,
			defaultY = 25,
			overSrc = "resources/images/display/button-over.png",
			overX = 100,
			overY = 25,
			onEvent = restart,
			id = "PlayButton",
			text = "",
			font = MAIN_FONT,
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}

		restartBtn:setReferencePoint( display.BottomCenterReferencePoint )
		restartBtn.x = display.contentCenterX ;restartBtn.y = display.contentCenterY + 29
		
    
    splashDisplayGroup = display.newGroup()
    splashDisplayGroup:insert(splashBox)
    splashDisplayGroup:insert(conditionDisplay)
    splashDisplayGroup:insert( restartBtn )
    splashDisplayGroup:insert(restartText)
    
  end
  
  -- winningSplashScreen
  winningSplashScreen = function()
        
    local splashBox = display.newImage("resources/images/display/splashBox.png")
    splashBox.x = display.contentCenterX; splashBox.y = display.contentCenterY
    transition.from(splashBox, {time = 500, xScale = 0.5, yScale = 0.5, transition = easing.outExpo})
    splashBox.alpha = 0.95
    local conditionDisplay = display.newText("You win", 0, 0, MAIN_FONT, 72)
    conditionDisplay:setTextColor(0,0,0,255)
    conditionDisplay.xScale = 0.5
    conditionDisplay.yScale = 0.5
    conditionDisplay:setReferencePoint(display.CenterReferencePoint)
    conditionDisplay.x = display.contentCenterX
    conditionDisplay.y = display.contentCenterY - 15
    
    local restartText = display.newText("Next level", 0, 0, BUTTON_FONT, 35)
    restartText:setTextColor(255,255,255,255)
    restartText.xScale = 0.5
    restartText.yScale = 0.5
    restartText:setReferencePoint(display.CenterReferencePoint)
    restartText.x = display.contentCenterX
    restartText.y = display.contentCenterY + 15
    
    restartBtn = ui.newButton{
			defaultSrc = "resources/images/display/button.png",
			defaultX = 100,
			defaultY = 25,
			overSrc = "resources/images/display/button-over.png",
			overX = 100,
			overY = 25,
			onEvent = restart,
			id = "PlayButton",
			text = "",
			font = BUTTON_FONT,
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}

		restartBtn:setReferencePoint( display.BottomCenterReferencePoint )
		restartBtn.x = display.contentCenterX ;restartBtn.y = display.contentCenterY + 29
		
    
    splashDisplayGroup = display.newGroup()
    splashDisplayGroup:insert(splashBox)
    splashDisplayGroup:insert(conditionDisplay)
    splashDisplayGroup:insert( restartBtn )
    splashDisplayGroup:insert(restartText)
    
  end


  start()
	-- MUST return a display.newGroup()
	return localGroup
end