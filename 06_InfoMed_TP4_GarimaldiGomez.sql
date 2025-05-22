-- Asumimos que los nombres de las ciudades han sido corregidos, como se pide en el inciso 05.

SELECT nombre, calle || ' ' || numero AS direccion
FROM Pacientes
WHERE ciudad = 'Buenos Aires';