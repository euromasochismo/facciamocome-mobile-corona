-----------------------------------------------------------------------------------------
--
-- options.lua
--
-----------------------------------------------------------------------------------------

local globals = require( "scripts.globals" )

local widget = require "widget"

local composer = require( "composer" )
local scene = composer.newScene()

local tableView

function scene:create( event )
	local sceneGroup = self.view
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- create a white background to fill screen
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 1 )	-- white

	-- -------------------------------------
	-- TITOLO
	-- -------------------------------------

	local title = display.newText( "Impostazioni", 0, 85, native.systemFontBold, 14 )
	title.anchorX = 0
	title.x = 20
  	title:setFillColor( 0 )

	-- -------------------------------------
	-- TABLEVIEW
	-- -------------------------------------

	local options = {
		{ icon = 'img/templates.png', itemsType = 'templates' },
		{ icon = 'img/countries.png', itemsType = 'countries' },
	}

	-- Handle row rendering
	local function onRowRender( event )

	    -- Get reference to the row group
	    local row = event.row
	    local id = row.index

	    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
	    local rowHeight = row.contentHeight
	    local rowWidth = row.contentWidth

	    local originalTesto = globals.FC[options[id].itemsType].testo
	    local testo = originalTesto:sub( 1, 23 )
	    if ( originalTesto:len() > 23 ) then
	    	testo = testo.."..."
	    end

	    -- SELEZIONE
	    local rowSelection = display.newText( row, testo, 0, 0, nil, 14 )
	    rowSelection:setFillColor( 0 )
	    rowSelection.anchorX = 0
	    rowSelection.x = 70
	    rowSelection.y = rowHeight * 0.5

	    -- ICONE
	    local rowIcon = display.newImage( row, options[id].icon )
	    rowIcon.anchorX = 0
	    rowIcon.x = 20
	    rowIcon.y = rowHeight * 0.5

	    -- FRECCIA
	    local rowArrow = display.newImage( row, "img/arrowRight.png" )
	    rowArrow.anchorX = 0
	    rowArrow.x = rowWidth - 20
	    rowArrow.y = rowHeight * 0.5

	end

	-- Handle row touch
	local function onRowTouch( event )

		local row = event.row
		local id = row.index
	        
		if event.phase == "press" or event.phase == "tap" then     
	 		composer.gotoScene( "scenes.optionsList", { effect = "slideLeft", params = { itemsType = options[id].itemsType } } )
	 	end

	end

	-- Create the tableView
	tableView = widget.newTableView {
	  left = 0,
	  top = 110,
	  height = 330,
	  width = 300,
	  onRowRender = onRowRender,
	  onRowTouch = onRowTouch
	}

	-- RIGHE
	for i = 1, #options do
	  
	  -- Inserisce opzioni
	  tableView:insertRow {  }

	end

	-- -------------------------------------
	-- BOTTONE RESET
	-- -------------------------------------

	local function resetImpostazioni()
		globals.FC['templates'] = { id = 0, testo = 'Random' }
		globals.FC['countries'] = { id = 0, testo = 'Random' }
		tableView:reloadData()
	end

	local btnReset = widget.newButton {
	    x = display.contentWidth * 0.5,
	    y = display.contentHeight - 75,
	    label = "RESET IMPOSTAZIONI",
	    labelColor = { default = { 1 }, over = { 1 } },
	    width = display.contentWidth - 40,
	    fontSize = 12,
	    height = 30,
	    shape = "roundedRect",
	    cornerRadius = 6,
	    fillColor = { default={ 1, 66/255, 54/255 }, over={ 1,0,0 } },
	    onPress = resetImpostazioni
	}
	
	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( bg )
	sceneGroup:insert( title )
	sceneGroup:insert( tableView )
	sceneGroup:insert( btnReset )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		tableView:reloadData()
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		tableView:reloadData()
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
