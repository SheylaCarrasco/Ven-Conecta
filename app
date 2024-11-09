1. README.md
# Ven Conecta

**Hackathon Desafío**: "Cómo facilitar la recolección, análisis y uso eficiente de datos para negocios que operan fuera de las estructuras tradicionales."

**Descripción**: **Ven Conecta** es una aplicación desarrollada para las PYMEs que operan en entornos informales, con el objetivo de brindarles acceso a herramientas de recolección y análisis de datos. La aplicación permite capturar datos mediante OCR, almacenarlos en la nube, y visualizarlos en un panel interactivo con gráficos, permitiendo tomar decisiones informadas sin necesidad de conocimientos técnicos avanzados.

**Tecnologías Utilizadas**:
- **AppSheet**: Plataforma sin código que permite automatizar y gestionar la captura y visualización de datos.
- **Google Sheets**: Base de datos en la nube para almacenar datos de manera sencilla y accesible.
- **Google Cloud Platform (GCP)**: Infraestructura en la nube para asegurar accesibilidad y escalabilidad.
- **OCR**: Función de AppSheet para el reconocimiento y extracción de texto en imágenes, transformando documentos físicos en datos digitales.

**Características**:
- Captura automática de datos mediante OCR
- Almacenamiento seguro en la nube
- Visualización de datos en un dashboard interactivo
- Alertas automáticas de gastos altos y recomendaciones financieras

---

#### 2. Automations.md

```markdown
# Automatizaciones en Ven Conecta

Este documento describe cada una de las automatizaciones implementadas en **Ven Conecta**, incluyendo los detalles de su funcionamiento.

## Bot: Alerta de Gastos Altos
Esta automatización envía una alerta cuando se registra un gasto superior al umbral establecido.

- **Nombre**: Alerta de Gastos Altos
- **Evento**: Activado cuando se añade o actualiza un registro en la tabla `Registros`.
- **Condición**: 
  ```appsheet
  [Categoría] = "Gastos" AND [Monto] > 500
Explicación: Esta condición verifica que el registro sea de tipo "Gastos" y que el monto supere los 500 soles.

Acción: Notificación que alerta al usuario sobre el gasto alto.
Asunto: "Alerta de Gasto Alto"
Mensaje: "Se ha registrado un gasto alto de S/ [Monto] en la fecha [Fecha]. Por favor, revisa tus gastos."
Bot: Copia Automática de Texto Extraído
Este bot transfiere los datos extraídos de OCR a los campos de la tabla.

Nombre: Copiar Texto Extraído
Evento: Activado al agregar o actualizar un registro en la tabla Registros.
Acción: Data: set the values of some columns in this row
Fecha:
IF(CONTAINS([TextoExtraído], "fecha"), EXTRACTDATE([TextoExtraído]), [Fecha])
Categoría
IF(CONTAINS([TextoExtraído], "categoría"), "Ventas" o "Gastos", [Categoría])
Monto:
IF(CONTAINS([TextoExtraído], "monto"), EXTRACTNUMBER([TextoExtraído]), [Monto])
Detalle:
MID([TextoExtraído], FIND("detalle", [TextoExtraído]), LEN([TextoExtraído]))

---

#### 3. Formulas.md

```markdown
# Expresiones y Fórmulas en Ven Conecta

## Fórmulas de Resumen de Datos

### Total Ventas
Calcula la suma de todos los registros en la categoría de Ventas.

- **Tabla**: Registros
- **Columna**: `Total Ventas`
- **Fórmula**:
  ```appsheet
  SUM(SELECT(Registros[Monto], [Categoría] = "Ventas"))
Total Gastos
Calcula el total de los gastos registrados.

Tabla: Registros
Columna: Total Gastos
Fórmula:
appsheet
Copiar código
SUM(SELECT(Registros[Monto], [Categoría] = "Gastos"))
Balance
Muestra el balance general calculando las ventas menos los gastos.

Tabla: Registros
Columna: Balance
Fórmula:
[Total Ventas] - [Total Gastos]
Expresiones de OCR en Campos
Copia de Datos OCR en Campos Editables
Fecha:
IF(CONTAINS([TextoExtraído], "Fecha"), EXTRACTDATE([TextoExtraído]), [Fecha])
Categoría:
appsheet
Copiar código
IF(CONTAINS([TextoExtraído], "Categoría"), EXTRACTTEXT([TextoExtraído]), [Categoría])

---

#### 4. Database_Schema.md

```markdown
# Esquema de la Base de Datos de Ven Conecta

La estructura de la base de datos utilizada en Google Sheets para almacenar los registros recolectados.

| Nombre de Columna   | Tipo de Dato     | Descripción                                                           |
|---------------------|------------------|-----------------------------------------------------------------------|
| `_RowNumber`        | Número           | Número de fila interno del sistema                                    |
| `Fecha`             | Fecha            | Fecha en la que se realizó la transacción                             |
| `Categoría`         | Enum             | Tipo de transacción: "Ventas", "Gastos" o "Inventario"                |
| `Detalle`           | Texto            | Descripción del detalle de la transacción                             |
| `Monto`             | Número           | Valor monetario de la transacción                                     |
| `Imagen`            | Imagen           | Imagen del documento (usado para OCR)                                 |
| `TextoExtraído`     | Texto Largo      | Texto extraído de la imagen mediante OCR                              |
| `Total Ventas`      | Número Calculado | Calcula el total de ventas (suma de los montos donde [Categoría] = "Ventas") |
| `Total Gastos`      | Número Calculado | Calcula el total de gastos (suma de los montos donde [Categoría] = "Gastos") |
| `Balance`           | Número Calculado | Diferencia entre ventas y gastos                                      |
5. App_Configuration.md
# Configuración de la App Ven Conecta

## Vistas en la Aplicación

### Ventas por Fecha
- **Tipo de Vista**: Chart (Gráfico de línea)
- **Tabla o Slice**: VentasSlice
- **Configuración**:
  - **Eje X**: Fecha
  - **Eje Y**: Monto

### Gastos por Categoría
- **Tipo de Vista**: Chart (Gráfico de barras)
- **Tabla o Slice**: GastosSlice
- **Configuración**:
  - **Eje X**: Categoría
  - **Eje Y**: Monto

### Dashboard Principal
- **Tipo de Vista**: Dashboard
- **Vistas Incluidas**: Ventas por Fecha, Gastos por Categoría, Balance General
- **Modo Interactivo**: Activado

## Acciones

### Copiar Texto Extraído
Permite trasladar el contenido de OCR a campos específicos.

- **Acción**: `Data: set the values of some columns in this row`
- **Campo**:
  - **Fecha**: 
    ```appsheet
    IF(CONTAINS([TextoExtraído], "Fecha"), EXTRACTDATE([TextoExtraído]), [Fecha])
    ```
  - **Categoría**: 
    ```appsheet
    IF(CONTAINS([TextoExtraído], "Categoría"), EXTRACTTEXT([TextoExtraído]), [Categoría])
    ```
