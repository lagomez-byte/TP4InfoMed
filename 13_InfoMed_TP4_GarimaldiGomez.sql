SELECT
    p.nombre,
    COUNT(*) AS total_recetas
FROM Recetas r
JOIN Pacientes p ON r.id_paciente = p.id_paciente
GROUP BY p.nombre
ORDER BY total_recetas DESC;