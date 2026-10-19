# Receta de Homebrew para Sorteo POS (plantilla). `scripts/preparar-distribucion.mjs`
# completa la versión, las huellas SHA-256 y el repositorio en cada versión.
cask "sorteo-pos" do
  arch arm: "arm64", intel: "x64"

  version "1.0.0"
  sha256 arm:   "58b0e180c1ad95954a5bd2669954c5fb2c1943524a6ff2195eefc1c53d4ce08c",
         intel: "a3c0eb6750bcd8c63e12a87075c09c8fe9194ef5f8d6077a1653053622b553f3"

  url "https://github.com/Gian0473/homebrew-tap/releases/download/v#{version}/SorteoPOS-#{version}-mac-#{arch}.dmg"
  name "Sorteo POS"
  desc "Sorteo del 50% en caja con botón USB, sin internet"
  homepage "https://github.com/Gian0473/homebrew-tap"

  depends_on macos: :ventura

  app "Sorteo POS.app"

  # La base de datos (~/Library/Application Support/SorteoPOS) se conserva incluso
  # con --zap: es el registro de las jugadas.
  zap trash: [
    "~/Library/Preferences/com.sentiretaller.sorteopos.plist",
    "~/Library/Saved Application State/com.sentiretaller.sorteopos.savedState",
  ]

  caveats <<~EOS
    Sorteo POS funciona sin internet. La primera vez muestra el código del
    equipo: envíaselo a tu proveedor para recibir el token de activación.

    Esta versión no está notarizada por Apple: si macOS bloquea la primera
    apertura, ve a Ajustes del Sistema → Privacidad y seguridad y pulsa
    «Abrir igualmente».
  EOS
end
