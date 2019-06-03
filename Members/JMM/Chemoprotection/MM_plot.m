function MM_plot
tspan = [0 100]; 

% Have 200 uL of CDA at 500 ug/mL

stock = 500;     % ug/mL
add =   0.0005;   % mL
well =  0.5;     % mL

% Reaction conditions %
E0 = stock*add/(add+well);  % ug/mL
S0 = 0.5;                 % umol/L

% Enzyme properties %
kM = 95.7;                      % umol/L
kcat = 408;                     % (kcat) 1/min
conv = 1000;                    % mL/L
M = 51000;                      % ug/umol
Vmax = kcat * E0 / M * conv;    % umol/L*min

P0 = 0;

yzero = [S0; P0];
 
options = odeset('AbsTol',1e-8);  
[t,y] = ode15s(@mm,tspan,yzero,options);

clf;
plot(t,y(:,1),'g','LineWidth',2)
hold on
plot(t,y(:,2),'b--','LineWidth',2)

title(strcat('CDA Activity at E0 = ', num2str(E0), ' \mug/mL'));

legend('[S]','[P]')
xlabel('Time (minutes)','FontSize',14)
ylabel('Concentration (uM)','FontSize',14)
 
set(gca,'FontWeight','Bold','FontSize',12)
grid on
      %--------------Nested function----------
      function yprime = mm(t,y)
      % MM    Michaelis-Menten reaction Rate Equation 
      yprime = zeros(2,1);
      yprime(1) = -Vmax*y(1)/(kM+y(1));
      yprime(2) = Vmax*y(1)/(kM+y(1));
      end
end