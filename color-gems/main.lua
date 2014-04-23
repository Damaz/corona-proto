require("mobdebug").start()
display.setStatusBar( display.HiddenStatusBar )
--display.setDefault( "background", 0, 0, 0 )

local oldTimerCancel = timer.cancel
timer.cancel = function(t) if t then oldTimerCancel(t) end end

local oldRemove = display.remove
display.remove = function( o )
  if o ~= nil then
    
    Runtime:removeEventListener( "enterFrame", o )
    oldRemove( o )
    o = nil
  end
end

-- Code to have Corona display the font names found
--
local fonts = native.getFontNames()

count = 0

-- Count the number of total fonts
for i,fontname in ipairs(fonts) do
    count = count+1
end

print( "\rFont count = " .. count )

local name = "F"     -- part of the Font name we are looking for

name = string.lower( name )

-- Display each font in the terminal console
for i, fontname in ipairs(fonts) do
    j, k = string.find( string.lower( fontname ), name )

    if( j ~= nil ) then

        print( "fontname = " .. tostring( fontname ) )

    end
end
---------------------------------------------------------


-- Import director class
local director = require("director")
ui = require( "ui" )
movieclip = require( "movieclip" )


local _W = display.contentWidth / 2
local _H = display.contentHeight / 2


GRID_COLS = 8
GRID_ROWS = 10
GRID_TILE_WIDTH = 40
GRID_TILE_HEIGHT = 40
MATCHING_NUMBER = 3

-- Offset to center tiles
horizontalOffset = (display.contentWidth - (GRID_COLS * GRID_TILE_WIDTH))/ 2 + GRID_TILE_WIDTH/2
verticalOffset = (display.contentHeight - (GRID_ROWS * GRID_TILE_HEIGHT))/ 2 + GRID_TILE_HEIGHT/2

IMAGES_DIR = "resources/images/"
FIRST_LEVEL_DIR = "firstLevel/"
SECOND_LEVEL_DIR = "secondLevel/"
THIRD_LEVEL_DIR = "thirdLevel/"
FOURTH_LEVEL_DIR = "fourthLevel/"
FIFTH_LEVEL_DIR = "fifthLevel/"
SIXTH_LEVEL_DIR = "sixthLevel/"

MAIN_FONT = "ylee Polymnia Framed"
BUTTON_FONT = "Bebas"

DEBUG_FLAG = true


-- Create a main group
local mainGroup = display.newGroup()

-- Main function
local function main()
	
	-- Add the group from director class
	mainGroup:insert(director.directorView)
	
--	director:changeScene( "loadmainmenu" )
    director:changeScene( "maingame" )
  
	return true
end

-- Begin
main()
