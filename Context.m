classdef Context < handle
    %CONTEXT ��Ŀ�����handle�Ĵ洢
    %   ����û��ʹ��
    
    properties
        dataDict; % ���ڴ洢������ֺ�handle;
    end
    
    % ˽�й��캯�����ڵ���ģʽ
    methods(Access = private)
        function obj = Context()
            obj.dataDict = containers.Map();
        end
    end
    % ����ģʽ
    methods(Static)
        function obj = getInstance()
            persistent localobj;
            if isempty(localobj) || ~isvalid(localobj)
                localobj = Context();
            end
            obj = localobj;
        end
    end
    % �ṩע��ͻ�ȡ��������
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

