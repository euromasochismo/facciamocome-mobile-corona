-----------------------------------------------------------------------------------------
--
-- generate.lua
--
-----------------------------------------------------------------------------------------

local globals = require( "scripts.globals" )

local composer = require("composer")
local widget = require("widget")
local json = require("json")
local url = require("socket.url")

local scene = composer.newScene()
local bg
local phrase
local spinner

math.randomseed( os.time() )

function scene:create(event)
	local sceneGroup = self.view
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.
	
	-- -------------------------------------
	-- SFONDO
	-- -------------------------------------
	bg = display.newRect(0, 0, display.contentWidth, display.contentHeight)
	bg.anchorX = 0
	bg.anchorY = 0

	-- -------------------------------------
	-- FRASE
	-- -------------------------------------
	local phraseOptions = {
	    text = "The quick brown fox jumped over the lazy dog.",
	    x = display.contentWidth * 0.5,
	    width = display.contentWidth - 30,     --required for multi-line and alignment
	    font = native.systemFont,
	    fontSize = 22,
	    align = "center"
	}

	phrase = display.newText( phraseOptions )
	phrase:setFillColor( 1 )

	-- Set anchor Y on object to 0 (top)
	phrase.anchorY = 0
	-- Align object to top alignment axis
	phrase.y = 75

	-- -------------------------------------
	-- SPINNER
	-- -------------------------------------
	-- Qui bisogna fare un imagesheet

	-- -------------------------------------
	-- BOTTONE FRASE
	-- -------------------------------------
	local btnGenerate = widget.newButton {
	    x = display.contentWidth * 0.5,
	    y = display.contentHeight - 100,
	    id = "btnGenerate",
	    label = "NUOVA FRASE",
	    fontSize = 18,
	    labelColor = { default = { 0, 0, 0 }, over = { 0, 0.5 } },
	    shape = "roundedRect",
	    width = 200,
	    height = 40,
	    cornerRadius = 6,
	    onPress = self.generatePhrase
	}

	-- -------------------------------------
	-- BOTTONE DOWNLOAD
	-- -------------------------------------
	local function downloadImage()
		local function networkListener(event)
			if ( event.isError ) then
				local alert = native.showAlert( "facciamocome", "Errore di rete. Download annullato.", { "OK" } )
	    elseif ( event.phase == "ended" ) then
	      -- Salva nelle foto
				media.save( "facciamocome.png", system.TemporaryDirectory )
				-- Popup
				local alert = native.showAlert( "facciamocome", "La frase è stata salvata nella Photo Gallery!", { "OK" } )
	    end
		end
		-- Scarica immagine
		local params = {}
		params.progress = true
		local downloadUrl = "http://facciamocome.org/image.php?nodownload=&phrase="..url.escape(globals.phraseLoaded)
		print(downloadUrl)
		network.download(downloadUrl, "GET", networkListener, params, "facciamocome.png", system.TemporaryDirectory)
		-- Suono
		local cameraChannel = audio.play( globals.cameraSound )
	end

	local btnDownload = widget.newButton {
		x = display.contentWidth * 0.5,
		y = display.contentHeight - 160,
		height = 32,
		width = 32,
		id = "btnDownload",
		defaultFile = "img/buttons/download-white.png",
		overFile = "img/buttons/download-white.png",
		onPress = downloadImage
	}
	
	-- all objects must be added to group (e.g. self.view)
	sceneGroup:insert(bg)
	sceneGroup:insert(phrase)
	sceneGroup:insert(btnGenerate)
	sceneGroup:insert(btnDownload)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		self.generatePhrase()
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

function scene:destroy(event)
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
end

-- GENERAZIONE FRASE

function scene:generatePhrase()
	local generateUrl = "http://facciamocome.org/generate.php?template="..globals.FC['templates'].id.."&country="..globals.FC['countries'].id
	-- print(generateUrl)
	network.request( generateUrl, "GET", injectPhrase )
end

function injectPhrase(event)
	if (event.isError) then
		native.showAlert( "Errore di rete!", { "OK" } )
	else
		local t = json.decode(event.response)
		setBackground()
		phrase.text = t.phrase
		globals.phraseLoaded = t.phrase
	end
end

-- GENERAZIONE SFONDO

function setBackground()
	local bgs = { { 255,66,54 }, { 34,34,34 }, { 39,174,97 }, {27,112,192} }
	local colors = bgs[math.random(1,4)];
	bg:setFillColor( colors[1]/255, colors[2]/255, colors[3]/255 );
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

----------------------------------------------------------------------------------

return scene



