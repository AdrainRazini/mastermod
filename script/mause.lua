EnablePrimaryMouseButtonEvents(true)

function OnEvent(event, arg)
    if event == "MOUSE_BUTTON_PRESSED" and arg == 4 then
        repeat
            -- Move o mouse para uma posição aleatória perto do ponto atual
            local dx = math.random(-10, 10)
            local dy = math.random(-10, 10)
            MoveMouseRelative(dx, dy)
            
            -- Clica
            PressAndReleaseMouseButton(1)
            
            Sleep(math.random(30, 60))
        until not IsMouseButtonPressed(4)
    end
end
