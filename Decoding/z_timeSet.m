function z = z_timeSet()

p.fullStart  = 0.00e6; % 단위 usec. 이 시각 앞에는 발화가 아예 없다지?
p.beforeStop = 0.70e6; % before 구간이 끝나는 시점
p.onsetStart = 0.70e6; % onset 구간이 시작하는 시점
p.onsetStop  = 1.40e6; % onset 구간이 끝나는 시점
p.afterStart = 1.40e6; % after 구간이 시작하는
p.fullStop   = 1.81e6; % 이 시각 뒤에는 발화가 아예 없다지?

z = p;