classdef Avoid < handle
    %AVOID �ϰ���Ķ���
    
    properties
        pos; % �ϰ���λ��
    end
    
    methods
        function obj = Avoid(x,y)
            %AVOID ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            obj.pos = [x y];
        end
        
        function go(obj)
            
        end
        
        function draw(obj)
            % �ϰ������ʾ
            hold on;
            scatter(obj.pos(1),obj.pos(2),15,[0,255/255,200/255]);
        end
    end
end

