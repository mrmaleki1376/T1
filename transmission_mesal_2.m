%%be name khoda
%prozhe enteqal qodrat
%Dr. Shamekhi
%Mohammadreza Maleki
%9818874
%%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%%
%motor dovom
clc;
close All;
clear All;

M= 2355; 
g=9.81;
A=2.47;
c_d=0.49; 
d_air=1.225 ;
i_g=[4.452,2.398,1.414,1,0.802,4.4725];
Fd_r=4.875;
eff=0.85;
r_d=0.375;
d_fuel=755;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

friction_data=[0.0122 0.0124 0.0132 0.015 0.022 0.033];
velocity_data=[0 50 100 150 200 250];
v=0:10:200;   
f_r=(54804637155863*v.^4)/4835703278458516698824704 - (5784933922007731*v.^3)/2417851639229258349412352 + (4606930857732759*v.^2)/18889465931478580854784 - (7096042757327543*v)/1180591620717411303424 + 1785083920872921/144115188075855872;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N_data=1000:500:5500;
T_data=[133 139 148 151 151 148 150 144 134 118];
MUe = 3250;
SIG = 1514;
N=1000:0.1:5500; 
x = (N-MUe)/SIG;
T_E =   -5.429  *x.^8 + -0.4627*x.^7 + 26.88*x.^6 +  0.01767*x.^5 +   -44.51*x.^4 +  1.165 *x.^3 +14.99*x.^2+ -2.712 *x + 149.1 ;

for  i=1:1:6

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F_ZA= eff * i_g(i) .* Fd_r .* T_E / ( r_d * 1000 );
V  = N * 2 * pi * r_d * 3.6 /( i_g(i) * Fd_r * 60);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)

plot ( V ,1000* F_ZA , 'linewidth' ,3) 
hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
Power    = F_ZA .* V / 3.6 ;  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)
    
plot ( V , Power , 'linewidth' , 3 )
hold on;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Grad     = ( 0 :10 : 70 )' ;                                              
Velocity     = 0 : 1 : 200 ;                                               
alpha = atan ( Grad / 100 ) ;                                             
Ff=( M * g * ( 0.01 * cos( alpha ) + sin( alpha ) )* (ones(1,201)) + (ones(8,1))*(0.5 * d_air * c_d * A * (( Velocity / 3.6 ).^2 ) ))/ 1000;
%Ff    = (( M * G * (( 0.01 * cos( alpha ) + sin( alpha ) )))* (ones(1,25001))+ (ones(8,1))*(0.5 * d_air * c_d * A * ( Velocity / 3.6 ).^2  / 1000));  % Resistance Force (KN
F_air  = ( 0.5 * d_air * c_d * A * ( Velocity / 3.6 ).^2 ) / 1000 ;               
Pwf    = Ff .*((ones(8,1))* Velocity / 3.6) ;                                                
resistanceair  = F_air .* Velocity / 3.6 ;  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)

plot ( Velocity ,1000* F_air ,'--','linewidth',1.5)
hold on
plot (  Velocity ,1000* Ff ,' -- ' )
hold on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)

plot ( Velocity , resistanceair , '--', 'linewidth' , 1.5 )
hold on;
plot ( Velocity , Pwf , '--' )
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%fuel consumption %

%sfc=[300 300 325 290 305 330 360 365 400 440 ];
rpm1=1000:0.1:5500;
p1 = -120.8;
p2 = 28.89;
p3 = 468.7;
p4 =-106.3;
p5 =-487.8;
p6 = 98.22;
p7 = 80.2;
p8 = 14.3;
p9 = 73.86;
p10 = 317;
mu1 = 3250 ;
sigma2= 1514;
x = (rpm1-mu1)/sigma2;
 
sfc= p1*x.^9 + p2*x.^8 + p3*x.^7 + p4*x.^6 + p5*x.^5 + p6*x.^4 + p7*x.^3 + p8*x.^2 + p9*x + p10;
P_e   = T_E .* rpm1 * 2 * pi/ 6000 ;

 for ii  = 1:5
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vv = rpm1 * 2 * pi * r_d*3.6  /( i_g(ii) * Fd_r * 60) ;                       % Vehicle Linear Velocity (Km/h)
FC  = sfc .* P_e  ./ ( d_fuel * Vv );                                     % Fuel Consumption (lit/100Km)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(3)

plot ( Vv , FC, 'linewidth', 2 )
hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 end

