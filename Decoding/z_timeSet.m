function z = z_timeSet()

p.fullStart  = 0.00e6; % ���� usec. �� �ð� �տ��� ��ȭ�� �ƿ� ������?
p.beforeStop = 0.70e6; % before ������ ������ ����
p.onsetStart = 0.70e6; % onset ������ �����ϴ� ����
p.onsetStop  = 1.40e6; % onset ������ ������ ����
p.afterStart = 1.40e6; % after ������ �����ϴ�
p.fullStop   = 1.81e6; % �� �ð� �ڿ��� ��ȭ�� �ƿ� ������?

z = p;