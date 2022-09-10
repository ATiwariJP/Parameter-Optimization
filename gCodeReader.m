function toolPath = gCodeReader(filepath, dist_res, plot_path, verbose)
%gCodeReader  Function that takes a G-Code file and outputs the tool path 
% for plotting/analysis. Not a complete analysis of the whole file, but 
% more or less the basic motions. 
% Inputs: 
%        - path to G-Code file
%        - point spacing for linear motion (mm or inches, I guess)
%        - point spacing for arc motion (degrees)
%        - Plot the current path (1 or 0)
%        - Output raw G-Code to console
% Outputs:
%        - The interpolated tool path
% Notes:
%        - This is not at all complete, but should work well enough for
%        simple CNC G-Code. If you need anything more complex, I'd suggest
%        you implement it yourself, as this was more or less all I needed
%        at the time.
%        - I have also done zero optimization.
%        - This comes with no guarantees or warranties whatsoever, but I
%        hope it's useful for someone.
% 
% Example usage:
%       toolpath = gCodeReader('simplePart.NC',0.5,0.5,1,0);
% 
% Tom Williamson
% 18/06/2018

raw_gcode_file = fopen(filepath);
% Modes
Rapid_positioning = 0;
Linear_interpolation = 1;

current_mode = NaN;
% Initialize variables
current_pos = [0,0,0];
toolPath = [];

interp_pos = [];

z_pos = 0;

while ~feof(raw_gcode_file)
    tline = fgetl(raw_gcode_file);
    % Check if its an instruction line
    if length(tline) > 0 && tline(1) == 'G'
        
        tline = tline(1:end);

        splitLine = strsplit(tline,' ');

                for i = 1:length(splitLine)
                    if verbose == 1
                        disp(splitLine{i});
                    end
                    % Check what the command is (only the main ones are
                    % implemented i.e. G0 - G3)
                    if strcmp(splitLine{i}, 'G00')
                        if verbose == 1
                            disp('Rapid positioning')
                        end
                        current_mode = Rapid_positioning;
                    elseif strcmp(splitLine{i}, 'G1')
                        if verbose == 1
                            disp('Linear interpolation')
                        end
                        current_mode = Linear_interpolation;
                   
                    else
                        if splitLine{i}(1) == 'X'
                            current_pos(1) = str2num(splitLine{i}(2:end));
                        elseif splitLine{i}(1) == 'Y'
                            current_pos(2) = str2num(splitLine{i}(2:end));
                        elseif splitLine{i}(1) == 'Z'
                            z_pos = z_pos + str2num(splitLine{i}(2:end));
                            current_pos(3) = z_pos;
                        end
                    end
                end

        % Check the current mode and calculate the next points along the
        % path: linear modes
            if current_mode == Linear_interpolation || current_mode == Rapid_positioning
                    if length(toolPath > 0)
                        interp_pos = [linspace(toolPath(end,1),current_pos(1),100)',linspace(toolPath(end,2),current_pos(2),100)',linspace(toolPath(end,3),current_pos(3),100)'];
                        dist = norm((current_pos - toolPath(end,:)));
                        if dist > 0
                            dire = (current_pos - toolPath(end,:))/dist;
        
                            interp_pos = toolPath(end,:) + dire.*(0:dist_res:dist)';
                            interp_pos = [interp_pos;current_pos];
                        end
                    else
                        interp_pos = current_pos;
                    end
                % Check the current mode and calculate the next points along the
                % path: arc modes, note that this assumes the arc is in the X-Y
                % axis only
                
                toolPath = [toolPath;interp_pos];
            end

    end
end
% Plot if requested
if plot_path
    plot3(toolPath(:,1),toolPath(:,2),toolPath(:,3),'r-')
end
    fclose(raw_gcode_file);
end