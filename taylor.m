
clc; clear; close all;

% Configurar archivo de registro en el Escritorio
logFile = fullfile(getenv('HOME'), 'Desktop', 'taylor_process_log.txt');
if exist(logFile, 'file')
    delete(logFile);
end
diary(logFile);

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
% Inicializamos el polinomio en 0
T_poly = 0;

disp('----------------------------------------------------------');
disp('CÁLCULO PASO A PASO DE LA SERIE DE TAYLOR (en x=0):');
disp('Formula: f(0) + f''(0)x + f''''(0)x^2/2! + ... + f^n(0)x^n/n!');
disp('');

for k = 0:n
    fprintf('--- ORDEN k = %d ---\n', k);
    
    % 1. Calcular derivada k-ésima
    if k == 0
        D = f; % Derivada 0 es la función misma
    else
        D = diff(f, x, k);
    end
    
    % 2. Evaluar en x = 0
    val_at_0 = subs(D, x, 0);
    
    % 3. Construir el término
    term = (val_at_0 / factorial(k)) * x^k;
    
    % Mostrar información
    disp(['Derivada f^(' num2str(k) ')(x):']);
    pretty(D);
    disp(char(D));
    
    disp('Evaluada en 0:');
    pretty(val_at_0);
    disp(char(val_at_0));
    
    disp('Término agregado:');
    pretty(term);
    disp(char(term));
    disp(' ');
    
    % Acumular en el polinomio total
    T_poly = T_poly + term;
end

disp('Polinomio de Taylor calculado (Primeros términos):');
% Mostramos solo una parte si es muy largo para no llenar la pantalla
pretty(T_poly); 
disp('Versión texto completo (sin truncar):');
disp(char(T_poly)); 

% 4. INTEGRACIÓN ANALÍTICA (SIMBÓLICA)
disp('----------------------------------------------------------');
disp('Integrando el polinomio...');
I_poly = int(T_poly, x);
disp('Integral indefinida del polinomio:');
pretty(I_poly);
disp('Versión texto completo (sin truncar):');
disp(char(I_poly));

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

% plot_taylor(T_poly, a, b, n);

diary off;
disp(['Proceso guardado en: ' logFile]);



