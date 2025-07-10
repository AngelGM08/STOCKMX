
-- Tabla: proveedor
DROP TABLE IF EXISTS proveedor CASCADE;
CREATE TABLE proveedor (
    id_proveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    apellido_paterno VARCHAR(50),
    apellido_materno VARCHAR(50),
    telefono VARCHAR(15),
    email VARCHAR(100)
);

-- Tabla: producto
DROP TABLE IF EXISTS producto CASCADE;
CREATE TABLE producto (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(100),
    unidad VARCHAR(20),
    precio_unitario DECIMAL(10,2)
);

-- Tabla: producto_proveedor
DROP TABLE IF EXISTS producto_proveedor CASCADE;
CREATE TABLE producto_proveedor (
    id_producto INTEGER,
    id_proveedor INTEGER,
    precio_unitario DECIMAL(10,2),
    PRIMARY KEY (id_producto, id_proveedor),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor)
);

-- Tabla: compra_insumo
DROP TABLE IF EXISTS compra_insumo CASCADE;
CREATE TABLE compra_insumo (
    id_compra SERIAL PRIMARY KEY,
    id_proveedor INTEGER REFERENCES proveedor(id_proveedor),
    fecha DATE,
    total DECIMAL(10,2)
);

-- Tabla: detalle_compra_insumo
DROP TABLE IF EXISTS detalle_compra_insumo CASCADE;
CREATE TABLE detalle_compra_insumo (
    id_compra INTEGER,
    id_producto INTEGER,
    cantidad INTEGER,
    precio_unitario DECIMAL(10,2),
    PRIMARY KEY (id_compra, id_producto),
    FOREIGN KEY (id_compra) REFERENCES compra_insumo(id_compra),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- Tabla: platillo
DROP TABLE IF EXISTS platillo CASCADE;
CREATE TABLE platillo (
    id_platillo SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion VARCHAR(150),
    precio DECIMAL(10,2)
);

-- Tabla: platillo_producto (relación muchos a muchos)
DROP TABLE IF EXISTS platillo_producto CASCADE;
CREATE TABLE platillo_producto (
    id_platillo INTEGER,
    id_producto INTEGER,
    cantidad DECIMAL(5,2),
    PRIMARY KEY (id_platillo, id_producto),
    FOREIGN KEY (id_platillo) REFERENCES platillo(id_platillo),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);

-- Tabla: produccion_tamal
DROP TABLE IF EXISTS produccion_tamal CASCADE;
CREATE TABLE produccion_tamal (
    id_produccion SERIAL PRIMARY KEY,
    fecha DATE,
    id_platillo INTEGER REFERENCES platillo(id_platillo),
    cantidad_elaborada INTEGER
);

-- Tabla: insumo_utilizado
DROP TABLE IF EXISTS insumo_utilizado CASCADE;
CREATE TABLE insumo_utilizado (
    id_produccion INTEGER,
    id_producto INTEGER,
    cantidad_utilizada DECIMAL(5,2),
    PRIMARY KEY (id_produccion, id_producto),
    FOREIGN KEY (id_produccion) REFERENCES produccion_tamal(id_produccion),
    FOREIGN KEY (id_producto) REFERENCES producto(id_producto)
);


-- Proveedores
INSERT INTO proveedor (nombre, apellido_paterno, apellido_materno, telefono, email) VALUES ('Proveedor1', 'ApellidoP1', 'ApellidoM1', '560000001', 'proveedor1@correo.com');
INSERT INTO proveedor (nombre, apellido_paterno, apellido_materno, telefono, email) VALUES ('Proveedor2', 'ApellidoP2', 'ApellidoM2', '560000002', 'proveedor2@correo.com');
INSERT INTO proveedor (nombre, apellido_paterno, apellido_materno, telefono, email) VALUES ('Proveedor3', 'ApellidoP3', 'ApellidoM3', '560000003', 'proveedor3@correo.com');

-- Productos
INSERT INTO producto (nombre, descripcion, unidad, precio_unitario) VALUES ('Masa', 'Insumo para tamales', 'kg', 15.0);
INSERT INTO producto (nombre, descripcion, unidad, precio_unitario) VALUES ('Hojas de maíz', 'Envoltura para tamales', 'pieza', 0.5);
INSERT INTO producto (nombre, descripcion, unidad, precio_unitario) VALUES ('Rajas', 'Chiles en tiras', 'kg', 18.0);
INSERT INTO producto (nombre, descripcion, unidad, precio_unitario) VALUES ('Azúcar', 'Para tamales dulces', 'kg', 12.0);
INSERT INTO producto (nombre, descripcion, unidad, precio_unitario) VALUES ('Colorante', 'Color rosa', 'ml', 5.0);

-- Producto-Proveedor
INSERT INTO producto_proveedor (id_producto, id_proveedor, precio_unitario) VALUES (1, 2, 15.0);
INSERT INTO producto_proveedor (id_producto, id_proveedor, precio_unitario) VALUES (2, 3, 0.5);
INSERT INTO producto_proveedor (id_producto, id_proveedor, precio_unitario) VALUES (3, 1, 18.0);
INSERT INTO producto_proveedor (id_producto, id_proveedor, precio_unitario) VALUES (4, 2, 12.0);
INSERT INTO producto_proveedor (id_producto, id_proveedor, precio_unitario) VALUES (5, 3, 5.0);

-- Compras de insumo
INSERT INTO compra_insumo (id_proveedor, fecha, total) VALUES (1, '2025-06-01', 100.00);

-- Detalle de compra
INSERT INTO detalle_compra_insumo (id_compra, id_producto, cantidad, precio_unitario) VALUES (1, 1, 5, 15.00);
INSERT INTO detalle_compra_insumo (id_compra, id_producto, cantidad, precio_unitario) VALUES (1, 2, 50, 0.50);

-- Platillos
INSERT INTO platillo (nombre, descripcion, precio) VALUES ('Tamal de Rajas', 'Tamal con rajas y queso', 25.00);
INSERT INTO platillo (nombre, descripcion, precio) VALUES ('Tamal de Dulce', 'Tamal rosa con pasas', 22.00);

-- Relación platillo-producto
INSERT INTO platillo_producto (id_platillo, id_producto, cantidad) VALUES (1, 1, 1.0);
INSERT INTO platillo_producto (id_platillo, id_producto, cantidad) VALUES (1, 2, 1.0);
INSERT INTO platillo_producto (id_platillo, id_producto, cantidad) VALUES (1, 3, 0.2);
INSERT INTO platillo_producto (id_platillo, id_producto, cantidad) VALUES (2, 1, 1.0);
INSERT INTO platillo_producto (id_platillo, id_producto, cantidad) VALUES (2, 2, 1.0);
INSERT INTO platillo_producto (id_platillo, id_producto, cantidad) VALUES (2, 4, 0.3);
INSERT INTO platillo_producto (id_platillo, id_producto, cantidad) VALUES (2, 5, 0.05);

-- Producción
INSERT INTO produccion_tamal (fecha, id_platillo, cantidad_elaborada) VALUES ('2025-06-08', 1, 40);

-- Insumos utilizados en producción
INSERT INTO insumo_utilizado (id_produccion, id_producto, cantidad_utilizada) VALUES (1, 1, 8.0);
INSERT INTO insumo_utilizado (id_produccion, id_producto, cantidad_utilizada) VALUES (1, 2, 40.0);
INSERT INTO insumo_utilizado (id_produccion, id_producto, cantidad_utilizada) VALUES (1, 3, 8.0);


-- 1. Ver todos los productos con su proveedor y precio


    SELECT p.nombre AS producto, pr.nombre AS proveedor, pp.precio_unitario
    FROM producto p
    JOIN producto_proveedor pp ON p.id_producto = pp.id_producto
    JOIN proveedor pr ON pr.id_proveedor = pp.id_proveedor;
    

-- 2. Ver platillos con sus ingredientes y cantidades


    SELECT pl.nombre AS platillo, pr.nombre AS producto, pp.cantidad, pr.unidad
    FROM platillo pl
    JOIN platillo_producto pp ON pl.id_platillo = pp.id_platillo
    JOIN producto pr ON pr.id_producto = pp.id_producto
    ORDER BY pl.nombre;
    

-- 3. Historial de compras: qué se compró, a quién y cuánto


    SELECT ci.id_compra, ci.fecha, prov.nombre AS proveedor, prod.nombre AS producto,
           dci.cantidad, dci.precio_unitario, (dci.cantidad * dci.precio_unitario) AS total
    FROM compra_insumo ci
    JOIN detalle_compra_insumo dci ON ci.id_compra = dci.id_compra
    JOIN producto prod ON dci.id_producto = prod.id_producto
    JOIN proveedor prov ON ci.id_proveedor = prov.id_proveedor
    ORDER BY ci.fecha DESC;
    

-- 4. Producción de tamales con detalle de insumos usados


    SELECT pt.fecha, pla.nombre AS platillo, pt.cantidad_elaborada,
           pro.nombre AS insumo, iu.cantidad_utilizada, pro.unidad
    FROM produccion_tamal pt
    JOIN platillo pla ON pt.id_platillo = pla.id_platillo
    JOIN insumo_utilizado iu ON pt.id_produccion = iu.id_produccion
    JOIN producto pro ON iu.id_producto = pro.id_producto
    ORDER BY pt.fecha DESC;
    
