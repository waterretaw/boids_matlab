classdef Settings < handle
    %SETTINGS 将集群用的常量统一管理
    
    properties
        globalScale = .91;
        eraseRadius = 20;
        tool = "boids";
        
        width = 1024;
        height = 576;
        
        maxSpeed;
        friendRadius;
        crowdRadius;
        avoidRadius;
        coheseRadius;
        
        destination;
    end
    
    methods
        function obj = Settings()
            obj.maxSpeed = 5.1 * obj.globalScale;
            obj.friendRadius = 60 * obj.globalScale;
            obj.crowdRadius = (obj.friendRadius /1.3);
            obj.avoidRadius = 90 * obj.globalScale;
            obj.coheseRadius = obj.friendRadius;
        end
    end
end

