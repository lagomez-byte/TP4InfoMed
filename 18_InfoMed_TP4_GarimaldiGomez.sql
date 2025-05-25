SELECT m.nombre AS medico,
       COUNT(*) AS total_consultas
FROM Consultas c
JOIN Medicos m ON c.id_medico = m.id_medico
GROUP BY m.nombre
ORDER BY total_consultas DESC;