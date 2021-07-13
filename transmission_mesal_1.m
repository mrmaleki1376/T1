%Motor A
%%$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$%%

clc;
close All;
clear ;
%% Sec.1 Initial Values

M= 2355; 
G=9.81;
A=2.47;
c_d=0.49; 
d_air=1.225 ;
i_g=[4.452,2.398,1.414,1,0.802,4.4725];
Fd_r=4.875;
eff=0.85;
r_d=0.375;
d_fuel=755;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sec.2 Tractive Force & Tractive Power of a 5-speed transmission

friction_data=[0.0122 0.0124 0.0132 0.015 0.022 0.033];
velocity_data=[0 50 100 150 200 250];

v=0:10:250;   
f_r=(54804637155863*v.^4)/4835703278458516698824704 - (5784933922007731*v.^3)/2417851639229258349412352 + (4606930857732759*v.^2)/18889465931478580854784 - (7096042757327543*v)/1180591620717411303424 + 1785083920872921/144115188075855872;

N_data=1000:500:6000;

T_data=[134.3 149 156.2 166 163.4 161.4 160.1 163.8 156.2 145.1 131.7];
 
MUe = 3500;
SIG = 1658.1;
N=1000:1:6000; 
x = (N-MUe)/SIG;
T_E =   -12.22  *x.^8 + 4.47*x.^7 + 57.96*x.^6 + -17.91*x.^5 + -90.22 *x.^4 + 20.38*x.^3 +37.19*x.^2+ -7.118 *x + 160.1 ;

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
Velocity     = 0 : 1 : 250 ;                                               
alpha = atan ( Grad / 100 ) ;                                             
Ff    =( M * G * ( 0.01 * cos( alpha ) + sin( alpha ) )* (ones(1,251)) + (ones(8,1))*(0.5 * d_air * c_d * A * (( Velocity / 3.6 ).^2 ) ))/ 1000;
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

%% sec.3 Calculating Fuel Consumption %

%sfc=[315, 281.8 264.9 283.2 272.5 260.2 273.6 294.3 289.8 286.3 308.4];
%our data to Curve Fitting
rpm1=1000:1:6000;
       a0 = 285.3  ;
       a1 = -17.37  ;
       b1 = 6.548  ;
       a2 = 4.555  ;
       b2 = 0.6927  ;
       a3 = -13.07  ;
       b3 = -5.054  ;
       w = 1.858  ;

   mu1 = 3500;
sigma2= 1658;
x = (rpm1-mu1)./sigma2;
sfc = a0 + a1*cos(x*w) + b1*sin(x*w) + a2*cos(2*x*w) + b2*sin(2*x*w) + a3*cos(3*x*w) + b3*sin(3*x*w);
P_e =T_E .* rpm1 *( 2 * pi /60000);
figure(3)
plot(rpm1,sfc,'linewidth',2 )
figure(7)
plot(rpm1,P_e,'b' ,'linewidth',2 )
figure(6)
plot(rpm1,sfc.*P_e,'r' ,'linewidth',2 )
 for ii  = 1:5
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vv = (rpm1  * r_d *2*pi* 3.6) /( i_g(ii) * Fd_r * 60) ;   
FC = (sfc .*P_e*10 )./ ( d_fuel .* Vv );                                    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4)

plot ( Vv , FC , 'linewidth', 2 )
hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 end

 
%% Sec.4 Engine Map 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
S=linspace(0,200,1001);
F_ZB  = ( M * G * ( 0.01*cos(0) ) + 0.5 * d_air * c_d * A * ( S / 3.6 ).^2 ) / 1000 ;
T_ZB  = F_ZB * r_d ;

for iii=1:1:5 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T_resist = T_ZB * 1000 / ( i_g(iii) * Fd_r ) ;
vr = i_g(iii) * Fd_r * 60 * S / ( 2 * pi * r_d * 3.6 ) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(5)
   
plot ( vr , T_resist,'linewidth',2 )   
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rpm2=linspace(0,5000,5001);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for P = (5 : 10 : 85)';
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
T =( P*ones(1,5001)) * 1*10^4 ./ (ones(9,1)* rpm2)  ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(5)
   
plot ( N , T , '-.', 'linewidth' , 1.5)
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

%% Sec.5 Figures
figure(5)

plot ( N , T_E ,'r ','linewidth',3.5 );
hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(1)

title('\it Tractive force of a 5-speed transmission','fontsize',18,'color',[1 1 0]);
set(gca,'color',[0.75 0.75 0.75],'Xlim',[0 250],'Xcolor',[1 1 0],'Ylim',[0 10000],'Ycolor',[1 1 0],'fontsize',11,'linewidth',2);
set(gcf,'color',[0 0 0])
xlabel('\it\bf V_[_k_m_/_h_]','fontsize', 11, 'color',[1 1 0]);
ylabel('\it\bf F_[_N_]','fontsize', 11, 'color',[1 1 0]);
legend( {'1st gear' , '2nd gear' , '3rd gear' , '4th gear' ,'5th gear', 'R gear', 'air resistance' , 'alpha 0%' , 'alpha 10%' , 'alpha 20%' , 'alpha 30%' , 'alpha 40%'} );
grid minor 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(2)

