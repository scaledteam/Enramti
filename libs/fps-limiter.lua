-- Set fps limit
--fpsMinDt = 1 / 60
fpsMinDt = 1 / 70
fpsNextTime = 0

systime = 0

function fpsLimiterStart()
	systime = love.timer.getTime()
	fpsNextTime = systime + fpsMinDt
end

function fpsLimiterEnd()
	local time = love.timer.getTime()
	if fpsNextTime > time then
		love.timer.sleep(fpsNextTime - time)
	end
end