SELECT m2.nombre AS medicamento,
       COUNT(*) AS total,
       m1.nombre AS medico,
       p.nombre AS paciente
FROM Recetas r
JOIN Medicos m1 ON r.id_medico = m1.id_medico
JOIN Pacientes p ON r.id_paciente = p.id_paciente
JOIN Medicamentos m2 ON r.id_medicamento = m2.id_medicamento
GROUP BY m2.nombre, m1.nombre, p.nombre
ORDER BY total DESC;