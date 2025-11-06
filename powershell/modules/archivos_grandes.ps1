# Módulo: Búsqueda de Archivos
# Función: Encontrar los 10 archivos más grandes en un filesystem

function Buscar-ArchivosGrandes {
    Clear-Host
    Write-Host "=========================================="
    Write-Host "  ARCHIVOS MÁS GRANDES"
    Write-Host "=========================================="
    Write-Host ""
    
    # Obtener unidades disponibles
    $unidades = Get-PSDrive -PSProvider FileSystem | Where-Object { $null -ne $_.Used }
    
    if ($unidades.Count -eq 0) {
        Write-Host "No se encontraron unidades disponibles."
        Write-Host ""
        return
    }
    
    # Mostrar menú de unidades
    Write-Host "Unidades disponibles:"
    Write-Host ""
    
    $index = 1
    $menuUnidades = @{}
    foreach ($unidad in $unidades) {
        $nombre = $unidad.Name + ":\"
        $tamanoTotal = $unidad.Used + $unidad.Free
        $libre = $unidad.Free
        
        Write-Host ("  {0}. {1,-10} (Total: {2,10:N2} GB, Libre: {3,10:N2} GB)" -f $index, $nombre, ($tamanoTotal / 1GB), ($libre / 1GB))
        $menuUnidades[$index.ToString()] = $nombre
        $index++
    }
    
    Write-Host ""
    $seleccion = Read-Host "Seleccione el número de la unidad a analizar"
    
    # Validar selección
    if ([string]::IsNullOrWhiteSpace($seleccion)) {
        Write-Host ""
        Write-Host "Error: Debe seleccionar una opción."
        Write-Host ""
        return
    }
    
    if (-not $menuUnidades.ContainsKey($seleccion)) {
        Write-Host ""
        Write-Host "Error: Selección inválida. Debe ingresar un número entre 1 y $($unidades.Count)."
        Write-Host ""
        return
    }
    
    $filesystem = $menuUnidades[$seleccion]
    
    Write-Host ""
    Write-Host "Analizando unidad: $filesystem"
    Write-Host "Esto puede tomar varios minutos dependiendo del tamaño del disco..."
    Write-Host ""
    
    try {
        # Buscar los 10 archivos más grandes
        $archivos = Get-ChildItem -Path $filesystem -File -Recurse -ErrorAction SilentlyContinue | 
                    Sort-Object Length -Descending | 
                    Select-Object -First 10
        
        if ($archivos.Count -eq 0) {
            Write-Host "No se encontraron archivos en la ruta especificada."
        } else {
            Write-Host ("{0,-50}  {1,20}  {2}" -f "Nombre del Archivo", "Tamaño (bytes)", "Ruta Completa")
            Write-Host ("-" * 130)
            
            foreach ($archivo in $archivos) {
                $nombre = $archivo.Name
                $tamano = $archivo.Length
                $ruta = $archivo.FullName
                
                Write-Host ("{0,-50}  {1,20:N0}  {2}" -f $nombre, $tamano, $ruta)
            }
            
            Write-Host ""
            Write-Host "Total de archivos encontrados en top 10: $($archivos.Count)"
        }
        
    } catch {
        Write-Host "Error al buscar archivos: $_"
    }
    
    Write-Host ""
}
