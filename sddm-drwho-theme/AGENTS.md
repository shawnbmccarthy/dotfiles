# SDDM Doctor Who themes
Custom SDDM greeter styling for a personal machine. Eventually this
package will bundle several backdrop / variant themes.

Assumes SDDM 0.21+ per repo root AGENTS.md.

## Rules
- Qt / QML: Target Qt Quick 2.15+ (and matching Quick Controls) so
  it matches the greeter toolchain you lint against.
- Theme config: One or more ./Themes/*.conf files back each
  variant. At runtime SDDM exposes a config context object — treat
  config as injected (not imported). Prefer readonly property …
  wrappers and small helpers (getLocaleData-style) so bindings stay
  readable and cheap in hot paths (Timer callbacks).
- Tooling: Use the QML language server and qmllint against this
  tree; configure import paths (/usr/lib/qt6/qml, /usr/lib/qt/qml
  for SddmComponents) and commit .qmllint.ini /
  .contextProperties.ini alongside the theme where needed so
  config/sddm/… don’t confuse the linter.
- Scopes: In Components/*.qml, don’t rely on Main.qml’s id: root —
  pass values in or qualify explicitly so qmllint stays honest.
- Debug: Gate visual aids (layout borders, future instrumentation)
  behind booleans exposed via config (DebugAll, DebugClock, etc.),
  not hard-coded. Document keys when you introduce them.
