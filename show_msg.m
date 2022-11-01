function show_msg(msg)
    switch msg
        case ''
            fprintf('[INFO]');
        otherwise
            fprintf('[INFO] Unknown message selected');
    end
end

