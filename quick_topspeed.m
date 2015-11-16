clear;

%top speed you want to hit (mph)
v_max0=220;
% distance traveled (mi)
x_app0=2; %length of approach course
x_timed0=1; %length of timed section
%%% note that the standard courses are 3, 5, and 7 miles long, each with a
%%% 1 mile timed section 
% mass of bike (lb)
m0=550;
% CdA of bike (m^2)
CdA= .35;
%air density (kg/m^3)
p=1.225; 
%time step (sec)
dt=.1;

%% converting to actual useful units. please don't touch this. 
v_max=v_max0*0.44704; %(m/s);
x_app=x_app0.*1609.34; %(m)
x_timed=x_timed0*1609.34; %(m)
m=m0*0.453592; %(kg);

%% calculations

%make some profiles
t_max=2.*x_app./v_max;
a=v_max./t_max;

%velocity and acceleration
j=1;
for i=0:dt:t_max;
  v_t(j)=dt.*j.*a;
  t(j)=i;
  a_t(j)=a;
  j=j+1;

end

t_coast=x_timed./v_max;

for i=max(t):dt:t_coast+t_max;
   v_t(j)=v_max;
   t(j)=i;
   a_t(j)=0;
   j=j+1; 
end

%distance
j=2;
x_t(1)=0;
for i=0:dt:max(t)
    x_t(j)=x_t(j-1)+v_t(j).*dt;
    j=j+1;
end



%calculate drag power
d_t=.5.*p.*CdA.*v_t.^3;
%calculate acceleration power
F=m.*a_t;
dx_t(1)=0;
for i=2:1:length(x_t)
    dx_t(i)=x_t(i)-x_t(i-1);
end
W=F.*dx_t;
m_t=W./dt;

%calculate total power
p_t=m_t+d_t;

%calculate total energy use
e_t(1)=0;
for i=2:1:length(x_t)
    e_t(i)=(p_t(i)).*dt+e_t(i-1);
end
%convert to kWh
Energy=max(e_t)/(1000*3600)

%plot some useful stuff
scatter(t,p_t./1e3)
hold on
scatter(t,v_t)
legend('Power (kW)', 'Velocity (m/s)');
xlabel('Time (s)');

