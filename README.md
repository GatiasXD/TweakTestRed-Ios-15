# SwitchColor15

Tweak Theos rootless para iOS 15.x + Dopamine.

## Qué hace
- Solo se inyecta en `com.apple.Preferences` (Ajustes).
- Cambia el color verde de los switches activados.
- Mantiene el thumb blanco.
- Da a los switches apagados un gris personalizado.

## Cambiar a rojo
En `SwitchColor15/Tweak.xm`, sustituye:

```objc
return [UIColor colorWithRed:0.0 green:0.48 blue:1.0 alpha:1.0];
```

por:

```objc
return [UIColor colorWithRed:1.0 green:0.23 blue:0.23 alpha:1.0];
```

## Compilar
Con Theos instalado:

```bash
make clean
make package FINALPACKAGE=1
```

El `.deb` aparecerá en `packages/`.

## Instalar
En Sileo, abre el `.deb` desde Archivos/Compartir o usa una fuente local. Después aplica el reinicio de `Preferences`/userspace requerido por tu jailbreak.
