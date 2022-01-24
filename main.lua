lg = love.graphics

binser = require("libs/binser")
utf8 = require("libs/utf8-simple")

require("libs/settings")
require("libs/colors")

require("libs/start-stop")
require("libs/sound")
require("libs/move")
require("libs/render")
require("libs/image-cache")
require("libs/preload")
require("libs/fps-limiter")
require("libs/back-button")


-- Const
CLEARANCE = 0.03
FONT1_SIZE = 0.04
FONT2_SIZE = 0.06

font1 = nil
font2 = nil
--FONT_FILE = "FreeSans.ttf"
FONT_FILE = "LiberationSans-Regular.ttf"
FONT1_HEIGHT = FONT1_SIZE * 1.2
FONT2_HEIGHT = FONT2_SIZE * 1.2

-- Varriables
things = {}

state = STATE_MENU

textEnable = true

glitchImage = nil
glitchEnd = 0

thisAreaText = ""
thisAreaTextSub = 0
thisAreaTextLength = 0
thisAreaTextUpdateTime = 0

textAreaImage = nil
backButtonImage = nil

function setStates()
	love.keypressed = thisState.keypressed
	love.mousereleased = thisState.mousereleased
	love.mousepressed = thisState.mousepressed
	love.wheelmoved = thisState.wheelmoved
end

-- Events
function love.load()
	-- Render parameters
	width, height = lg.getDimensions()
	computeScale()
	
	-- Map
	loadMap()
	
	-- Load settings
	settingsLoad()
	
	love.window.setFullscreen(settings.fullscreen)
	
	-- Load font size from settings
	if settings.FONT1_SIZE ~= nil then
		FONT1_SIZE = settings.FONT1_SIZE / 100
	end
	if settings.FONT2_SIZE ~= nil then
		FONT2_SIZE = settings.FONT2_SIZE / 100
	end
	FONT1_HEIGHT = FONT1_SIZE * 1.2
	FONT2_HEIGHT = FONT2_SIZE * 1.2
	if settings.CLEARANCE ~= nil then
		CLEARANCE = settings.CLEARANCE / 100
	end
	
	-- Font
	font1 = lg.newFont(FONT_FILE, h * FONT1_SIZE)
	font2 = lg.newFont(FONT_FILE, h * FONT2_SIZE)
	
	-- Load states
	thisState = nil
	prevState = nil
	states = {
		menu = require("states/menu"),
		game = require("states/game"),
		pause = require("states/pause"),
		saves = require("states/saves"),
		settings = require("states/settings"),
		list = require("states/list")
	}
	
	require("game-objects/characters")
	require("game-objects/glitch")
	require("game-objects/buttons")
	require("game-objects/dialogbox")
	
	-- Load menu
	states.menu.load()
	
	-- Launch thread
	preloadStart()
	
	-- Preload saves and settings
	preloadImage("backgrounds/list.png")
	preloadImage("backgrounds/" .. MAP[1].background .. ".png")
end

function love.resize(x, y)
	width, height = x, y
	computeScale()
end

function love.update()
	fpsLimiterStart()
	
	preloadSendToCache()
end

mouseX = nil
mouseY = nil

function mouseGet()
	mouseX = (love.mouse.getX() - offsetX) / scale / w
	mouseY = (love.mouse.getY() - offsetY) / scale / h
end

function mouseSet(x, y)
	mouseX = (x - offsetX) / scale / w
	mouseY = (y - offsetY) / scale / h
end

function mouseInrange(x1, y1, x2, y2)
	return x1 < mouseX and mouseX < x2 and y1 < mouseY and mouseY < y2
end

function love.draw()
	lg.push()
	lg.translate(offsetX, offsetY)
	lg.scale(scale)
	
	-- Draw background
	backgroundDraw()
	
	thisState.draw()
	
	lg.pop()
	
	drawBlackBorders()
	
	fpsLimiterEnd()
end
