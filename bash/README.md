# Herramienta de Administración para Data Center - BASH

## Descripción
Herramientas de administración para data center desarrolladas en BASH para sistemas Linux/Unix. Compatible con WSL en Windows.

## Funcionalidades Implementadas

### 1. Usuarios y Último Login
**Archivo:** `modules/usuarios.sh`

**Qué hace:**
- Lista todos los usuarios del sistema (root + usuarios con UID >= 1000)
- Muestra fecha y hora del último login de cada usuario
- Indica el estado (Sistema/Activo/Deshabilitado)
- Filtra usuarios sin shell válido

**Cómo funciona:**
- Lee `/etc/passwd` para obtener la lista de usuarios
- Usa `lastlog` o `last` para obtener el último login
- Valida usuarios con `getent passwd`
- Formato de tabla con `printf`

---

### 2. Filesystems y Espacio Disponible
**Archivo:** `modules/discos.sh`

**Qué hace:**
- Lista todos los filesystems montados
- Muestra tamaño total, usado y libre en **bytes**
- Calcula porcentaje de uso
- Indicadores de color: verde (<75%), amarillo (75-90%), rojo (>90%)

**Cómo funciona:**
- Usa `df -B1` para obtener información en bytes
- Excluye filesystems temporales (tmpfs, devtmpfs, squashfs)
- Calcula porcentajes automáticamente
- Aplica colores ANSI según el nivel de uso

---

### 3. Archivos Más Grandes
**Archivo:** `modules/archivos_grandes.sh`

**Qué hace:**
- Muestra menú de filesystems disponibles
- Busca los 10 archivos más grandes en el filesystem seleccionado
- Muestra nombre, tamaño en bytes y ruta completa
- Indicadores de color según tamaño del archivo

**Cómo funciona:**
- Obtiene lista de filesystems con `df`
- Permite selección por número
- Usa `find` con `-printf` para buscar archivos recursivamente
- Ordena con `sort -rn` y toma los primeros 10
- Colores: rojo (>1GB), amarillo (>100MB), blanco (<100MB)

---

### 4. Información de Memoria y Swap
**Archivo:** `modules/memoria.sh`

**Qué hace:**
- Muestra información detallada de memoria RAM
- Muestra información de memoria SWAP
- Valores en bytes y GB para mejor legibilidad
- Porcentajes de uso con indicadores de color

**Cómo funciona:**
- Lee `/proc/meminfo` para obtener datos
- Convierte de KB a bytes (multiplica por 1024)
- Calcula memoria usada: total - disponible
- Usa `bc` para cálculos decimales y conversiones a GB
- Maneja el caso de sistemas sin SWAP configurado

---

## Cómo Ejecutar

### Método 1: Script de PowerShell (Recomendado para Windows)

```powershell
# Navegar al directorio bash
cd bash

# Ejecutar demostración completa
.\run_wsl.ps1 -Demo

# Ejecutar tests
.\run_wsl.ps1 -Test

# Ejecutar menú interactivo
.\run_wsl.ps1 -Menu
```

**Nota:** El script `run_wsl.ps1` convierte automáticamente los finales de línea de CRLF a LF.

### Método 2: Directamente en WSL/Linux

```bash
# Abrir WSL (si estás en Windows)
wsl

# Navegar al directorio
cd "/mnt/c/ruta/al/proyecto/bash"

# Dar permisos de ejecución
chmod +x *.sh modules/*.sh test/*.sh

# Ejecutar demostración
bash demo.sh

# O ejecutar menú principal
bash menu.sh
```

### Método 3: Comando WSL desde PowerShell

```powershell
wsl bash -c "cd '/mnt/c/ruta/al/proyecto/bash' && bash demo.sh"
```

---

## Estructura del Proyecto

```
bash/
├── menu.sh                          # Menú principal interactivo
├── demo.sh                          # Demostración completa automática
├── run_wsl.ps1                      # Ejecutor desde Windows (convierte CRLF→LF)
├── modules/
│   ├── usuarios.sh                  # Usuarios y último login
│   ├── discos.sh                    # Filesystems y espacio
│   ├── archivos_grandes.sh          # Archivos más grandes
│   ├── memoria.sh                   # Información de memoria
│   └── backup.sh                    # Backup (pendiente)
├── test/
│   └── test_funcionalidades.sh      # Test de todas las funciones
└── README.md                        # Este archivo
```

---

## Tecnologías y Comandos Utilizados

| Comando | Funcionalidad | Módulo |
|---------|--------------|--------|
| `getent passwd` | Validar usuarios | Usuarios |
| `lastlog` / `last` | Último login | Usuarios |
| `df -B1` | Info de discos en bytes | Discos |
| `find` | Búsqueda recursiva | Archivos |
| `/proc/meminfo` | Info de memoria | Memoria |
| `bc` | Cálculos decimales | Todos |
| `awk` | Procesamiento de texto | Todos |
| `printf` | Formato de salida | Todos |

---

## Resultados de Ejemplo

### Usuarios
```
Usuario              Último Login                  Estado         
-----------------------------------------------------------------------
root                 Nov 4 17:01:47 -0500         Sistema        
david                Nov 5 21:59:35 -0500         Activo         

Total de usuarios: 2
```

### Discos
```
Filesystem              Tamaño (bytes)    Usado (bytes)     Libre (bytes)     Uso %
----------------------------------------------------------------------------------------
/dev/sdd            1081101176832        1927385088     1024181436416        1%
C:\                  254695960576      245570785280        9125175296       97%

Total de filesystems: 8
```

### Memoria
```
MEMORIA RAM:
  Total:      6102945792 bytes (5.68 GB)
  En uso:      506224640 bytes (0.47 GB)
  Disponible: 5596721152 bytes (5.21 GB)
  Porcentaje: 8.29% usado

MEMORIA SWAP:
  Total:      2147483648 bytes (2.00 GB)
  En uso:              0 bytes (0 GB)
  Libre:      2147483648 bytes (2.00 GB)
  Porcentaje: 0% usado
```

---

## Notas Importantes

### Formato de Línea (CRLF vs LF)
- Los archivos BASH **deben usar LF** (Unix), no CRLF (Windows)
- El script `run_wsl.ps1` convierte automáticamente CRLF→LF
- Si editas manualmente en Windows y ejecutas en Linux:
  ```bash
  sed -i 's/\r$//' *.sh modules/*.sh
  ```

### Compatibilidad
- Probado en Ubuntu 22.04 LTS (WSL 2)
- Compatible con la mayoría de distribuciones Linux
- Funciona en WSL 1 y WSL 2
- Detecta discos de Windows montados en `/mnt/`

### Requisitos
- Bash 4.0 o superior
- Comando `bc` (calculadora)
- Comando `find` con soporte para `-printf`
- Acceso a `/proc/meminfo` y `/etc/passwd`

### Permisos
- La mayoría de funciones no requieren permisos de root
- Algunos comandos pueden mostrar más información con `sudo`
- Los errores de permisos se manejan silenciosamente con `2>/dev/null`

---

## Características Especiales

### Indicadores de Color
- **Verde**: < 75% de uso
- **Amarillo**: 75-90% de uso
- **Rojo**: > 90% de uso

### Manejo de Errores
- Validación de entrada del usuario
- Mensajes de error claros y específicos
- Redirección de errores con `2>/dev/null`
- No requiere permisos de root para operación básica

### Formato de Salida
- Alineación automática de columnas
- Conversión automática a GB cuando es necesario
- Separadores visuales claros
- Totales y resúmenes al final de cada función

