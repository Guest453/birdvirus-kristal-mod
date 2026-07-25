local DebugSystem, super = HookSystem.hookScript(DebugSystem)

function DebugSystem:onKeyPressed(key, is_repeat)
    if not is_repeat and not TextInput.active and Input.is("birdvirus_debug_mode", key) then
        Input.clear("birdvirus_debug_mode")

        if self.state == "IDLE" then
            self.current_menu = "birdvirus_debug_mode"
            self.menu_history = {}
            self:openMenu()
        else
            Assets.playSound("ui_move")
            self:closeMenu()
        end
        return
    end

    super.onKeyPressed(self, key, is_repeat)
end

return DebugSystem
