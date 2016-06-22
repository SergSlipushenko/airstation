dsp = {
    addr=42, sda=2, scl=5,
    init = function(self, addr, sda, scl)
        self.addr=addr
        self.sda=sda
        self.scl=scl
    end,
    dsp = function(self, data)
        local data=data or "DSP";
        i2c.setup(0,self.sda,self.scl,i2c.SLOW)
        i2c.start(0);
        i2c.address(0,self.addr,i2c.TRANSMITTER);
        i2c.write(0,data);
        i2c.stop(0);
        tmr.delay(10000)
    end,
    println = function(self, ...)
        self:dsp('CLR')
        for i,v in ipairs(arg) do
            self:dsp('PRL'..v)
        end
        self:dsp()
    end,
    clr = function(self) self:dsp('CLR'); self:dsp() end
}