title('\it Tractive power of a 5-speed transmission','fontsize',18,'color',[1 1 0]);
set(gca,'color',[0.75 0.75 0.75],'Xlim',[0 250],'Xcolor',[1 1 0],'Ylim',[0 90],'Ycolor',[1 1 0],'fontsize',11,'linewidth',2);
set(gcf,'color',[0 0 0])
xlabel('\it\bf V_[_k_m_/_h_]','fontsize', 11, 'color',[1 1 0]);
ylabel('\it\bf P_[_k_W_]','fontsize', 11, 'color',[1 1 0]);
legend( {'1st gear' , '2nd gear' , '3rd gear' , '4th gear' ,'5th gear', 'R gear','air resistance', 'alpha 0%' , 'alpha 10%' , 'alpha 20%' , 'alpha 30%' , 'alpha 40%', 'alpha 50%' , 'alpha 60%', 'alpha 70%' }, 'location' , 'bestoutside' );
grid minor 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(3)

title('\it  Specific Fuel Consumption' ,'fontsize',18,'color',[1 1 0]);
set(gca,'color',[0.75 0.75 0.75],'Xlim',[1000 6000],'Xcolor',[1 1 0],'Ylim',[250 330],'Ycolor',[1 1 0],'fontsize',11,'linewidth',2);
set(gcf,'color',[0 0 0])
xlabel('\it\bf Engin Speed_[_r_p_m_]','fontsize', 11, 'color',[1 1 0]);
ylabel('\it\bf sfc','fontsize', 11, 'color',[1 1 0]);
grid minor 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(4)

title('\it Fuel Consumption of a 5-speed transmission','fontsize',18,'color',[1 1 0]);
set(gca,'color',[0.75 0.75 0.75],'Xlim',[0 200],'Xcolor',[1 1 0],'Ylim',[0 12],'Ycolor',[1 1 0],'fontsize',11,'linewidth',2);
set(gcf,'color',[0 0 0])
xlabel('\it\bf V_[_k_m_/_h_]','fontsize', 11, 'color',[1 1 0]);
ylabel('\it\bf Fuel Consumption_[_1_/_1_0_0_k_m_]','fontsize', 11, 'color',[1 1 0]);
legend( {'1st gear' , '2nd gear' , '3rd gear' , '4th gear' ,'5th gear'});
grid minor  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(5)

title('\it Engine Map','fontsize',18,'color',[1 1 0]);
set(gca,'color',[0.75 0.75 0.75],'Xlim',[500 6000],'Xcolor',[1 1 0],'Ylim',[0 175],'Ycolor',[1 1 0],'fontsize',11,'linewidth',2);
set(gcf,'color',[0 0 0])
xlabel('\it\bf Engin Speed_[_r_p_m_]','fontsize', 11, 'color',[1 1 0]);
ylabel('\it\bf Engin Torque','fontsize', 11, 'color',[1 1 0]);
legend ( {' 1st gear' , ' 2nd gear' , ' 3rd gear' , ' 4th gear' , ' 5th gear '  , ' CP=5 KW' , ' CP=15 KW' , ' CP=25 KW' , ' CP=35 KW' , ' CP=45 KW' , ' CP=55 KW',' CP=65KW' ,' CP=75KW',' CP=85KW',' MAX ' } , 'Location' , 'bestoutside')
grid minor 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(6)

title('\it  sfs * P ' ,'fontsize',18,'color',[1 1 0]);
set(gca,'color',[0.75 0.75 0.75],'Xlim',[1000 7000],'Xcolor',[1 1 0],'Ylim',[0 3e04],'Ycolor',[1 1 0],'fontsize',11,'linewidth',2);
set(gcf,'color',[0 0 0])
xlabel('\it\bf Engin Speed_[_r_p_m_]','fontsize', 11, 'color',[1 1 0]);
ylabel('\it\bf sfc*P','fontsize', 11, 'color',[1 1 0]);
grid minor 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(7)

title('\it  Power ' ,'fontsize',18,'color',[1 1 0]);
set(gca,'color',[0.75 0.75 0.75],'Xlim',[1000 7000],'Xcolor',[1 1 0],'Ylim',[0 100],'Ycolor',[1 1 0],'fontsize',11,'linewidth',2);
set(gcf,'color',[0 0 0])
xlabel('\it\bf Engin Speed_[_r_p_m_]','fontsize', 11, 'color',[1 1 0]);
ylabel('\it\bf P','fontsize', 11, 'color',[1 1 0]);
grid minor 