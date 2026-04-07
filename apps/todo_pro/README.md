# todo_pro

A full-featured Flutter To-Do application built within a Monorepo architecture. 

## Important Architecture Notes

- **App Shell Only**: This package does NOT contain business logic or data storage. It is merely the application shell (routing, themes, initialization).
- **Localization**: Localizations have been moved to `packages/core`. This app consumes localizations globally to share them with `todo_lite`. Do not add JSON translation files directly to this package.
- **Commands**: Refer to `CLAUDE.md` at the root of the workspace for all testing, running, and generation instructions.
