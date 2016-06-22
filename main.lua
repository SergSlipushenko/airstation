dofile('htu21d.lua')
dofile('dsp.lua')
co2 = 0
pwm = -1
verbose = 1
ledshow = 1 
ws2812.init()
pwm_pin = 6
gpio.mode(pwm_pin, gpio.INT)
intn = 64
gled=string.char(intn,0,0)
rled=string.char(0,intn,0)
yled=string.char(intn/2,intn/2,0)
zled=string.char(0,0,0)
wled=string.char(intn/3,intn/3,intn/3)
ledlen=8

function leds(led, back, n, total)
   back = back or zled
   ws2812.write(string.rep(led,n) .. string.rep(back,total-n))
end

function to_level(ppm)
    local n=0
    if ppm<600 then n=(ppm-400)/25+1; leds(gled, wled, n, ledlen) 
    elseif ppm<1400 then n=(ppm-600)/100+1; leds(yled, gled, n, ledlen)
    else n=(ppm-1400)/400+1; leds(rled, yled, n, ledlen) end
end

log_data = function()
    temp = htu21d:temp()
    hum = htu21d:hum()
    dsp:println(co2, '' .. temp/100 ..'.'.. temp%100 .. 'C', hum .. '%')
    if verbose>0 then 
        print('{"time":'..tmr.time()..',"co2":'..co2..',"temp":'..temp..',"hum":'..hum.."}") end
	if ledshow>0 then to_level(co2) end
end

ms_callback = function(l) 
    if l==1 then pwm = tmr.now() 
    else if pwm>0 then co2=(tmr.now()-pwm-2000)*5/1000
                       pwm=-1
                       gpio.trig(pwm_pin, "none")
                       log_data() end 
    end 
end

function ms_co2() gpio.trig(pwm_pin, "both", ms_callback) end

function stop() tmr.stop(1) end
function run() tmr.alarm(1, 10000, tmr.ALARM_AUTO, ms_co2) end

ws2812.write(string.rep(gled,2) .. string.rep(yled,2) .. string.rep(rled,2) .. string.rep(wled,2))
