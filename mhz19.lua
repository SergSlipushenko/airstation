local mhz19 = {
    co2 = 0, _pwm = -1,

    init = function (self, _pin)
        self._pin = _pin
    end,

    on_done = function(co2)
        print(co2)
    end,

    _callback = function(self, state)
        if state==1 then self._pwm = tmr.now() 
        else 
            if self._pwm<=0 then return end 
            self.co2=(tmr.now()-self._pwm-2000)*5/1000
            self._pwm=-1
            gpio.trig(self._pin, "none")
            node.task.post(function() self.on_done(self.co2) end)
        end
    end,
   
    get_co2 = function(self, on_done)
        if on_done then self.on_done = on_done end
        gpio.trig(self._pin, "both", function(state) self:_callback(state) end) 
    end
}
return mhz19
