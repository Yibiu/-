function image = changeclass(class, varargin)
% 改变图像的存储形式. 
%   [in]class: 'uint8' \ 'uint16' \ 'double'.
%   [in]varargin: 输入图像数据

switch class
case 'uint8'
   image = im2uint8(varargin{:});
case 'uint16'
   image = im2uint16(varargin{:});
case 'double'
   image = im2double(varargin{:});
otherwise
   error('Unsupported IPT data class.');
end

