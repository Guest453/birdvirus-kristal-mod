local Battle, super = HookSystem.hookScript(Battle)

local grayscale_shader

local function getGrayscaleShader()
    if not grayscale_shader then
        grayscale_shader = love.graphics.newShader([[
            vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
                vec4 pixel = Texel(texture, texture_coords) * color;
                float value = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
                return vec4(vec3(value), pixel.a);
            }
        ]])
    end
    return grayscale_shader
end

function Battle:draw()
    if not self.birdvirus_grayscale then
        return super.draw(self)
    end

    local previous = love.graphics.getShader()
    love.graphics.setShader(getGrayscaleShader())
    super.draw(self)
    love.graphics.setShader(previous)
end

return Battle
