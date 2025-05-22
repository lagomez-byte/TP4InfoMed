SELECT
	m.nombre,
    COUNT(r.id_receta) AS total_recetas
FROM Medicos m
LEFT JOIN Recetas r ON r.id_medico = m.id_medico
GROUP BY m.nombre, m.id_medico
ORDER BY total_recetas DESC;