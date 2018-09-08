function s = intrans(f, varargin)
% ʵ�ֻ����ĻҶ�ͼ����.
%   ͼ��ת��s = L-1-r
%   s = INTRANS(f, 'neg')
%   
%   �����任��s = c*log(1 + f)
%   s = INTRANS(f, 'log', c, class)
%   s = INTRANS(f, 'log', c)    class����������ͼ����ͬ(uint8��uint16)
%   s = INTRANS(f, 'log')   c=1,class����������ͼ����ͬ(uint8��uint16)
% 
%   ٤��(Gamma)�任��s = c*r^��
%   s = INTRANS(f, 'gamma', GAM)
%
%   �Աȶ����죺s = 1/(1+(m/r)^E)
%   s = INTRANS(f, 'stretch', M, E)     
%   M ��ΧΪ[0, 1]��Ĭ��Ϊmean2(im2double(F))��EĬ��Ϊ 4.
%
%   ͼ��ת, ٤��任, �Աȶ����죺
%   ���ڳ�����Χ��double���͵�����ͼ������ʹ��MAT2GRAYѹ����[0 1]������ͼ������ʹ��
%   IM2DOUBLEת��Ϊdouble���͡�(��һ��)
%   �����任��
%   ֱ�Ӵ���double���͵����ݡ�(�����һ��)

% ���������Ŀ��2~4֮��
narginchk(2, 4);

% ���ƷǶ����任ʱ������double���͵�[0 1]��Χ
classin = class(f);
if isa(class(f), 'double') && max(f(:)) > 1 && ~strcmp(varargin{1}, 'log')
   f = mat2gray(f);
else
   f = im2double(f);
end

% Perform the intensity transformation specified. 
method = varargin{1};
switch method
case 'neg' % ͼ��ת
   s = imcomplement(f); 
case 'log' % �����任
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
case 'gamma' % ٤��任
   if length(varargin) < 2
      error('Not enough inputs for the gamma option.')
   end
   gam = varargin{2}; 
   s = imadjust(f, [ ], [ ], gam);
case 'stretch' % �Աȶ�����
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
