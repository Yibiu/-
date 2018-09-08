function image = changeclass(class, varargin)
% �ı�ͼ��Ĵ洢��ʽ. 
%   [in]class: 'uint8' \ 'uint16' \ 'double'.
%   [in]varargin: ����ͼ������

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

