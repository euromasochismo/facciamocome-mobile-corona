-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- show default status bar (iOS)
display.setStatusBar(display.DefaultStatusBar)

-- include Corona's "widget" library
local widget = require "widget"
local composer = require "composer"


-- EVENTI BOTTONI TABBAR:
local function onGenerateView(event)
	composer.gotoScene("generate", {effect = "slideRight"})
end

local function onInfoView(event)
	composer.gotoScene("view2", {effect = "fromBottom"})
end

local function onOptionsView(event)
	composer.gotoScene("view2", {effect = "slideLeft"})
end

-- BOTTONI TABBAR:
local tabButtons = {
	{ label = "", defaultFile = "img/buttons/generate.png", overFile = "img/buttons/generate.png", width = 32, height = 32, onPress = onGenerateView, selected = true, size = 12},
	{ label = "", defaultFile = "img/buttons/info.png", overFile = "img/buttons/info.png", width = 32, height = 32, onPress = onInfoView, size = 12},
	{ label = "", defaultFile = "img/buttons/options.png", overFile = "img/buttons/options.png", width = 32, height = 32, onPress = onOptionsView, size = 12},
}

-- TABBAR:
local tabBar = widget.newTabBar{
	top = display.contentHeight - 42,	-- 50 is default height for tabBar widget
	buttons = tabButtons
}

-- TITLE BAR

local titleBar = display.newRect( display.contentWidth/2, 40, display.contentWidth, 40 )
local titleOptions = {
	text = "FACCIAMOCOME",
	x = display.contentWidth * 0.5,
	y = 40,
	width = display.contentWidth,
	font = native.systemFont,
	fontSize = 14,
	align = "center",
}

local titleText = display.newText( titleOptions )
titleText:setFillColor( 0, 0.8 )

onGenerateView()	-- invoke first tab button's onPress event manually
