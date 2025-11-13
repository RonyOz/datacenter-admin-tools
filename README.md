# Herramientas de Administración para Data Center

Sistema de administración para centros de datos con implementaciones en Bash (Linux) y PowerShell (Windows).

## Descripción

Conjunto de herramientas que facilitan las tareas cotidianas del administrador de sistemas mediante un menú interactivo con las siguientes funcionalidades:

1. Gestión de usuarios y seguimiento de accesos
2. Monitoreo de espacio en discos y filesystems
3. Identificación de archivos de gran tamaño
4. Supervisión de uso de memoria RAM y swap
5. Sistema de respaldo con catálogo automático

## Requisitos

**Linux:**
- Bash 4.0 o superior
- Permisos de lectura en `/proc/meminfo` y `/etc/passwd`
- Comando `bc` instalado para cálculos decimales
- Acceso a comandos: `df`, `find`, `tar`, `lastlog`

**Windows:**
- PowerShell 5.1 o superior
- Permisos de administrador para información completa de usuarios
- Acceso a eventos de seguridad del sistema

## Instalación

```bash
git clone https://github.com/RonyOz/datacenter-admin-tools.git
cd datacenter-admin-tools
```

### Linux
```bash
cd bash
chmod +x menu.sh modules/*.sh
./menu.sh
```

### Windows
```powershell
cd powershell
.\menu.ps1
```

## Estructura del Proyecto

```
datacenter-admin-tools/
├── bash/
│   ├── menu.sh
│   └── modules/
│       ├── usuarios.sh
│       ├── discos.sh
│       ├── archivos_grandes.sh
│       ├── memoria.sh
│       └── backup.sh
├── powershell/
│   ├── menu.ps1
│   └── modules/
│       ├── usuarios.ps1
│       ├── discos.ps1
│       ├── archivos_grandes.ps1
│       ├── memoria.ps1
│       └── backup.ps1
└── Proyecto.md
```

## Funcionalidades

### 1. Usuarios y Último Login
Muestra todos los usuarios del sistema con información de su último acceso, incluyendo usuarios activos en tiempo real y el estado de cada cuenta.

### 2. Filesystems y Espacio Disponible
Lista todas las unidades de almacenamiento físico con información detallada en bytes: tamaño total, espacio usado, espacio libre y porcentaje de utilización.

### 3. Archivos Más Grandes
Permite seleccionar un filesystem y realiza búsqueda recursiva de los 10 archivos de mayor tamaño, mostrando ruta completa y tamaño en bytes.

### 4. Información de Memoria
Despliega estado actual de memoria RAM y swap (o archivo de paginación en Windows), mostrando valores en bytes, gigabytes y porcentajes de uso.

### 5. Backup a USB
Sistema completo de respaldo que:
- Valida directorios origen y destino
- Solicita confirmación del usuario
- Genera catálogo con nombres y fechas de modificación
- Comprime archivos (tar.gz en Linux, ZIP en Windows)
- Muestra estadísticas del backup realizado

## Autores
- David Artunduaga ([@David104087](https://github.com/David104087))
- Rony Ordoñez ([@RonyOz](https://github.com/RonyOz))
- Juan de la Pava ([@JuanJDlp](https://github.com/JuanJDlp))

## Licencia

Este proyecto es de uso académico.
