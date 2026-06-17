# dotfiles 

personal project, customizations for common linux applications

## software
use the software version list below when working with the configuration
files, we do not require backwards compatible options:
- `nvim`: 0.12.+ version compatible config
- `fish`: 4.7.+ version compatible config
- `sddm`: 0.21.+ version compatible theme
- `niri`: 0.26.+ version compatible config

## testing instructions

## deployment requirements

## secrets management

### storage location
- **production**:  depends on project
- **staging**: depends on project
- **development**: local .env file (gitignored, typically copied from `.env.example`)
- **ci/cd**: github actions secretes

### NEVER
`api_key = "sk_..."` in any code format!

### security rules
- NEVER commit `.env` files
- NEVER hardcode credentials
- NEVER log secret values
- NEVER log security values/event
