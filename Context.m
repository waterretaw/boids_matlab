classdef Context < handle
    %CONTEXT 项目中类的handle的存储
    %   该类没有使用
    
    properties
        dataDict; % 用于存储类的名字和handle;
    end
    
    % 私有构造函数用于单例模式
    methods(Access = private)
        function obj = Context()
            obj.dataDict = containers.Map();
        end
    end
    % 单例模式
    methods(Static)
        function obj = getInstance()
            persistent localobj;
            if isempty(localobj) || ~isvalid(localobj)
                localobj = Context();
            end
            obj = localobj;
        end
    end
    % 提供注册和获取两个方法
    methods
        function success = register(obj,ID,data)
            if obj.dataDict.isKey(ID)
                success = 0;
            else
                obj.dataDict(ID) = data;
                success = 1;
            end
            
        end
        function fdata = getData(obj,ID)
            if obj.dataDict.isKey(ID)
                fdata = obj.dataDict(ID);
            else
                fdata = 0;
            end
        end
    end
end

