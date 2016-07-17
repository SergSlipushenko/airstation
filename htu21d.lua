local htu21d = {
    addr = 64, sda = 3, scl = 1,
    init = function (self, addr, sda, scl)
        self.addr = addr
        self.sda = sda
        self.scl = scl
    end,
	read = function (self, reg)
        i2c.setup(0, self.sda, self.scl, i2c.SLOW)
		i2c.start(0)
		i2c.address(0, self.addr, i2c.TRANSMITTER)
		i2c.write(0, reg)
		i2c.stop(0)
		tmr.delay(50000)
		i2c.start(0)
		i2c.address(0, self.addr, i2c.RECEIVER)
		local c = i2c.read(0, 3)
		i2c.stop(0)
		return c:byte(1)*256+c:byte(2)
	end,
    temp = function (self)  return 17572*self:read(243)/65536-4685 end,
    hum = function (self) return 125*self:read(245)/65536-6 end
}
return htu21d
