SELECT nombre, fecha_nacimiento,
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento)) AS edad
FROM Pacientes;