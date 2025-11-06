# Herramienta de Administración para Data Center - PowerShell

## Descripción
Este proyecto implementa herramientas para facilitar las labores del administrador de un data center en sistemas Windows usando PowerShell.

## Funcionalidades Implementadas

### 1. Usuarios y Último Login ✅
**Archivo:** `modules\usuarios.ps1`  
**Función:** `Listar-Usuarios`

**Características:**
- Lista todos los usuarios locales del sistema
- Muestra la fecha y hora del último login en formato: `yyyy-MM-dd HH:mm:ss`
- Indica el estado del usuario (Activo/Deshabilitado)
- Manejo de usuarios que nunca han iniciado sesión
- Cuenta total de usuarios

**Tecnología:** Utiliza `Get-LocalUser` para obtener información de usuarios locales.

---

### 2. Filesystems y Espacio Disponible ✅
**Archivo:** `modules\discos.ps1`  
**Función:** `Listar-Discos`

**Características:**
- Lista todas las unidades de disco del sistema
- Muestra tamaño total, espacio usado y espacio libre en **bytes**
- Calcula y muestra porcentaje de uso
- Indicadores de color según nivel de uso:
  - Verde: < 75%
  - Amarillo: 75-90%
  - Rojo: > 90%

**Tecnología:** Utiliza `Get-PSDrive` con el proveedor FileSystem.

---

### 3. Archivos Más Grandes ✅
**Archivo:** `modules\archivos_grandes.ps1`  
**Función:** `Buscar-ArchivosGrandes`

**Características:**
- Solicita al usuario la ruta del disco o directorio a analizar
- Busca recursivamente en toda la estructura de directorios
- Encuentra y muestra los 10 archivos más grandes
- Muestra el tamaño en **bytes** y la ruta completa de cada archivo
- Validación de ruta antes de iniciar búsqueda
- Manejo de errores de permisos (ErrorAction SilentlyContinue)
- Indicadores de color según tamaño:
  - Blanco: < 100 MB
  - Amarillo: 100 MB - 1 GB
  - Rojo: > 1 GB

**Tecnología:** Utiliza `Get-ChildItem` con `-Recurse` para búsqueda recursiva.

---

### 4. Información de Memoria y Swap ✅
**Archivo:** `modules\memoria.ps1`  
**Función:** `Mostrar-Memoria`

**Características:**

**Memoria RAM:**
- Total de memoria física
- Memoria en uso
- Memoria libre
- Porcentaje de uso

**Archivo de Paginación (Page File / Swap):**
- Ubicación del archivo de paginación
- Tamaño total asignado
- Espacio en uso
- Espacio libre
- Porcentaje de uso

Todos los valores se muestran en **bytes** y en GB para mejor legibilidad.

**Indicadores de color según uso:**
- Verde: < 75%
- Amarillo: 75-90%
- Rojo: > 90%

**Tecnología:** Utiliza CIM (WMI) con las clases:
- `Win32_OperatingSystem` para información de RAM
- `Win32_PageFileUsage` para información del archivo de paginación

---

## Cómo Ejecutar

### Prerrequisitos
- Windows 10 o superior
- PowerShell 5.1 o superior
- Permisos de administrador (recomendado para acceso completo a información del sistema)

### Ejecución
```powershell
# Navegar al directorio del proyecto
cd "ruta\al\proyecto\powershell"

# Ejecutar el menú principal
.\menu.ps1
```

### Navegación del Menú
1. Seleccione una opción ingresando el número correspondiente (1-6)
2. Presione Enter para confirmar
3. Después de cada operación, presione Enter para volver al menú
4. Seleccione la opción 6 para salir

---

## Resultados de Pruebas

### ✅ Opción 1 - Usuarios
- Lista correctamente todos los usuarios locales
- Muestra fecha de último login en formato legible
- Identifica usuarios activos y deshabilitados

### ✅ Opción 2 - Discos
- Detecta todas las unidades de disco
- Calcula correctamente el espacio en bytes
- Muestra porcentaje de uso con colores según nivel

### ✅ Opción 3 - Archivos Grandes
- Búsqueda recursiva funcional
- Ordena correctamente por tamaño
- Muestra ruta completa de los archivos
- Maneja errores de permisos adecuadamente

### ✅ Opción 4 - Memoria y Swap
- Obtiene correctamente información de memoria RAM
- Detecta y reporta archivo de paginación
- Cálculos precisos de bytes y porcentajes
- Indicadores visuales de uso de recursos

---

## Estructura del Proyecto
```
powershell/
├── menu.ps1                          # Menú principal
├── modules/
│   ├── usuarios.ps1                  # Módulo de usuarios
│   ├── discos.ps1                    # Módulo de discos
│   ├── archivos_grandes.ps1          # Módulo de archivos
│   ├── memoria.ps1                   # Módulo de memoria
│   └── backup.ps1                    # Módulo de backup (pendiente)
└── README_FUNCIONALIDADES.md         # Este archivo
```

---

## Notas Técnicas

### Permisos
- Algunas operaciones pueden requerir permisos de administrador
- La búsqueda de archivos omite directorios sin permisos de lectura

### Rendimiento
- La búsqueda de archivos grandes puede tardar varios minutos en discos grandes
- Se recomienda probar primero con directorios específicos
