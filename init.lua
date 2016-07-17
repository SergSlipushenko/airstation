uart.setup(0, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 1);print('>>>>>>>>>>')
tmr.alarm(6, 3000, 0, function() print('Welcome!'); pcall(function() dofile('utils.lua'); safe_main() end) end)
