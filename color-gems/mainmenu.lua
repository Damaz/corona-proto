module(..., package.seeall)


-- Main function - MUST return a display.newGroup()
function new()
	
	local menuGroup = display.newGroup()
	
	local ui = ui --require("ui")
	
	-- AUDIO
--	local tapSound = audio.loadSound( "tapsound.wav" )
	--local backgroundSound = audio.loadStream( "rainsound.mp3" )	--> This is how you'd load music
	
	local drawScreen = function()
		
		-- BACKGROUND IMAGE
    backgroundImage = display.newImageRect( "resources/images/display/background.png", display.contentWidth, display.contentHeight )
    backgroundImage:setReferencePoint(display.CenterReferencePoint)
    backgroundImage.x = display.contentCenterX
    backgroundImage.y = display.contentCenterY
		
		menuGroup:insert( backgroundImage )

		-- PLAY BUTTON
		local playBtn
		
		local onPlayTouch = function( event )
      if event.phase == "release" and playBtn.isActive then		
--				audio.play( tapSound )
        director:changeScene( "maingame" )
			end
		end
--  
    local messageText = display.newText("COLOR GEMS", 0, 0, MAIN_FONT, 120)
    messageText:setTextColor(0,0,0,255)
    messageText.xScale = 0.5
    messageText.yScale = 0.5
    messageText:setReferencePoint(display.CenterReferencePoint)
    messageText.x = display.contentCenterX
    messageText.y = display.contentCenterY
    menuGroup:insert( messageText )

    playBtn = ui.newButton{
			defaultSrc = "resources/images/display/button.png",
			defaultX = 150,
			defaultY = 37,
			overSrc = "resources/images/display/button-over.png",
			overX = 150,
			overY = 37,
			onEvent = onPlayTouch,
			id = "PlayButton",
			text = "",
			font = MAIN_FONT,
			textColor = { 255, 255, 255, 255 },
			size = 16,
			emboss = false
		}

		playBtn:setReferencePoint( display.BottomCenterReferencePoint )
		playBtn.x = 160 playBtn.y = 323
		menuGroup:insert( playBtn )
    
    local playText = display.newText("Play", 0, 0, BUTTON_FONT, 58)
    playText:setTextColor(255,255,255,255)
    playText.xScale = 0.5
    playText.yScale = 0.5
    playText:setReferencePoint(display.BottomCenterReferencePoint)
    playText.x = 160
    playText.y = 320
    menuGroup:insert( playText )
    
	end
	
	drawScreen()
	--audio.play( backgroundSound, { channel=1, loops=-1, fadein=5000 }  )
	
	
	local cleanSounds = function()
		audio.stop()
		
		if tapSound then
			audio.dispose( tapSound )
			tapSound = nil
		end
	end
	
	clean = function()
		
		--Runtime:removeEventListener( "enterFrame", monitorMem )
		
		--if ghostTween then transition.cancel( ghostTween ); end
--		if ofTween then transition.cancel( ofTween ); end
--		if playTween then transition.cancel( playTween ); end
		
		cleanSounds()
	end
	
	-- MUST return a display.newGroup()
	return menuGroup
end
