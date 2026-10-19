# Sorteo POS para Windows: instalacion con un solo comando de PowerShell.
#
#   irm https://raw.githubusercontent.com/Gian0473/homebrew-tap/main/instalar.ps1 | iex
#
# Descarga el instalador de la version publicada, comprueba su huella SHA-256 e
# instala en silencio para el usuario actual, sin pedir permisos de administrador.
# Volver a ejecutarlo actualiza a la ultima version. Internet solo se usa para
# esta descarga: la app funciona sin conexion y la base de datos se conserva.
#
# Plantilla: scripts/preparar-distribucion.mjs completa la version, la huella y el
# repositorio. Solo caracteres ASCII, para que ninguna version de PowerShell lo
# lea con otra codificacion.

& {
  $ErrorActionPreference = 'Stop'
  $ProgressPreference = 'SilentlyContinue'

  $version = '1.0.0'
  $huellaEsperada = 'AE09D3918806FD62DDDB87C944E61326211C033F7A07BBD8CF511FCF73A1F3A8'
  $url = 'https://github.com/Gian0473/homebrew-tap/releases/download/v1.0.0/SorteoPOS-1.0.0-win-x64.exe'

  Write-Host "Sorteo POS $version para Windows" -ForegroundColor Cyan

  if (-not [Environment]::Is64BitOperatingSystem) {
    Write-Host 'Sorteo POS necesita Windows 10 u 11 de 64 bits.' -ForegroundColor Red
    return
  }

  # Windows PowerShell 5.1 en equipos viejos no activa TLS 1.2 por defecto.
  [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

  $archivo = Join-Path $env:TEMP "SorteoPOS-$version-win-x64.exe"
  Write-Host 'Descargando el instalador...'
  try {
    Invoke-WebRequest -Uri $url -OutFile $archivo -UseBasicParsing
  } catch {
    Write-Host "No se pudo descargar el instalador: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host 'Revisa que el equipo tenga internet y vuelve a intentarlo.'
    return
  }

  Write-Host 'Comprobando la huella SHA-256...'
  $huella = (Get-FileHash -Path $archivo -Algorithm SHA256).Hash
  if ($huella -ne $huellaEsperada) {
    Remove-Item $archivo -Force -ErrorAction SilentlyContinue
    Write-Host 'El archivo descargado no coincide con la huella publicada. Por seguridad no se instala nada.' -ForegroundColor Red
    return
  }

  # /S: sin preguntas, para este usuario. --force-run: abre la app al terminar.
  Write-Host 'Instalando...'
  $proceso = Start-Process -FilePath $archivo -ArgumentList '/S', '--force-run' -Wait -PassThru
  Remove-Item $archivo -Force -ErrorAction SilentlyContinue
  if ($proceso.ExitCode -ne 0) {
    Write-Host "El instalador no pudo terminar (error $($proceso.ExitCode))." -ForegroundColor Red
    return
  }

  Write-Host "Listo: Sorteo POS $version instalado. La app se abre sola." -ForegroundColor Green
}
