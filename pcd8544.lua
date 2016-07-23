local pcd8544 = {
    init = function(self, cs, dc, res)
        spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 16, spi.FULLDUPLEX)
        self.disp = u8g.pcd8544_84x48_hw_spi(_cs or 8, _dc or 6, _res)
    end,

    get_fonts = function(self)
        local font = nil
        for key,val in pairs(u8g) do 
            if key:sub(1,4)=='font' then 
                print(key)
                if not font then font = val end 
            end
        end
        return font
    end,

    set_font = function(self, font)
        self.disp:setFont(font or u8g.font_6x10)
        self.disp:setDefaultForegroundColor()
        self.disp:setFontPosTop()
    end,

    draw = function(self, content)
        self.disp:firstPage()
        repeat content(self.disp) 
        until self.disp:nextPage() == false
    end
}
return pcd8544
