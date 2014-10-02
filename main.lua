-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar(display.HiddenStatusBar)

local globals = require( "scripts.globals" )

-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"

globals.FC = {
	templates = { id = 0, testo = 'Random' },
	countries = { id = 0, testo = 'Random' },
}

globals.phraseLoaded = ""

-- SUONI
globals.cameraSound = audio.loadSound( "sounds/camera-shutter-click.wav" )

-- EVENTI BOTTONI TABBAR:
local function onGenerateView(event)
	composer.gotoScene("scenes.generate", {effect = "slideRight"})
end

local function onInfoView(event)
	composer.gotoScene("scenes.info", {effect = "fromBottom"})
end

local function onOptionsView(event)
	composer.gotoScene("scenes.options", {effect = "slideLeft"})
end

-- BOTTONI TABBAR:
local tabButtons = {
	{ label = "", defaultFile = "img/buttons/generate.png", overFile = "img/buttons/generate.png", width = 38.9, height = 28, onPress = onGenerateView, selected = true, size = 12},
	{ label = "", defaultFile = "img/buttons/info.png", overFile = "img/buttons/info.png", width = 28, height = 28, onPress = onInfoView, size = 12},
	{ label = "", defaultFile = "img/buttons/options.png", overFile = "img/buttons/options.png", width = 41.6, height = 28, onPress = onOptionsView, size = 12},
}

-- TABBAR:
local tabBar = widget.newTabBar{
	top = display.contentHeight - 42,	-- 50 is default height for tabBar widget
	buttons = tabButtons
}

-- TITLE BAR (GLOBALE per farla vedere nelle scenes)

titleBarGroup = display.newGroup()

local titleBar = display.newRect( display.contentWidth/2, 20, display.contentWidth, 40 )
local titleOptions = {
	text = "FACCIAMOCOME",
	x = display.contentWidth * 0.5,
	y = 20,
	width = display.contentWidth,
	font = native.systemFont,
	fontSize = 14,
	align = "center",
}
titleBar:setFillColor(249/255, 249/255, 249/255)

local titleText = display.newText( titleOptions )
titleText:setFillColor( 0, 0.8 )

titleBarGroup:insert(titleBar)
titleBarGroup:insert(titleText)

onGenerateView()	-- invoke first tab button's onPress event manually
