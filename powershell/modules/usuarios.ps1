# Módulo: Gestión de Usuarios
# Función: Desplegar usuarios y fecha/hora de último login

function Listar-Usuarios {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "  USUARIOS Y ÚLTIMO LOGIN" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        # Obtener usuarios locales del sistema
        $usuarios = Get-LocalUser | Sort-Object Name
        
        Write-Host ("{0,-25} {1,-30} {2}" -f "Usuario", "Último Login", "Estado") -ForegroundColor Yellow
        Write-Host ("-" * 75) -ForegroundColor Gray
        
        foreach ($usuario in $usuarios) {
            $nombre = $usuario.Name
            $ultimoLogin = if ($usuario.LastLogon) { 
                $usuario.LastLogon.ToString("yyyy-MM-dd HH:mm:ss")
            } else { 
                "Nunca" 
            }
            $estado = if ($usuario.Enabled) { "Activo" } else { "Deshabilitado" }
            
            $color = if ($usuario.Enabled) { "White" } else { "DarkGray" }
            Write-Host ("{0,-25} {1,-30} {2}" -f $nombre, $ultimoLogin, $estado) -ForegroundColor $color
        }
        
        Write-Host ""
        Write-Host "Total de usuarios: $($usuarios.Count)" -ForegroundColor Green
        
    } catch {
        Write-Host "Error al obtener información de usuarios: $_" -ForegroundColor Red
        Write-Host "Nota: Se requieren permisos de administrador para ver todos los usuarios." -ForegroundColor Yellow
    }
    
    Write-Host ""
}
