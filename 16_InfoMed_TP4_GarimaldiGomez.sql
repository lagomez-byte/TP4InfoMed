-- Usamos la función SPLIT_PART para "eliminar" el Dr o Dra del ordenamiento alfabético.
SELECT
	m.nombre AS medico,
    p.nombre AS paciente,
    COUNT(*) AS total_consultas
FROM Consultas c
JOIN Medicos m ON c.id_medico = m.id_medico
JOIN Pacientes p ON c.id_paciente = p.id_paciente
GROUP BY m.nombre, p.nombre
ORDER BY SPLIT_PART(m.nombre, ' ', 2), p.nombre;