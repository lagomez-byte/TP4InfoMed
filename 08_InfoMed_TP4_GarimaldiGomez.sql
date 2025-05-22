-- Asumimos que los nombres de las ciudades han sido corregidos, como se pide en el inciso 05.

SELECT
  p.ciudad,
  s.descripcion AS sexo,
  COUNT(*) AS cantidad
FROM Pacientes p
JOIN SexoBiologico s ON p.id_sexo = s.id_sexo
GROUP BY p.ciudad, s.descripcion
ORDER BY p.ciudad, s.descripcion;