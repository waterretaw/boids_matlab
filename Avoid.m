classdef Avoid < handle
    %AVOID 障碍物的定义
    
    properties
        pos; % 障碍物位置
    end
    
    methods
        function obj = Avoid(x,y)
            %AVOID 构造此类的实例
            %   此处显示详细说明
            obj.pos = [x y];
        end
        
        function go(obj)
            
        end
        
        function draw(obj)
            % 障碍物的显示
            hold on;
            scatter(obj.pos(1),obj.pos(2),30,[1,0,0]);
        end
    end
end

