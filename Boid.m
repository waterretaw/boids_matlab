classdef Boid < handle
    %BOID ��Ⱥ�и��嶨��
    
    properties
        pos;        % λ��
        move;       % �ƶ�
        shade;      % ��ɫ
        friends;    % �ھ�
        thinkTimer; % ��ʱ��
        boidsObj;   % ��Ⱥ����
    end
    
    methods
        function obj = Boid(x,y,boidsObj)
            %BOID ��������ʵ��
            %   �˴���ʾ��ϸ˵��
            %   nargin �����������
            if nargin == 0
                obj.pos = [0 0];
                obj.move = [0 0];
                obj.shade = 255*rand;
                obj.thinkTimer = 10*rand;
                obj.friends = [];
            elseif nargin == 3
                obj.pos = [x y];
                obj.move = [0 0];
                obj.shade = 255*rand;
                obj.thinkTimer = 10*rand;
                obj.friends = [];
                obj.boidsObj = boidsObj;
            end
        end
        
        function go(obj)
            % �����ƶ�
            obj.increament();
            obj.wrap();
            %             if(round(obj.thinkTimer) == 0)
            obj.getFriends();
            %             end
            obj.flock();
            obj.pos = obj.pos + obj.move;
        end
        
        function flock(obj)
            % ��Ⱥ�㷨
            allign = obj.getAverageDir();           % �ٶ�ƥ��
            avoidDir = obj.getAvoidDir();           % ����֮����ײ����
            avoidObjects = obj.getAvoidAvoids();    % �������ϰ���֮����ײ����
            noise = [-1+rand*2 -1+rand*2];          %  �������
            cohese = obj.getCohesion();             % ����֮������
            dest = obj.getDestination();            % ��Ŀ�ĵ��ƶ�
            
            %             disp('move');
            %             disp([allign;avoidDir;avoidObjects;noise;cohese]);
            
            obj.move = obj.move + allign*50;        % ��߳˳�����Ϊ�˵����ĸ����ص�Ӱ���С
            obj.move = obj.move + avoidDir*20;
            obj.move = obj.move + avoidObjects*50;
            obj.move = obj.move + noise;
            obj.move = obj.move + cohese*10;
            obj.move = obj.move + dest;
            obj.limitSpeed();
            obj.shade = obj.shade + obj.getAverageColor() * 0.03;
            obj.shade = obj.shade + rand*2 -1;
            obj.shade = mod(round(obj.shade + 255),255);
        end
        
        function bool=isFriend(obj,oneObj)
            % �Ƿ��ھ�
            friendRadius = obj.boidsObj.settings.friendRadius;
            if (abs(obj.pos(1) - oneObj.pos(1)) < friendRadius ) && ...
                    (abs(obj.pos(2) - oneObj.pos(2)) < friendRadius)
                bool = 1;
            else
                bool = 0;
            end
        end
        
        function getFriends(obj)
            % �õ��ھ�
            maxlen = length(obj.boidsObj.boids);
            nearby(1,maxlen) = Boid(); % ������������ Ԥ��������
            i = 1;
            for boid = obj.boidsObj.boids
                if boid == obj
                    continue;
                elseif obj.isFriend(boid)
                    nearby(i) = boid;
                    i = i + 1;
                end
            end
            obj.friends = nearby(1:i-1);
        end
        
        function color = getAverageColor(obj)
            % ��ɫƥ��
            total = 0;
            count = 0;
            for friend = obj.friends
                tmp = friend.shade - obj.shade;
                if tmp<-128
                    total = tmp + 255;
                elseif tmp>128
                    total = tmp - 255;
                else
                    total = tmp;
                end
                count = count + 1;
            end
            if count == 0
                color = 0;
            else
                color = total/count;
            end
        end
        
        function sum = getAverageDir(obj)
            % �ٶ�ƥ��
            friendRadius = obj.boidsObj.settings.friendRadius;
            sum = [0 0];
            count = 0;
            for friend = obj.friends
                d = dist(obj.pos,friend.pos');
                if d > 0 && d < friendRadius
                    copy = friend.move;
                    copy = copy / norm(copy);
                    copy = copy / d;
                    sum = sum + copy;
                    count = count + 1;
                end
            end
        end
        
        function steer = getAvoidDir(obj)
            % �ų���
            crowdRadius = obj.boidsObj.settings.crowdRadius;
            steer = [0 0];
            count = 0;
            for friend = obj.friends
                d = dist(obj.pos,friend.pos');
                if d>0 && d<crowdRadius
                    diff = obj.pos - friend.pos;
                    diff = diff / norm(diff);
                    diff = diff / d;
                    steer = steer + diff;
                    count = count + 1;
                end
            end
        end
        
        function steer = getAvoidAvoids(obj)
            % �ϰ������
            avoidRadius = obj.boidsObj.settings.avoidRadius;
            steer = [0 0];
            count = 0;
            for avoid = obj.boidsObj.avoids
                d = dist(obj.pos,avoid.pos');
                if d>0 && d<avoidRadius
                    diff = obj.pos - avoid.pos;
                    diff = diff / norm(diff);
                    diff = diff / d;
                    steer = steer + diff;
                    count = count + 1;
                end
            end
        end
        
        function desired = getCohesion(obj)
            % ������
            coheseRadius = obj.boidsObj.settings.coheseRadius;
            sum = [0 0];
            count = 0;
            for friend = obj.friends
                d = dist(obj.pos,friend.pos');
                if d>0 && d<coheseRadius
                    sum = sum + friend.pos;
                    count = count + 1;
                end
            end
            if count > 0
                sum = sum / count;
                desired = sum - obj.pos;
                desired = desired / (20 * norm(desired));
            else
                desired = [0 0];
            end
        end
        
        function desired = getDestination(obj)
            % ��Ŀ�ĵ��ƶ�
            destination = obj.boidsObj.settings.destination;
            d = dist(destination,obj.pos');
            desired = destination - obj.pos;
            desired = desired / norm(desired);
            %             desired = desired * d/100;
        end
        
        function increament(obj)
            % ����ˢ��Ƶ��
            obj.thinkTimer = mod(obj.thinkTimer+1,5);
        end
        
        function wrap(obj)
            % �߽����
            settings = obj.boidsObj.settings;
            width = settings.width;
            height = settings.height;
            obj.pos(1) = mod(obj.pos(1) + width,width);
            obj.pos(2) = mod(obj.pos(2) + height,height);
        end
        
        function limitSpeed(obj)
            % �����ٶ�����
            maxSpeed = obj.boidsObj.settings.maxSpeed;
            obj.move = obj.move / norm(obj.move) * maxSpeed;
        end
        
        function draw(obj)
            % ���ڸ�����ʾ
            globalScale = obj.boidsObj.settings.globalScale;
            hold on;
            % ���������������㰴move������ת
            m = makehgtform('zrotate',-1*angle(obj.move(1)+1i*obj.move(2)));
            vertex = [
                % �����εĶ�������
                15*globalScale 0;
                -7* globalScale 7* globalScale;
                -7* globalScale -7* globalScale
                ];
            vertex(:,3) = 0;
            vertex(:,4) = 1;
            tmp = vertex * m;
            vertex = tmp(:,1:2);
            % ����������������ƽ�Ƶ���������λ��
            x = vertex(:,1) + obj.pos(1);
            y = vertex(:,2) + obj.pos(2);
            % �������εı�
            plot(x,y);
            % �����ɫ
            patch(x,y,[obj.shade/255,90/255,200/255]);
            % ��friends֮�仭��
            xx = [obj.pos(1) 0];
            yy = [obj.pos(2) 0];
            for friend = obj.friends
                if obj.pos(1) < friend.pos(1) % �������֮����������ߵ�����
                    xx(2) = friend.pos(1);
                    yy(2) = friend.pos(2);
                    line(xx,yy);
                end
            end
        end
    end
    
end

