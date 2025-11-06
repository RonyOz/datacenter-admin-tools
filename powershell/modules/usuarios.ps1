# Módulo: Gestión de Usuarios
# Función: Desplegar usuarios y fecha/hora de último login

function Listar-Usuarios {
    Clear-Host
    Write-Host "=========================================="
    Write-Host "  USUARIOS Y ÚLTIMO LOGIN"
    Write-Host "=========================================="
    Write-Host ""
    
    try {
        # Obtener usuarios locales del sistema
        $usuarios = Get-LocalUser | Sort-Object Name
        
        Write-Host ("{0,-25} {1,-30} {2}" -f "Usuario", "Último Login", "Estado")
        Write-Host ("-" * 75)
        
        foreach ($usuario in $usuarios) {
            $nombre = $usuario.Name
            $ultimoLogin = if ($usuario.LastLogon) { 
                $usuario.LastLogon.ToString("yyyy-MM-dd HH:mm:ss")
            } else { 
                "Nunca" 
            }
            $estado = if ($usuario.Enabled) { "Activo" } else { "Deshabilitado" }
            
            Write-Host ("{0,-25} {1,-30} {2}" -f $nombre, $ultimoLogin, $estado)
        }
        
        Write-Host ""
        Write-Host "Total de usuarios: $($usuarios.Count)"
        
    } catch {
        Write-Host "Error al obtener información de usuarios: $_"
        Write-Host "Nota: Se requieren permisos de administrador para ver todos los usuarios."
    }
    
    Write-Host ""
}
