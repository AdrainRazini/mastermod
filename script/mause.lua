--Attention, the inaccuracy can be up to 1-3 click, 
--since the Sleep() function ONLY accepts integers, 
--so milliseconds for sleep are rounding. 
--float just brokes everything.

local CPS = 15 --Clicks per second.
local keyToggle = "capslock" --Keyboard button for ON/OFF.
local keyMouse = 5 --Button that will make clicks. (only while holding)

EnablePrimaryMouseButtonEvents(true)

function OnEvent(e, a)
  if IsKeyLockOn(keyToggle)then
    if IsMouseButtonPressed(keyMouse)then
     repeat
     local sec = 1000 -- in milliseconds
     local time = (sec / CPS)
     PressMouseButton(1)
     ReleaseMouseButton(1)
     Sleep(math.floor(time))
     until not IsMouseButtonPressed(keyMouse)
    end
  end
end