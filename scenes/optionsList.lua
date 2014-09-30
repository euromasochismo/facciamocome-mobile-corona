-----------------------------------------------------------------------------------------
--
-- optionsList.lua
--
-----------------------------------------------------------------------------------------

local globals = require( "scripts.globals" )

local widget = require( "widget" )
local url = require("socket.url")
local json = require("json")

local composer = require( "composer" )
local scene = composer.newScene()

local itemsType, searchField, title, backArrow, msgField, searchStr, results

local typeStrings = {
	templates = { titolo = "Imposta una frase" },
	countries = { titolo = "Imposta un paese" }
}

local tableResultsExists = false -- Alla creazione, tableResults non esiste

local function showMsg(msg)
	msgField.text = msg
end

local function removeTableResults()
  if (tableResultsExists == true) then
    tableResults:removeSelf()
    tableResultsExists = false -- Dopo averla distrutta, la dichiara falsa
  end
end

function scene:create( event )
	local sceneGroup = self.view
	
	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- QUI DECIDE IL TIPO DI OGGETTO DA TRATTARE (templates o countries)
	itemsType = event.params.itemsType
	
	-- -------------------------------------
	-- SFONDO
	-- -------------------------------------

	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	-- bg:setFillColor( 237/255, 237/255, 237/255 )	-- gray
	bg:setFillColor( 1 ) -- white

	-- -------------------------------------
	-- FRECCIA PER TORNARE ALLE OPZIONI
	-- -------------------------------------

	local function backToOptions()
		composer.gotoScene("scenes.options", {effect = "slideRight"})
	end

	backArrow = widget.newButton {
		x = 20,
		y = 40,
		height = 16,
		width = 16,
		id = "backArrow",
		defaultFile = "img/arrowLeft.png",
		defaultFile = "img/arrowLeft.png",
		onPress = backToOptions
	}

	titleBarGroup:insert(backArrow)

	-- -------------------------------------
	-- TITOLO
	-- -------------------------------------
	title = display.newText( typeStrings[itemsType].titolo, 0, 85, native.systemFontBold, 14 )
	title.anchorX = 0
	title.x = 20
  	title:setFillColor( 0 )

  	-- -------------------------------------
	-- TABLEVIEWRISULTATI
	-- -------------------------------------

	-- Handle row rendering
	local function onRowRender( event )

    -- Get reference to the row group
    local row = event.row
    local id = row.index

    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth

    -- Create first multi-line text object
    local options = {
    	text = results[id].testo,
			width = rowWidth - 40,
			font = native.systemFont,
			fontSize = 12
    }
    
    local rowSelection = display.newText( options )
    rowSelection.anchorX = 0
    rowSelection.anchorY = 0
    rowSelection.x = 20
    rowSelection.y = 7
    rowSelection:setFillColor( 0 )
    row:insert(rowSelection)

	end

	-- Handle row touch
	local function onRowTouch( event )

		local row = event.row
		local id = row.index
	        
		if event.phase == "press" or event.phase == "tap" then     
	 		-- composer.gotoScene( "scenes.optionsList", { effect = "slideLeft", params = { itemsType = options[id].itemsType } } )
	 		print("\n\n"..results[id].id)
	 		-- GLOBALS
			globals.FC[itemsType]['id'] = results[id].id
			globals.FC[itemsType]['testo'] = results[id].testo
			-- TORNA ALLE OPZIONI
			backToOptions()
	 	end

	end


	local function showResults(event)
		if (event.isError) then
			native.showAlert( "Errore di rete!", { "OK" } )
		else
			removeTableResults()
			-- print(event.response)
			results = json.decode(event.response)
			-- Non ci sono risultati
			if (#results == 0) then
				showMsg("La ricerca non ha prodotto risultati! Prova con una stringa diversa.")
			else
				removeTableResults()
				showMsg("")

				-- TABLEVIEW
				tableResults = widget.newTableView {
				  left = 0,
				  top = 160,
				  height = 330,
				  width = 300,
				  onRowRender = onRowRender,
				  onRowTouch = onRowTouch
				}

				tableResultsExists = true

				-- RIGHE
				local defRowHeight
				if (itemsType == "templates") then
					-- print("templates")
					defRowHeight =  60
				else
					-- print("countries")
					defRowHeight =  30
				end
				for i = 1, #results do
				  -- Insert a row into the tableView
				  tableResults:insertRow { 
				  	rowHeight = defRowHeight,
				  	id = results[i].id
				  }
				end

				sceneGroup:insert( tableResults )

			end

		end
	end

	-- -------------------------------------
	-- CAMPO DI RICERCA
	-- -------------------------------------

	local function getResults( ... )
		local searchStrPar = url.escape(searchStr)
		local url = "http://facciamocome.org/app.php?call=get_list_items&type="..itemsType.."&search="..searchStrPar
		network.request( url, "GET", showResults )
	end

	local function textListener( event )
  	if ( event.phase == "began" ) then
			-- user begins editing text field
			-- print( event.text )

  	elseif ( event.phase == "ended" or event.phase == "submitted" ) then
  		-- print( searchStr )
  		-- Stringa di ricerca troppo corta
	    if ( string.len( searchStr ) < 4 ) then
	    	showMsg("La stringa di ricerca deve contenere almeno 4 caratteri!")
	    else
	    	getResults()
	    end

  	elseif ( event.phase == "editing" ) then
  		searchStr = ( event.text )
    	-- print( event.newCharacters )
      -- print( event.oldText )
      -- print( event.startPosition )
      -- print( event.text )
  	end
	end

	-- Crea il campo
	searchField = native.newTextField( display.contentWidth * 0.5, 130, display.contentWidth - 50, 20 )
	searchField.size = 14
	searchField.placeholder = "Cerca..."
	searchField:addEventListener( "userInput", textListener )

	-- Crea il bordo del campo
	local borderField = display.newRoundedRect( display.contentWidth * 0.5, 130, display.contentWidth - 35, 40, 5 )
	borderField:setFillColor( 1 ) 
	borderField:setStrokeColor( 0, 0.5 )
	borderField.strokeWidth = 1

	-- -------------------------------------
	-- MESSAGGIO
	-- -------------------------------------

  local msgOptions = {
	    text = "",
	    x = display.contentWidth * 0.5,
	    y = 190,
	    width = display.contentWidth - 30,     --required for multi-line and alignment
	    font = native.systemFont,
	    fontSize = 14,
	    align = "center"
	}

	msgField = display.newText( msgOptions )
	msgField:setFillColor( 0, 0.5 )
	
	-- -------------------------------------
	-- AGGIUNGE OGGETTI ALLA SCENA
	-- -------------------------------------
	sceneGroup:insert( bg )
	sceneGroup:insert( title )
	sceneGroup:insert( searchField )
	sceneGroup:insert( borderField )
	sceneGroup:insert( msgField )
end

function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then

		-- SVUOTA E NASCONDE L'EVENTUALE TABLEVIEW
		removeTableResults()
		-- AGGIORNA I PARAMETRI
		itemsType = event.params.itemsType
		-- MOSTRA IL CAMPO
		searchField.isVisible = true
		-- AGGIORNA IL TITOLO
		title.text = typeStrings[itemsType].titolo
		-- MOSTRA LA FRECCIA
		backArrow.isVisible = true
		-- RESETTA IL MESSAGGIO
		showMsg("Inserisci una stringa di ricerca (almeno 4 caratteri) per impostare una frase personalizzata.")
		results = {}

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

		-- SVUOTA E NASCONDE IL CAMPO
		searchField.text = ""
		searchField.isVisible = false
		-- NASCONDE LA FRECCIA
		backArrow.isVisible = false
		-- SVUOTA E NASCONDE L'EVENTUALE TABLEVIEW
		removeTableResults()
		results = {}

	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
