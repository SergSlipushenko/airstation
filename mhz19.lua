local co2, pwm = 0, -1
local pwm_pin = 6

local init = function (_pwm_pin)
    pwm_pin = pwn_pin
end

local leds = function(led, back, n, total)
    local back = back or zled
    ws2812.write(string.rep(led,n) .. string.rep(back,total-n))
end

local display_leds = function (ppm)
    local n=0
    if ppm<600 then n=(ppm-400)/25+1; leds(gled, wled, n, ledlen) 
    elseif ppm<1400 then n=(ppm-600)/100+1; leds(yled, gled, n, ledlen)
    else n=(ppm-1400)/400+1; leds(rled, yled, n, ledlen) end
end

local ms_co2 = function(callback) 
  local ms_callback = function(l)
      if l==1 then pwm = tmr.now() 
      else if pwm>0 then co2=(tmr.now()-pwm-2000)*5/1000
                         pwm=-1
                         gpio.trig(pwm_pin, "none")
                         callback(co2) end
      end
  end
  gpio.trig(pwm_pin, "both", ms_callback) 
end

