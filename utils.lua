run, stop = nil
function main() dofile('main.lua') end
function safe_main() 
    if not file.exists('main.lock') then 
        main()
        print('main executed')
        if not file.exists('run.lock') then
            if run then 
                run(); 
                print('run executed'); 
            end
        else print('run locked') end 
    else print('main locked') end
end
