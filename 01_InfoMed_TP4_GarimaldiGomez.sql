-- Usamos EXPLAIN para comprobar que el uso de índices efectivamente disminuye el tiempo de respuesta
-- al disminuir el número de filas que "trabaja"
EXPLAIN SELECT ciudad, COUNT(*) AS cantidad FROM Pacientes GROUP BY ciudad;
CREATE INDEX idx_ciudad ON Pacientes(ciudad);
EXPLAIN SELECT ciudad, COUNT(*) AS cantidad FROM Pacientes GROUP BY ciudad;