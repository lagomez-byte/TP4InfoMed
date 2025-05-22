-- Asumimos que los nombres de las ciudades han sido corregidos, como se pide en el inciso 05.

SELECT ciudad, COUNT(*) AS cantidad FROM Pacientes GROUP BY ciudad;