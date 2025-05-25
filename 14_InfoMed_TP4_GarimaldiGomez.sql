-- Contamos la cantidad de veces que se repite cada id del medicamento y limitamos a mostrar el primero al
-- ser ordenado de manera descendente.

SELECT
	m.nombre,
    COUNT(*) AS total
FROM Recetas r
JOIN Medicamentos m ON r.id_medicamento = m.id_medicamento
GROUP BY m.nombre
ORDER BY total DESC
LIMIT 1;