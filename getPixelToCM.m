function conversion = getPixelToCM(framenum)
if nargin==0
    framenum=1;
end

[FileName,PathName] = uigetfile({'*.m4v'; '*.mp4';'*.h264'}, 'Select a Video file');

filename = ([PathName FileName]);

v = VideoReader(filename);

video = read(v,framenum);
repeat = 0;

while repeat == 0;
    h=figure();
    imagesc(video);
    hold on
    msgbox('Click for start and end')
    pause(2)
    
    [x,y]=ginput(2);
    line('XData',x,'YData',y, 'color', 'g')
    hold off
    
    pixel_length = sqrt((x(1)-x(2))^2+(y(1)-y(2))^2);
    
    % Construct a questdlg with three options
    choice = questdlg('Repeat the line drawing?');
    % Handle response
    switch choice
        case 'Yes'
            repeat = 0;
            close(h)
        case 'No'
            repeat = 1;
            msgbox('YAY!')
        case 'Cancel'
            repeat = 1;
            msgbox('Oops')
    end
end

cmLen = input('What is the length of the line in cm?  ');
conversion = pixel_length/cmLen;
close(h)