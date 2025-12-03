
clc; clear; close all;

% --- CARGAR PAQUETE SIMBÓLICO (Solo para GNU Octave) ---
% Si usas MATLAB, puedes comentar o borrar las siguientes 3 líneas.
try
    pkg load symbolic;
catch
    warning('No se pudo cargar el paquete symbolic. Asegurate de tenerlo instalado.');
end

disp('==========================================================');
disp('   CALCULADORA DINÁMICA DE TAYLOR E INTEGRACIÓN');
disp('   Función: f(x) = x * exp(x) * tan(x)');
disp('==========================================================');
disp('');

% 1. CONFIGURACIÓN DE VARIABLES SIMBÓLICAS
syms x; % Definimos x como una variable algebraica, no numérica
f = x * exp(x) * tan(x);

% 2. ENTRADA DE DATOS
n = input('Ingresa el grado máximo del polinomio (n): ');
a = input('Límite inferior de integración (a): ');
b = input('Límite superior de integración (b): ');

disp('----------------------------------------------------------');
disp('Calculando serie... por favor espera.');

% 3. CÁLCULO DE LA SERIE DE TAYLOR
% Usamos 'Order', n+1 porque la función corta ANTES del orden indicado.
% Si queremos hasta x^n, pedimos orden n+1.
T_poly = taylor(f, x, 'Order', n + 1);

disp('Polinomio de Taylor calculado (Primeros términos):');
% Mostramos solo una parte si es muy largo para no llenar la pantalla
pretty(T_poly); 

% 4. INTEGRACIÓN ANALÍTICA (SIMBÓLICA)
disp('----------------------------------------------------------');
disp('Integrando el polinomio...');
I_poly = int(T_poly, x);

% 5. EVALUACIÓN (Teorema Fundamental del Cálculo)
% Sustituimos b y a en la integral
val_b = subs(I_poly, x, b);
val_a = subs(I_poly, x, a);

% Convertimos el resultado simbólico exacto a número decimal (double)
area_aprox = double(val_b - val_a);

% 6. MOSTRAR RESULTADOS
disp('----------------------------------------------------------');
fprintf('RESULTADO FINAL (Evaluado de %.4g a %.4g):\n', a, b);
fprintf('Area Aproximada = %.8g\n', area_aprox);
disp('----------------------------------------------------------');

% Opcional: Graficar para verificar visualmente
fplot(T_poly, [min(a, -1), max(b, 1)]);
hold on;
title(['Aproximación de Taylor (Grado ' num2str(n) ')']);
xlabel('x'); ylabel('y');
grid on;
legend('Polinomio Taylor');

