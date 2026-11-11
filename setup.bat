@echo off
chcp 65001 > nul
echo [INFO] Створення та налаштування структури проєкту CI/CD...

:: 1. Створення необхідних директорій
if not exist "src\utils\test-utils" mkdir src\utils\test-utils
if not exist ".github\workflows" mkdir .github\workflows

:: 2. Створення package.json
echo [INFO] Створення package.json...
(
echo {
echo   "name": "cicd-practical-9",
echo   "private": true,
echo   "version": "1.0.0",
echo   "type": "module",
echo   "scripts": {
echo     "dev": "vite",
echo     "build": "vite build",
echo     "lint": "eslint . --ext js,jsx --report-unused-disable-directives --max-warnings 0",
echo     "preview": "vite preview",
echo     "test": "vitest run"
echo   },
echo   "dependencies": {
echo     "react": "^18.2.0",
echo     "react-dom": "^18.2.0"
echo   },
echo   "devDependencies": {
echo     "@types/react": "^18.2.66",
echo     "@types/react-dom": "^18.2.22",
echo     "@vitejs/plugin-react": "^4.2.1",
echo     "vite": "^5.1.6",
echo     "vitest": "^1.3.1",
echo     "@testing-library/react": "^14.2.1",
echo     "@testing-library/jest-dom": "^6.4.2",
echo     "jsdom": "^24.0.0"
echo   }
echo }
) > package.json

:: 3. Створення vite.config.js
echo [INFO] Створення vite.config.js...
(
echo import { defineConfig } from 'vite';
echo import react from '@vitejs/plugin-react';
echo.
echo export default defineConfig({
echo   plugins: [react()],
echo   test: {
echo     globals: true,
echo     environment: 'jsdom',
echo     setupFiles: './src/utils/test-utils/setup.js',
echo   },
echo });
) > vite.config.js

:: 4. Створення допоміжного файлу тесту (setup.js)
echo [INFO] Створення тестового оточення...
(
echo import '@testing-library/jest-dom';
) > src\utils\test-utils\setup.js

:: 5. Створення index.html
echo [INFO] Створення index.html...
(
echo ^<!doctype html^>
echo ^<html lang="en"^>
echo   ^<head^>
echo     ^<meta charset="UTF-8" /^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0" /^>
echo     ^<title^>Vite + React^</title^>
echo   ^</head^>
echo   ^<body^>
echo     ^<div id="root"^>^</div^>
echo     ^<script type="module" src="/src/main.jsx"^>^</script^>
echo   ^</body^>
echo ^</html^>
) > index.html

:: 6. Створення main.jsx
echo [INFO] Створення main.jsx...
(
echo import React from 'react';
echo import ReactDOM from 'react-dom/client';
echo import App from './App.jsx';
echo import './index.css';
echo.
echo ReactDOM.createRoot(document.getElementById('root')).render(
echo   ^<React.StrictMode^>
echo     ^<App /^>
echo   ^</React.StrictMode^>,
echo );
) > src\main.jsx

:: 7. Створення index.css
echo [INFO] Створення index.css...
(
echo body { margin: 0; font-family: sans-serif; }
) > src\index.css

:: 8. Створення App.jsx (з методички)
echo [INFO] Створення App.jsx...
(
echo import './App.css';
echo.
echo function App ^(^) {
echo     return (
echo         ^<div className='App'^>
echo             ^<h1^>Vite + React^</h1^>
echo         ^</div^>
echo     ^);
echo }
echo.
echo export default App;
) > src\App.jsx

:: 9. Створення App.css
echo [INFO] Створення App.css...
(
echo .App { text-align: center; margin-top: 50px; }
) > src\App.css

:: 10. Створення App.test.jsx (з методички)
echo [INFO] Створення App.test.jsx...
(
echo import { describe, expect, it } from 'vitest';
echo import { render, screen } from '@testing-library/react';
echo import App from './App.jsx';
echo.
echo describe('App', async ^(^) =^> {
echo     it('should render while authenticating', ^(^) =^> {
echo         render(^<App /^>);
echo         expect(screen.getByText('Vite + React'^)).toBeInTheDocument(^);
echo     ^});
echo });
) > src\App.test.jsx

:: 11. Створення файлу CI/CD пайплайну prod.yaml
echo [INFO] Створення конфігурації GitHub Actions (.github/workflows/prod.yaml)...
(
echo name: Production deploy
echo.
echo on:
echo   push:
echo     branches:
echo       - main
echo.
echo jobs:
echo   test-and-deploy-to-netlify:
echo     runs-on: ubuntu-latest
echo.
echo     steps:
echo     - name: Checkout code
echo       uses: actions/checkout@v2
echo.
echo     - name: Use Node.js 16.x
echo       uses: actions/setup-node@v2
echo       with:
echo         node-version: '16.x'
echo.
echo     - name: Install dependencies
echo       run: npm install
echo.
echo     - name: Run tests
echo       run: npm test
echo.
echo     - name: Netlify Deploy
echo       uses: jsmrcaga/action-netlify-deploy@v2.0.0
echo       with:
echo         NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
echo         NETLIFY_SITE_ID:  ${{ secrets.NETLIFY_SITE_ID }}
echo         build_directory: './dist'
echo         install_command: npm install
echo         build_command: npm run build
) > .github\workflows\prod.yaml

echo.
echo [ SUCCESS ] Усі файли та папки успішно створено!
echo [INFO] Встановлюємо залежності через npm install...
call npm install

echo.
echo [ ГОТОВО ] Проєкт повністю налаштовано! Тепер ви можете запустити:
echo   - Локальний сервер: npm run dev
echo   - Автоматичні тести: npm run test
pause