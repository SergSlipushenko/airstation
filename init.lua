print('try to boot');tmr.alarm(6, 3000, 0, function() pcall(function() dofile('utils.lua'); safe_main() end) end)
