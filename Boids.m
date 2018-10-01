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
            destination = [500 300];
            obj.settings.destination = destination;
            % 随机生成集群个体
            for x = 100:100:obj.settings.width
                for y = 100:100:obj.settings.height
                    obj.boids = [obj.boids Boid(x+rand*3,y+rand*3,obj)];
                end
            end
%             % 随机生成障碍物
%             for x = 200:200:obj.settings.width
%                 for y = 200:200:obj.settings.height
%                     obj.avoids = [obj.avoids Avoid(x+rand*3,y+rand*3)];
%                 end
%             end
        end
        
        
        function init1(obj)
            destination = [800 300];
            obj.settings.destination = destination;
            % 随机生成集群个体
            for x = 100:100:obj.settings.width/2-100
                for y = 100:100:obj.settings.height
                    obj.boids = [obj.boids Boid(x+rand*3,y+rand*3,obj)];
                end
            end
            % 随机生成障碍物 两条线
            for x = [-20 20]+obj.settings.width/2
                for y = [1:30:obj.settings.height/2-50 obj.settings.height/2+50:30:obj.settings.height]
                    obj.avoids = [obj.avoids Avoid(x+rand*3,y+rand*3)];
                end
            end
        end
        
        function init2(obj)
            destination = [950 300];
            obj.settings.destination = destination;
            % 随机生成集群个体
            for x = 100:60:obj.settings.width/2-100
                for y = 100:60:obj.settings.height
                    obj.boids = [obj.boids Boid(x+rand*3,y+rand*3,obj)];
                end
            end
            % 随机生成障碍物 三个圆
            center = [500 450];
            radius = 10;
            for angle = 0:2*pi/8:2*pi
                pos = [cos(angle) sin(angle)];
                pos = pos * radius + center;
                obj.avoids = [obj.avoids Avoid(pos(1),pos(2))];
            end
            
            center = [650 350];
            radius = 20;
            for angle = 0:2*pi/16:2*pi
                pos = [cos(angle) sin(angle)];
                pos = pos * radius + center;
                obj.avoids = [obj.avoids Avoid(pos(1),pos(2))];
            end
            
            center = [500 250];
            radius = 50;
            for angle = 0:2*pi/40:2*pi
                pos = [cos(angle) sin(angle)];
                pos = pos * radius + center;
                obj.avoids = [obj.avoids Avoid(pos(1),pos(2))];
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

