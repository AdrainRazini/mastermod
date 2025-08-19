local ffi = require("ffi")

ffi.cdef[[
    bool SetCursorPos(int X, int Y);
]]

local user32 = ffi.load("user32.dll")

-- função para mover suavemente
local function smoothMove(x1, y1, x2, y2, steps, delay)
    local dx = (x2 - x1) / steps
    local dy = (y2 - y1) / steps
    for i = 0, steps do
        user32.SetCursorPos(x1 + dx * i, y1 + dy * i)
        wait(delay) -- pausa pequena entre cada passo
    end
end

-- exemplo: descer o mouse de (500, 500) até (500, 300)
smoothMove(500, 500, 500, 300, 50, 0.01)
