# Módulo: Gestión de Discos
# Función: Listar filesystems, tamaño y espacio libre en bytes

function Listar-Discos {
    Clear-Host
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "  FILESYSTEMS Y ESPACIO DISPONIBLE" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    
    try {
        # Obtener información de discos locales
        $discos = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null }
        
        Write-Host ("{0,-10} {1,20} {2,20} {3,20} {4,10}" -f "Unidad", "Tamaño (bytes)", "Usado (bytes)", "Libre (bytes)", "Uso %") -ForegroundColor Yellow
        Write-Host ("-" * 85) -ForegroundColor Gray
        
        foreach ($disco in $discos) {
            $nombre = $disco.Name + ":\"
            $tamanoTotal = $disco.Used + $disco.Free
            $usado = $disco.Used
            $libre = $disco.Free
            $porcentajeUso = if ($tamanoTotal -gt 0) { 
                [math]::Round(($usado / $tamanoTotal) * 100, 2) 
            } else { 
                0 
            }
            
            # Color según el porcentaje de uso
            $color = if ($porcentajeUso -gt 90) { "Red" }
                     elseif ($porcentajeUso -gt 75) { "Yellow" }
                     else { "Green" }
            
            Write-Host ("{0,-10} {1,20:N0} {2,20:N0} {3,20:N0} " -f $nombre, $tamanoTotal, $usado, $libre) -NoNewline
            Write-Host ("{0,10:N2}" -f $porcentajeUso) -ForegroundColor $color
        }
        
        Write-Host ""
        Write-Host "Total de unidades: $($discos.Count)" -ForegroundColor Green
        
    } catch {
        Write-Host "Error al obtener información de discos: $_" -ForegroundColor Red
    }
    
    Write-Host ""
}
