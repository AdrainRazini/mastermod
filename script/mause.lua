-- mover o mouse com user32.dll
local ffi = require("ffi")

ffi.cdef[[
    bool SetCursorPos(int X, int Y);
]]

local user32 = ffi.load("user32.dll")

-- move o mouse para a posição (500, 500)
user32.SetCursorPos(500, 500)
