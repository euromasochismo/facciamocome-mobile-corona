-----------------------------------------------------------------------------------------
--
-- info.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

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
	-- bg:setFillColor( 237/255, 237/255, 237/255 )	-- gray
	bg:setFillColor( 1 ) -- white

	-- LOGO
	local logo = display.newImage( "img/logo.png" )
	logo:translate( display.contentWidth * 0.5, 100 )
	
	-- SOMMARIO
	local summaryOptions = {
	    text = "Ripeti da anni che l'Italia è la pulcinella del mondo ma nessuno ti dà ascolto?\n\nSei stanco del provincialismo dei tuoi connazionali?\n\nDa oggi non sei più solo: diffondi gli esempi virtuosi delle nazioni più avanzate di noi (cioè tutte), per far sì che l'Italia sia finalmente all'altezza dell'Europa e delle sfide politiche e sociali della globalità!\n\nFacciamocome è un generatore random di supercazzole esterofile e piddine.\n\n@2014 By EuroMasochismo.",
	    x = display.contentWidth * 0.5,
	    width = display.contentWidth - 30,     --required for multi-line and alignment
	    font = native.systemFont,
	    fontSize = 13,
	    align = "center"
	}

	summary = display.newText( summaryOptions )
	summary:setFillColor( 0 )

	-- Set anchor Y on object to 0 (top)
	summary.anchorY = 0
	-- Align object to top alignment axis
	summary.y = 165
	
	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert( bg )
	sceneGroup:insert( summary )
	sceneGroup:insert( logo )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
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
