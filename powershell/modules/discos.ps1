# Módulo: Gestión de Discos
# Función: Listar filesystems, tamaño y espacio libre en bytes

function Listar-Discos {
    Clear-Host
    Write-Host "=========================================="
    Write-Host "  FILESYSTEMS Y ESPACIO DISPONIBLE"
    Write-Host "=========================================="
    Write-Host ""
    
    try {
        # Obtener información de discos locales
        $discos = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null }
        
        Write-Host ("{0,-10} {1,20} {2,20} {3,20} {4,10}" -f "Unidad", "Tamaño (bytes)", "Usado (bytes)", "Libre (bytes)", "Uso %")
        Write-Host ("-" * 85)
        
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
            
            Write-Host ("{0,-10} {1,20:N0} {2,20:N0} {3,20:N0} {4,10:N2}" -f $nombre, $tamanoTotal, $usado, $libre, $porcentajeUso)
        }
        
        Write-Host ""
        Write-Host "Total de unidades: $($discos.Count)"
        
    } catch {
        Write-Host "Error al obtener información de discos: $_"
    }
    
    Write-Host ""
}
