# Script de Demostración de Funcionalidades
# Herramienta de Administración para Data Center - PowerShell

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  DEMOSTRACIÓN DE FUNCIONALIDADES" -ForegroundColor Cyan
Write-Host "  Herramienta de Administración Data Center" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Importar módulos
. .\modules\usuarios.ps1
. .\modules\discos.ps1
. .\modules\memoria.ps1

Write-Host "Presione Enter para ver USUARIOS Y ÚLTIMO LOGIN..." -ForegroundColor Yellow
Read-Host
Listar-Usuarios

Write-Host ""
Write-Host "Presione Enter para ver FILESYSTEMS Y ESPACIO DISPONIBLE..." -ForegroundColor Yellow
Read-Host
Listar-Discos

Write-Host ""
Write-Host "Presione Enter para ver INFORMACIÓN DE MEMORIA Y SWAP..." -ForegroundColor Yellow
Read-Host
Mostrar-Memoria

Write-Host ""
Write-Host "=============================================" -ForegroundColor Green
Write-Host "  DEMOSTRACIÓN COMPLETADA" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green
Write-Host ""
Write-Host "Nota: La funcionalidad de ARCHIVOS MÁS GRANDES requiere" -ForegroundColor Yellow
Write-Host "      especificar un directorio y puede tardar varios minutos." -ForegroundColor Yellow
Write-Host "      Puede probarla ejecutando el menú principal: .\menu.ps1" -ForegroundColor Yellow
Write-Host ""
