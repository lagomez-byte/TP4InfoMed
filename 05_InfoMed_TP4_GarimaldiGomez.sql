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
SET ciudad = 'Córdoba'
WHERE LOWER(ciudad) IN ('cordoba', 'cordóva', 'córodba', 'córdoba');

UPDATE Pacientes
SET ciudad = 'Mendoza'
WHERE LOWER(ciudad) IN ('mendoza', 'mendzoa');