% engine map %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
S=linspace(0,200,1001);
F_ZB  = ( M * g * ( 0.01*cos(0) ) + 0.5 * d_air * c_d * A * ( S / 3.6 ).^2 ) / 1000 ;
T_ZB  = F_ZB * r_d ;

for iii=1:1:5 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T_resist = T_ZB * 1000 / ( i_g(iii) * Fd_r ) ;
vr = i_g(iii) * Fd_r * 60 * S / ( 2 * pi * r_d * 3.6 ) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4)
   
plot ( vr , T_resist,'linewidth',2 )   
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rpm2=linspace(0,5000,45001);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for P = (5 : 10 : 85)';
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
T =( P*ones(1,45001)) * 1*10^4 ./ (ones(9,1)* rpm2)  ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4)
   
plot ( N , T , '-.', 'linewidth' , 1.5)
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

figure(4)

plot ( N , T_E ,'r ','linewidth',3.5 );
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)

title('\it Tractive force of a 5-speed transmission','fontsize',18,'color',[1 1 0]);
set(gca,'color',[0.75 0.75 0.75],'Xlim',[0 200],'Xcolor',[1 1 0],'Ylim',[0 10000],'Ycolor',[1 1 0],'fontsize',11,'linewidth',2);
set(gcf,'color',[0 0 0])
xlabel('\it\bf V_[_k_m_/_h_]','fontsize', 11, 'color',[1 1 0]);
ylabel('\it\bf F_[_N_]','fontsize', 11, 'color',[1 1 0]);
legend( {'1st gear' , '2nd gear' , '3rd gear' , '4th gear' ,'5th gear', 'R gear', 'air resistance' , 'alpha 0%' , 'alpha 10%' , 'alpha 20%' , 'alpha 30%' , 'alpha 40%'} );
grid minor 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)

title('\it Tractive power of a 5-speed transmission','fontsize',18,'color',[1 1 0]);
set(gca,'color',[0.75 0.75 0.75],'Xlim',[0 200],'Xcolor',[1 1 0],'Ylim',[0 70],'Ycolor',[1 1 0],'fontsize',11,'linewidth',2);
set(gcf,'color',[0 0 0])
xlabel('\it\bf V_[_k_m_/_h_]','fontsize', 11, 'color',[1 1 0]);
ylabel('\it\bf P_[_k_W_]','fontsize', 11, 'color',[1 1 0]);
legend( {'1st gear' , '2nd gear' , '3rd gear' , '4th gear' ,'5th gear', 'R gear','air resistance', 'alpha 0%' , 'alpha 10%' , 'alpha 20%' , 'alpha 30%' , 'alpha 40%', 'alpha 50%' , 'alpha 60%', 'alpha 70%' }, 'location' , 'bestoutside' );
grid minor 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(3)

title('\it Fuel Consumption of a 5-speed transmission','fontsize',18,'color',[1 1 0]);
set(gca,'color',[0.75 0.75 0.75],'Xlim',[0 200],'Xcolor',[1 1 0],'Ylim',[0 16],'Ycolor',[1 1 0],'fontsize',11,'linewidth',2);
set(gcf,'color',[0 0 0])
xlabel('\it\bf V_[_k_m_/_h_]','fontsize', 11, 'color',[1 1 0]);
ylabel('\it\bf Fuel Consumption_[_1_/_1_0_0_k_m_]','fontsize', 11, 'color',[1 1 0]);
legend( {'1st gear' , '2nd gear' , '3rd gear' , '4th gear' ,'5th gear'});
grid minor 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4)

title('\it Engine Map','fontsize',18,'color',[1 1 0]);
set(gca,'color',[0.75 0.75 0.75],'Xlim',[500 5500],'Xcolor',[1 1 0],'Ylim',[0 175],'Ycolor',[1 1 0],'fontsize',11,'linewidth',2);
set(gcf,'color',[0 0 0])
xlabel('\it\bf Engin Speed_[_r_p_m_]','fontsize', 11, 'color',[1 1 0]);
ylabel('\it\bf Engin Torque_[_N_m_]','fontsize', 11, 'color',[1 1 0]);
legend ( {' 1st gear' , ' 2nd gear' , ' 3rd gear' , ' 4th gear' , ' 5th gear '  , ' CP=5 KW' , ' CP=15 KW' , ' CP=25 KW' , ' CP=35 KW' , ' CP=45 KW' , ' CP=55 KW',' CP=65KW' ,' CP=75KW',' CP=85KW',' MAX ' } , 'Location' , 'bestoutside')
grid minor 
