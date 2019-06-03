classdef nd2file
    properties
        data
        isValidFile
    end
    methods
        function self = nd2file(varargin)
            test = pyversion;
            folder = fileparts(mfilename('fullpath'));
            insert(py.sys.path, int32(0), folder);
            if nargin == 0
                [file, path] = uigetfile({'*.nd2', 'Nikon File'; '*.tif', 'TIFF Set'})
                if file == 0
                    self.isValidFile = false;
                    return;
                else
                    self.data = py.nd2file.ND2File(strcat(path, file));
                end
            end
            if nargin == 1
                self.data = py.nd2file.ND2File(varargin{1});
            end
            self.isValidFile = true;
        end
        function image = GetImage(obj, positionIndex, timepointIndex, channelIndex, zLevel)
            nd2file = obj.data;
            raw_image = nd2file.GetImage(uint8(positionIndex-1), uint8(timepointIndex-1), uint8(channelIndex-1), zLevel);
            image = reshape(typecast(uint8(py.bytes(raw_image.flatten('F').data)), 'uint16'), nd2file.height, nd2file.width);
        end
        function channels = GetChannels(obj)
            channels = cellfun(@string, cell(obj.data.channels));
        end
        function positionNames = GetPositions(obj)
            positionNames = cellfun(@string, cell(obj.data.position_names));
        end
    end
end
    