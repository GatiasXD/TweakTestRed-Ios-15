# SwitchColor15 v0.4.0

- iOS 15 / iPhone 7 / Dopamine Rootless / arm64
- Presets: rojo, verde, azul y morado
- RGB personalizado
- Preferencias dentro de Ajustes mediante PreferenceLoader
- Empaquetado manual Rootless: /var/jb/Library/...
- No usa `THEOS_PACKAGE_SCHEME=rootless` para evitar que dpkg intente crear el legacy `/Library/MobileSubstrate` en el root de Dopamine.
