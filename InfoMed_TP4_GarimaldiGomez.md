# Parte 1: Base de Datos
En base a la consigna del trabajo práctico, se pensó en el siguiente código para la base de datos:

```sql
Table Pacientes {
  idPaciente integer [primary key]
  Nombre text
  FechaNacimiento text
  SexoBiologico text
  Calle_Direccion text
  Número_Direccion integer
  Ciudad_Direccion text
}

Table Medicos {
  idMedico integer [primary key]
  Nombre text
  Especialidad text
  DireccionProfesional text
}

Table AtencionMedica {
  idAtencion integer [primary key]
  idPaciente integer [ref: > Pacientes.idPaciente]
  idMedico integer [ref: > Medicos.idMedico]
  Fecha text
  Tipo text [note: 'Consulta o Tratamiento']
}

Table Receta {
  idReceta integer [primary key]
  idAtencion integer [ref: > AtencionMedica.idAtencion]
  idEnfermedad integer [ref: > Enfermedad.idEnfermedad]
  Medicamentos_Tratamiento text
  Indicaciones_Tratamiento text
  Duracion_Tratamiento text
}

Table Enfermedad {
  idEnfermedad integer [primary key]
  Nombre text
}
```
## 1. ¿Qué tipo de base de datos es? Clasificarla según estructura y función.
Es una base de datos relacional ya que la misma cuenta con tablas que se relacionan entre sí.
En cuanto a su función es transaccional, ya que está destinada para guardar registro de los pacientes atendidos, permitiendo realizar consultas rápidas y seguras, manteniendo la integridad de los datos registrados.

## 2. Armar el diagrama entidad-relación de la base de datos dada.

