classdef Boids < handle
    %BOIDS 集群的定义
    
    properties
        boids;      % 集群
        avoids;     % 障碍物
        settings;   % 设置相关
        figh;       % figure handle
    end
    
    methods
        function obj = Boids()
            %BOIDS 构造此类的实例
            %   此处显示详细说明
            obj.boids = [];
            obj.avoids = [];
            obj.settings = Settings();
        end
        
        function init(obj)
            % 随机生成集群个体
            for x = 100:100:obj.settings.width
                for y = 100:100:obj.settings.height
                    obj.boids = [obj.boids Boid(x+rand*3,y+rand*3,obj)];
                end
            end
            % 随机生成障碍物
            for x = 200:200:obj.settings.width
                for y = 200:200:obj.settings.height
                    obj.avoids = [obj.avoids Avoid(x+rand*3,y+rand*3)];
                end
            end
        end
        
        function run(obj)
            width = obj.settings.width;
            height = obj.settings.height;
            position = [150 80 width height];
            obj.figh = figure('Position',position,'NumberTitle', 'off', 'Name', 'boids');
            obj.init();
            while isvalid(obj.figh)
                clf;
                axis([0 width 0 height]); % 设置坐标轴范围
                axis manual; % 冻结坐标轴
                obj.loop();
                pause(1/1000);
            end
        end
        
        function loop(obj)
            for boid = obj.boids
                boid.go();
                boid.draw();
            end
            for avoid = obj.avoids
                avoid.go();
                avoid.draw();
            end
        end
    end
end

