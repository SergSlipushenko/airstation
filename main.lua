wifi.setmode(wifi.NULLMODE)
htu21d=dofile('htu21d.lua')
dsp=dofile('u8g.lua')
mhz19=dofile('mhz19.lua')
leds=dofile('leds.lua')
cfg=dofile('config.lua')
ws2812.init()
dsp:init();dsp:set_font(cfg.base_font)
mhz19:init(cfg.mhz19_pin)
leds:init(cfg.led_intensity, 8)

on_done = function(co2)
    local temp = htu21d:temp()/10
    local hum = htu21d:hum()
    local co2_str='****'
    if tmr.time() > 200 then
        co2_str=tostring(co2)
        if cfg.verbose>0 then 
            print('{"time":'..tmr.time()..',"co2":'..co2..',"temp":'..temp..',"hum":'..hum.."}") end
        if cfg.ledshow>0 then 
            local n=0
            if co2<600 then 
                n=(co2-400)/25+1
                leds:show(leds.g, leds.w, n) 
            elseif co2<1400 then 
                n=(co2-600)/100+1
                leds:show(leds.y, leds.g, n)
            else 
                n=(co2-1400)/400+1
                leds:show(leds.r, leds.y, n) 
            end
        end 
    end
    local content = function(d) 
        dsp:set_font(cfg.base_font)
        d:drawStr(0,0,'CO2:' .. co2_str)
        dsp:set_font(cfg.mid_font)
        d:drawStr(0,20,'' .. temp/10 .. '.' .. temp%10 .. string.char(176) ..' '..hum..'%')
        dsp:set_font(cfg.small_font)
        d:drawStr(0,40,tmr.time()) 
        d:drawStr(32,40,node.heap()) 
    end
    dsp:draw(content)
end

function stop() tmr.stop(1) end
function run() tmr.alarm(1, cfg.cycle, tmr.ALARM_AUTO, function() mhz19:get_co2(on_done) end) end

ws2812.write(string.rep(leds.g,2) .. string.rep(leds.y,2) .. string.rep(leds.r,2) .. string.rep(leds.w,2))
