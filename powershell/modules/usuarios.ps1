function Listar-Usuarios {
    Clear-Host
    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "  USUARIOS Y ÚLTIMO LOGIN" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        # Obtener usuarios locales del sistema
        $usuarios = Get-LocalUser | Sort-Object Name
        
        # Obtener sesiones activas para complementar información
        $sesionesActivas = @{}
        try {
            $queryUser = query user 2>$null
            if ($queryUser) {
                $queryUser | Select-Object -Skip 1 | ForEach-Object {
                    if ($_ -match '^\s*>?(\S+)') {
                        $usuarioActivo = $matches[1]
                        $sesionesActivas[$usuarioActivo] = $true
                    }
                }
            }
        } catch {
            # Si falla query user, continuar sin esta información
        }
        
        # Obtener información de eventos de login del registro de Windows (últimos 30 días)
        $ultimosLogins = @{}
        try {
            $eventos = Get-WinEvent -FilterHashtable @{
                LogName = 'Security'
                Id = 4624  # Evento de inicio de sesión exitoso
                StartTime = (Get-Date).AddDays(-30)
            } -ErrorAction SilentlyContinue | Where-Object {
                $_.Properties[5].Value -notmatch '^(SYSTEM|DWM-|UMFD-)'
            } | Group-Object { $_.Properties[5].Value } | ForEach-Object {
                $ultimosLogins[$_.Name] = ($_.Group | Sort-Object TimeCreated -Descending | Select-Object -First 1).TimeCreated
            }
        } catch {
            # Si no hay permisos o no hay eventos, continuar
        }
        
        Write-Host ("{0,-25} {1,-30} {2}" -f "Usuario", "Último Login", "Estado") -ForegroundColor Green
        Write-Host ("-" * 75) -ForegroundColor Gray
        
        foreach ($usuario in $usuarios) {
            $nombre = $usuario.Name
            
            # Determinar el último login usando múltiples fuentes
            $ultimoLogin = "Nunca"
            $esActivo = $false
            
            # 1. Verificar si está conectado actualmente
            if ($sesionesActivas.ContainsKey($nombre)) {
                $ultimoLogin = "Conectado ahora"
                $esActivo = $true
            }
            # 2. Verificar en eventos de seguridad
            elseif ($ultimosLogins.ContainsKey($nombre)) {
                $ultimoLogin = $ultimosLogins[$nombre].ToString("yyyy-MM-dd HH:mm:ss")
            }
            # 3. Usar la propiedad LastLogon de Get-LocalUser
            elseif ($usuario.LastLogon) {
                $ultimoLogin = $usuario.LastLogon.ToString("yyyy-MM-dd HH:mm:ss")
            }
            
            $estado = if ($usuario.Enabled) { "Activo" } else { "Deshabilitado" }
            
            # Colorear si está conectado actualmente
            if ($esActivo) {
                Write-Host ("{0,-25} " -f $nombre) -NoNewline
                Write-Host ("{0,-30} " -f $ultimoLogin) -ForegroundColor Green -NoNewline
                Write-Host ("{0}" -f $estado)
            } else {
                Write-Host ("{0,-25} {1,-30} {2}" -f $nombre, $ultimoLogin, $estado)
            }
        }
        
        Write-Host ""
        Write-Host "Total de usuarios: $($usuarios.Count)" -ForegroundColor Yellow
        
        $cantidadActivos = $sesionesActivas.Count
        if ($cantidadActivos -gt 0) {
            Write-Host ""
            Write-Host "Sesiones activas actualmente: $cantidadActivos" -ForegroundColor Green
        }
        
    } catch {
        Write-Host "Error al obtener información de usuarios: $_" -ForegroundColor Red
        Write-Host "Nota: Se requieren permisos de administrador para ver toda la información." -ForegroundColor Yellow
    }
    
    Write-Host ""
}
