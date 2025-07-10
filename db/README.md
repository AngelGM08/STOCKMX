# Scripts de Base de Datos - STOCKMX

Este archivo contiene la estructura y carga inicial para la base de datos del sistema de gestión de inventarios STOCKMX.

## Archivo incluido

- `stockmx_estructura_tablas.sql`: crea todas las tablas necesarias, inserta datos de prueba y contiene consultas útiles.

## ¿Cómo restaurar la base de datos?

1. Abre tu consola y crea una base de datos vacía:

   ```bash
   createdb stockmx

2. Ejecuta el script

psql -U tu_usuario -d stockmx -f db/stockmx_estructura_tablas.sql
