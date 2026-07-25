# kristal web build

this repository is a kristal project. the web build pipeline downloads the real kristal engine, copies this project into its `mods` directory, configures kristal to launch the `Birdvirus` project immediately, packages the engine as a `.love` archive, and converts it with love.js.

## local build

requirements:

- git
- node.js 22 or newer

run:

```bash
npm install
npm run build:web
```

the finished static website is written to `dist/`. serve it through a local web server rather than opening `index.html` directly:

```bash
npm run serve:web
```

## source urls

- kristal: `https://github.com/KristalTeam/Kristal.git`
- kristal zip fallback: `https://codeload.github.com/KristalTeam/Kristal/zip/refs/heads/main`
- love.js: `https://github.com/Davidobot/love.js.git`
- love.js npm package: `https://www.npmjs.com/package/love.js`

set `KRISTAL_SOURCE_DIR` to use an existing local kristal checkout instead of cloning:

```bash
KRISTAL_SOURCE_DIR=/path/to/Kristal npm run build:web
```

windows powershell:

```powershell
$env:KRISTAL_SOURCE_DIR = "C:\path\to\Kristal"
npm run build:web
```

## github pages

merge the web build branch into `main`, then open repository settings → pages and choose **github actions** as the source. every push to `main` will rebuild and deploy the project.

pull requests only build an artifact; they do not deploy.

## implementation notes

- the project id comes from `mod.json`; it is currently `Birdvirus`.
- the build uses love.js compatibility mode so github pages does not need cross-origin isolation headers.
- initial webassembly memory is calculated from the packaged game size, with a 512 mib floor.
- build output and downloaded kristal sources are ignored by git.