![DiagramaER ](https://github.com/user-attachments/assets/236df431-6605-4882-af55-eda830db4f54)

## 3. Armar el modelo lógico entidad-relación de la base de datos dada.
![ModeloLogicoER](https://github.com/user-attachments/assets/c7139617-a864-4ee9-beee-49f3109022dd)
En la tabla “Atención médica”, se guarda el “Tipo” que puede ser tanto “Consulta” como “Tratamiento”.

# Parte 2: SQL
Se realizaron queries sobre la base de datos proporcionada por la cátedra. Se utilizo el entorno de DB Fiddle - SQL Database Playground para verificar el resultado de las queries cargando por un lado el Schema SQL y por otro lado el Query SQL

### 1. Cuando se realizan consultas sobre la tabla paciente agrupando por ciudad los tiempos de respuesta son demasiado largos. Proponer mediante una query SQL una solución a este problema.
```sql
-- Usamos EXPLAIN para comprobar que el uso de índices efectivamente disminuye el tiempo de respuesta
-- al disminuir el número de filas que "trabaja"
EXPLAIN SELECT ciudad, COUNT(*) AS cantidad FROM Pacientes GROUP BY ciudad;
CREATE INDEX idx_ciudad ON Pacientes(ciudad);
EXPLAIN SELECT ciudad, COUNT(*) AS cantidad FROM Pacientes GROUP BY ciudad;
```
![Consigna01_result](https://github.com/user-attachments/assets/8f828911-0988-4675-9d2b-bf8a7f7549ca)
### 2. Se tiene la fecha de nacimiento de los pacientes. Se desea calcular la edad de los pacientes y almacenarla de forma dinámica en el sistema ya que es un valor típicamente consultado, junto con otra información relevante del paciente.
```sql
SELECT nombre, fecha_nacimiento,
       EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento)) AS edad
FROM Pacientes;
```
![Consigna02_result](https://github.com/user-attachments/assets/c4fbebbf-c3fc-48ab-be9d-66d58ac1828f)

### 3. La paciente, “Luciana Gómez”, ha cambiado de dirección. Antes vivía en “Avenida Las Heras 121” en “Buenos Aires”, pero ahora vive en “Calle Corrientes 500” en “Buenos Aires”. Actualizar la dirección de este paciente en la base de datos
```sql
UPDATE Pacientes
SET calle = 'Calle Corrientes', numero = '500'
WHERE nombre = 'Luciana Gómez' AND calle = 'Avenida Las Heras' AND numero = '121';
SELECT nombre, calle, numero FROM Pacientes WHERE nombre = 'Luciana Gómez'
```
![Consigna03_result](https://github.com/user-attachments/assets/d1e25437-e592-4d8c-a846-bc27f0c6629f)
### 4. Seleccionar el nombre y la matrícula de cada médico cuya especialidad sea identificada por el id 4.
```sql
SELECT nombre, matricula FROM Medicos WHERE especialidad_id = 4;
```
![Consigna04_result](https://github.com/user-attachments/assets/2537d3be-0de7-4114-bda6-f8e846e51909)
### 5. Puede pasar que haya inconsistencias en la forma en la que están escritos los nombres de las ciudades, ¿cómo se corrige esto? Agregar la query correspondiente.

```sql
-- Usamos TRIM para eliminar los espacios que puedan estar al inicio o atrás del nombre.
-- Usamos regexp_replace para eliminar los múltiples espacios entre palabras.
-- Una opción más "iterable" sería confeccionar una tabla con todas las formas de escribir las ciudades.

UPDATE Pacientes
SET ciudad = 'Buenos Aires'
WHERE regexp_replace(TRIM(LOWER(ciudad)), '\s+', ' ', 'g') IN (
    'buenos aires', 'bs aires', 'buenos aiers');

UPDATE Pacientes
SET ciudad = 'Córdoba'
WHERE LOWER(ciudad) IN ('cordoba', 'cordóva', 'córodba', 'córdoba');

UPDATE Pacientes
SET ciudad = 'Mendoza'
WHERE LOWER(ciudad) IN ('mendoza', 'mendzoa');
```
![Consigna05_result](https://github.com/user-attachments/assets/8aba2bb7-c3e5-4861-9236-0d60a7ac9e4e)

### 6. Obtener el nombre y la dirección de los pacientes que viven en Buenos Aires.

```sql
-- Asumimos que los nombres de las ciudades han sido corregidos, como se pide en el inciso 05.

SELECT nombre, calle || ' ' || numero AS direccion
FROM Pacientes
WHERE ciudad = 'Buenos Aires';
```
![Consigna06_result](https://github.com/user-attachments/assets/ed294432-c323-4687-ba97-9315fcb65de7)

### 7. Cantidad de pacientes que viven en cada ciudad.
```sql
-- Asumimos que los nombres de las ciudades han sido corregidos, como se pide en el inciso 05.

SELECT ciudad, COUNT(*) AS cantidad FROM Pacientes GROUP BY ciudad;
```
![Consigna07_result](https://github.com/user-attachments/assets/d38fd8d5-4888-4f7e-81a2-b1f6aa6f77df)


###  8. Cantidad de pacientes por sexo que viven en cada ciudad.

```sql
-- Asumimos que los nombres de las ciudades han sido corregidos, como se pide en el inciso 05.

SELECT
  p.ciudad,
  s.descripcion AS sexo,
  COUNT(*) AS cantidad
FROM Pacientes p
JOIN SexoBiologico s ON p.id_sexo = s.id_sexo
GROUP BY p.ciudad, s.descripcion
ORDER BY p.ciudad, s.descripcion;
```
![Consigna08_result](https://github.com/user-attachments/assets/e31f7bc6-4a7a-4b67-b999-101d64e2340d)

### 9. Obtener la cantidad de recetas emitidas por cada médico.
```sql
SELECT
	m.nombre,
    COUNT(r.id_receta) AS total_recetas
FROM Medicos m
LEFT JOIN Recetas r ON r.id_medico = m.id_medico
GROUP BY m.nombre, m.id_medico
ORDER BY total_recetas DESC;
```
![Consigna09_result](https://github.com/user-attachments/assets/f738aab3-98c1-409c-aa13-c3c990bc18a4)

### 10. Obtener todas las consultas médicas realizadas por el médico con ID igual a 3 durante el mes de agosto de 2024
```sql
SELECT * FROM Consultas WHERE id_medico = 3 AND fecha BETWEEN '2024-08-01' AND '2024-08-31';
```
![Consigna10_result](https://github.com/user-attachments/assets/35dcdedf-603c-4d89-84c1-52e769d9a095)

### 11. Obtener el nombre de los pacientes junto con la fecha y el diagnóstico de todas las consultas médicas realizadas en agosto del 2024.

```sql
SELECT
    p.nombre,
    c.fecha,
    c.diagnostico
FROM Consultas c
JOIN Pacientes p ON c.id_paciente = p.id_paciente
WHERE c.fecha BETWEEN '2024-08-01' AND '2024-08-31'
ORDER BY c.fecha ASC;
```
![Consigna11_result1](https://github.com/user-attachments/assets/b65fef74-5fbe-4722-bc2f-8b661f129b16)
![Consigna11_result2](https://github.com/user-attachments/assets/ccf80cbb-f7bc-4d40-b4ec-c3226ab5b655)

### 12. Obtener el nombre de los medicamentos prescritos más de una vez por el médico con ID igual a 2.

```sql
SELECT
    m.nombre,
    COUNT(*) AS cantidad
FROM Recetas r
JOIN Medicamentos m ON r.id_medicamento = m.id_medicamento
WHERE r.id_medico = 2
GROUP BY m.nombre
HAVING COUNT(*) > 1;
```
![Consigna12_result](https://github.com/user-attachments/assets/e8865aa1-8409-4132-b00a-d28c8be2c01f)

### 13. Obtener el nombre de los pacientes junto con la cantidad total de recetas que han recibido.

```sql
SELECT
    p.nombre,
    COUNT(*) AS total_recetas
FROM Recetas r
JOIN Pacientes p ON r.id_paciente = p.id_paciente
GROUP BY p.nombre
ORDER BY total_recetas DESC
```
![Consigna13_result1](https://github.com/user-attachments/assets/bb2c6ada-e4d7-4bed-bfbe-ae53dee0fdff)
![Consigna13_result2](https://github.com/user-attachments/assets/9957b75a-afa4-4f2f-9449-d84a48768718)

### 14. Obtener el nombre del medicamento más recetado junto con la cantidad de recetas emitidas para ese medicamento
```sql
-- Contamos la cantidad de veces que se repite cada id del medicamento y limitamos a mostrar el primero al
-- ser ordenado de manera descendente.

SELECT
	m.nombre,
    COUNT(*) AS total
FROM Recetas r
JOIN Medicamentos m ON r.id_medicamento = m.id_medicamento
GROUP BY m.nombre
ORDER BY total DESC
LIMIT 1;
```
![Consigna14](https://github.com/user-attachments/assets/99e6904a-38de-4e98-a7c7-0a197c0e1ed6)

### 15. Obtener el nombre del paciente junto con la fecha de su última consulta y el diagnóstico asociado.
```sql
SELECT
    p.nombre,
    c.fecha,
    c.diagnostico
FROM Pacientes p
JOIN Consultas c ON p.id_paciente = c.id_paciente
WHERE c.fecha = (
    SELECT MAX(c2.fecha)
    FROM Consultas c2
    WHERE c2.id_paciente = p.id_paciente
)
ORDER BY c.fecha ASC;
```
![Consigna15_result1](https://github.com/user-attachments/assets/fea44b6d-9c34-450d-a5a9-a5603101b217)
![Consigna15_result2](https://github.com/user-attachments/assets/1daeb912-247c-4eb6-9baf-264331a0b40d)

### 16. Obtener el nombre del médico junto con el nombre del paciente y el número total de consultas realizadas por cada médico para cada paciente, ordenado por médico y paciente.

```sql
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
```
![Consigna16_result1](https://github.com/user-attachments/assets/1dd750b7-d31d-4d5a-b18f-94dd607d7315)
![Consigna16_result2](https://github.com/user-attachments/assets/15fb6f45-a5ef-4a7b-8a72-59580c8690ab)
![Consigna16_result3](https://github.com/user-attachments/assets/34ac76db-d835-4475-87af-4d3fb60a7fc9)
![Consigna16_result4](https://github.com/user-attachments/assets/d8da9d9f-91ba-486e-81c4-bff3a7a188dd)

### 17. Obtener el nombre del medicamento junto con el total de recetas prescritas para ese medicamento, el nombre del médico que lo recetó y el nombre del paciente al que se le recetó, ordenado por total de recetas en orden descendente
```sql
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
```
![Consigna17_result1](https://github.com/user-attachments/assets/ff588854-f8e4-4e4f-a485-cdf3c0b542bd)
![Consigna17_result2](https://github.com/user-attachments/assets/298d1db1-de38-4952-96b3-54d6a986d4d3)

### 18. Obtener el nombre del médico junto con el total de pacientes a los que ha atendido, ordenado por el total de pacientes en orden descendente.
```sql
SELECT m.nombre AS medico,
       COUNT(*) AS total_consultas
FROM Consultas c
JOIN Medicos m ON c.id_medico = m.id_medico
GROUP BY m.nombre
ORDER BY total_consultas DESC;
```
![Consigna18_result](https://github.com/user-attachments/assets/df0d33da-295b-49fc-992b-db3aa6558410)

