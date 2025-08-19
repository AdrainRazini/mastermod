function create_auto_clicker(interval, clicks)
    -- Check if the arguments are valid
    if type(interval) ~= "number" or type(clicks) ~= "number" then
        print("Error: Invalid arguments. Both arguments must be numbers.")
        return
    end
    
    -- Import the necessary libraries
    require("ffi")
    local user32 = ffi.load("user32")
    ffi.cdef[[
        int MessageBoxA(void *w, const char *txt, const char *cap, int type);
        void Sleep(int ms);
        void mouse_event(int flags, int dx, int dy, int data, void *extraInfo);
    ]]
    
    -- Define the mouse event flags
    local MOUSEEVENTF_LEFTDOWN = 0x0002
    local MOUSEEVENTF_LEFTUP = 0x0004
    
    -- Loop through the number of clicks and click the mouse
    for i = 1, clicks do
        user32.mouse_event(MOUSEEVENTF_LEFTDOWN, 0, 0, 0, nil)
        user32.mouse_event(MOUSEEVENTF_LEFTUP, 0, 0, 0, nil)
        ffi.C.Sleep(interval * 1000)
    end
end