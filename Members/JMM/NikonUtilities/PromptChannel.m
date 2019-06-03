function channelIndex = PromptChannel(file, channel_name)
    channels = file.GetChannels();
    if length(channels) <= 1
        channelIndex = 1;
        return;
    end
    
    text = strcat({'Select channel for '}, channel_name, ':\n');
    
    for i = 1:length(channels)
        text = strcat(text, num2str(i), {': '}, channels{i}, '\n');
    end
    text = strcat(text, {'$ '});
    channelIndex = input(char(text));
end

