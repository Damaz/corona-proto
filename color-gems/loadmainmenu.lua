-- 
-- Abstract: Ghosts Vs Monsters sample project 
-- Designed and created by Jonathan and Biffy Beebe of Beebe Games exclusively for Ansca, Inc.
-- http://beebegamesonline.appspot.com/

-- (This is easiest to play on iPad or other large devices, but should work on all iOS and Android devices)
-- 
-- Version: 1.1
-- 
-- Sample code is MIT licensed, see http://developer.anscamobile.com/code/license
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.

module(..., package.seeall)

-- Main function - MUST return a display.newGroup()
function new()
	local localGroup = display.newGroup()
	local loadingImage
	local theTimer
  
  local loadingAnimation_1
  local loadingAnimation_2
  local loadingAnimation_3
  local loadingAnimation_4
  local loadingAnimation_5
  
  local animationAngle = 0
  local animationCenterX = display.contentCenterX
  local animationCenterY = display.contentCenterY
  local animationRadius = 50
	
  local calculateCirclePos = function(angleDegree, radius)
    local newPosX = animationCenterX + radius * math.cos(math.rad(angleDegree))
    local newPosY = animationCenterY + radius * math.sin(math.rad(angleDegree))
    return newPosX,newPosY
  end
  
	local showLoadingScreen = function()
    loadingImage = display.newImageRect( "resources/images/display/background.png", display.contentWidth, display.contentHeight )
    loadingImage:setReferencePoint(display.CenterReferencePoint)
    loadingImage.x = display.contentCenterX
    loadingImage.y = display.contentCenterY 
		
    local messageText = display.newText("LOADING", 0, 0, MAIN_FONT, 120)
    messageText:setTextColor(0,0,0,255)
    messageText.xScale = 0.5
    messageText.yScale = 0.5
    messageText:setReferencePoint(display.CenterReferencePoint)
    messageText.x = display.contentCenterX
    messageText.y = display.contentCenterY - 150
    
    loadingAnimation_1 = display.newImageRect( "resources/images/sixthLevel/black.png", 50, 50 )
    loadingAnimation_1:setReferencePoint(display.CenterReferencePoint)
    
    loadingAnimation_2 = display.newImageRect( "resources/images/sixthLevel/black.png", 40, 40 )
    loadingAnimation_2:setReferencePoint(display.CenterReferencePoint)
    
    loadingAnimation_3 = display.newImageRect( "resources/images/sixthLevel/black.png", 30, 30 )
    loadingAnimation_3:setReferencePoint(display.CenterReferencePoint)
    
    loadingAnimation_4 = display.newImageRect( "resources/images/sixthLevel/black.png", 20, 20 )
    loadingAnimation_4:setReferencePoint(display.CenterReferencePoint)
    
    loadingAnimation_5 = display.newImageRect( "resources/images/sixthLevel/black.png", 10, 10 )
    loadingAnimation_5:setReferencePoint(display.CenterReferencePoint)
    
    localGroup:insert(loadingImage)
    localGroup:insert(messageText)
    localGroup:insert(loadingAnimation_1)
    localGroup:insert(loadingAnimation_2)
    localGroup:insert(loadingAnimation_3)
    localGroup:insert(loadingAnimation_4)
    localGroup:insert(loadingAnimation_5)
    
		local goToLevel = function()
			director:changeScene( "mainmenu" )
		end
		
		theTimer = timer.performWithDelay( 2000, goToLevel, 1 )

	end

  local animateLoadingScreen = function(event)
    
    local loadingAnim_1ImgX, loadingAnim_1ImgY = calculateCirclePos(animationAngle, animationRadius)
    local loadingAnim_2ImgX, loadingAnim_2ImgY = calculateCirclePos(animationAngle - 50, animationRadius)
    local loadingAnim_3ImgX, loadingAnim_3ImgY = calculateCirclePos(animationAngle - 90, animationRadius)
    local loadingAnim_4ImgX, loadingAnim_4ImgY = calculateCirclePos(animationAngle - 120, animationRadius)
    local loadingAnim_5ImgX, loadingAnim_5ImgY = calculateCirclePos(animationAngle - 140, animationRadius)
    loadingAnimation_1.x = loadingAnim_1ImgX; loadingAnimation_1.y = loadingAnim_1ImgY
    loadingAnimation_2.x = loadingAnim_2ImgX; loadingAnimation_2.y = loadingAnim_2ImgY
    loadingAnimation_3.x = loadingAnim_3ImgX; loadingAnimation_3.y = loadingAnim_3ImgY
    loadingAnimation_4.x = loadingAnim_4ImgX; loadingAnimation_4.y = loadingAnim_4ImgY
    loadingAnimation_5.x = loadingAnim_5ImgX; loadingAnimation_5.y = loadingAnim_5ImgY
    
    animationAngle = (animationAngle + 2)%360
    
  end
  
	showLoadingScreen()
	Runtime:addEventListener( "enterFrame", animateLoadingScreen );
  
	clean = function()
		
		if theTimer then timer.cancel( theTimer ); end	
    
		if loadingImage then
			--loadingImage:removeSelf()
			display.remove( loadingImage )
			loadingImage = nil
		end
    if loadingAnimation_1 then
			--loadingImage:removeSelf()
			display.remove( loadingAnimation_1 )
			loadingAnimation_1 = nil
		end
    if loadingAnimation_2 then
			--loadingImage:removeSelf()
			display.remove( loadingAnimation_2 )
			loadingAnimation_2 = nil
		end
    if loadingAnimation_3 then
			--loadingImage:removeSelf()
			display.remove( loadingAnimation_3 )
			loadingAnimation_3 = nil
		end
    if loadingAnimation_4 then
			--loadingImage:removeSelf()
			display.remove( loadingAnimation_4 )
			loadingAnimation_3 = nil
		end
    if loadingAnimation_5 then
			--loadingImage:removeSelf()
			display.remove( loadingAnimation_5 )
			loadingAnimation_5 = nil
		end
    Runtime:removeEventListener( "enterFrame", animateLoadingScreen )
    
	end
	
	-- MUST return a display.newGroup()
	return localGroup
end
