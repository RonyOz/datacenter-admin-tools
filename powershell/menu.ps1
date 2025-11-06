# Herramienta de Administración para Data Center
# Menu Principal - PowerShell

# Importar módulos
. .\modules\usuarios.ps1
. .\modules\discos.ps1
. .\modules\archivos_grandes.ps1
. .\modules\memoria.ps1
. .\modules\backup.ps1

function Mostrar-Menu {
    Clear-Host
    Write-Host "=========================================="
    Write-Host "  HERRAMIENTAS DE ADMINISTRACIÓN"
    Write-Host "  DATA CENTER - Versión PowerShell"
    Write-Host "=========================================="
    Write-Host ""
    Write-Host "1. Usuarios y último login"
    Write-Host "2. Filesystems y espacio disponible"
    Write-Host "3. Archivos más grandes en un disco"
    Write-Host "4. Información de memoria y swap"
    Write-Host "5. Backup de directorio a USB"
    Write-Host "6. Salir"
    Write-Host ""
}

do {
    Mostrar-Menu
    $opcion = Read-Host "Seleccione una opción"
    
    switch ($opcion) {
        "1" {
            Listar-Usuarios
        }
        "2" {
            Listar-Discos
        }
        "3" {
            Buscar-ArchivosGrandes
        }
        "4" {
            Mostrar-Memoria
        }
        "5" {
            Realizar-Backup
        }
        "6" {
            Write-Host ""
            Write-Host "Saliendo del programa..."
            break
        }
        default {
            Write-Host ""
            Write-Host "Opción inválida."
        }
    }
    
    if ($opcion -ne "6") {
        Write-Host ""
        Write-Host "Presione Enter para volver al menú..."
        Read-Host
    }
    
} while ($opcion -ne "6")
