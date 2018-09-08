function s = intrans(f, varargin)
% 实现基本的灰度图像处理.
%   图像反转：s = L-1-r
%   s = INTRANS(f, 'neg')
%   
%   对数变换：s = c*log(1 + f)
%   s = INTRANS(f, 'log', c, class)
%   s = INTRANS(f, 'log', c)    class类型与输入图像相同(uint8或uint16)
%   s = INTRANS(f, 'log')   c=1,class类型与输入图像相同(uint8或uint16)
% 
%   伽马(Gamma)变换：s = c*r^γ
%   s = INTRANS(f, 'gamma', GAM)
%
%   对比度拉伸：s = 1/(1+(m/r)^E)
%   s = INTRANS(f, 'stretch', M, E)     
%   M 范围为[0, 1]，默认为mean2(im2double(F))；E默认为 4.
%
%   图像反转, 伽马变换, 对比度拉伸：
%   对于超出范围的double类型的输入图像首先使用MAT2GRAY压缩到[0 1]，其他图像首先使用
%   IM2DOUBLE转换为double类型。(归一化)
%   对数变换：
%   直接处理double类型的数据。(无需归一化)

% 输入变量数目在2~4之间
narginchk(2, 4);

% 限制非对数变换时的输入double类型到[0 1]范围
classin = class(f);
if isa(class(f), 'double') && max(f(:)) > 1 && ~strcmp(varargin{1}, 'log')
   f = mat2gray(f);
else
   f = im2double(f);
end

% Perform the intensity transformation specified. 
method = varargin{1};
switch method
case 'neg' % 图像反转
   s = imcomplement(f); 
case 'log' % 对数变换
   if length(varargin) == 1  
      c = 1;
   elseif length(varargin) == 2  
      c = varargin{2}; 
   elseif length(varargin) == 3 
      c = varargin{2}; 
      classin = varargin{3};
   else 
      error('Incorrect number of inputs for the log option.')
   end
   s = c*(log(1 + double(f)));
case 'gamma' % 伽马变换
   if length(varargin) < 2
      error('Not enough inputs for the gamma option.')
   end
   gam = varargin{2}; 
   s = imadjust(f, [ ], [ ], gam);
case 'stretch' % 对比度拉伸
   if length(varargin) == 1
      m = mean2(f);  
      E = 4.0;           
   elseif length(varargin) == 3
      m = varargin{2};  
      E = varargin{3};
   else
       error('Incorrect number of inputs for the stretch option.');
   end
   s = 1./(1 + (m./(f + eps)).^E);
otherwise
   error('Unknown enhancement method.')
end

% Convert to the class of the input image.
s = changeclass(classin, s);
