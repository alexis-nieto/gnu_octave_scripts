function plot_taylor(T_poly, a, b, n)
    % Opcional: Graficar para verificar visualmente
    fplot(T_poly, [min(a, -1), max(b, 1)]);
    hold on;
    title(['Aproximación de Taylor (Grado ' num2str(n) ')']);
    xlabel('x'); ylabel('y');
    grid on;
    legend('Polinomio Taylor');
end
