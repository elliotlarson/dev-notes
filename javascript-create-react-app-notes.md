# Create React App Notes

## Generating a Site

```bash
$ yarn create react-app <app-name>
```

## Prettier Config In VSCode

I've added this to my VScode:

```json
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true
  },
  "[javascriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.formatOnSave": true
  },
  "[typescriptreact]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
```

And I've placed a `.prettierrc.json` file in the root with:

```json
{
  "printWidth": 100,
  "trailingComma": "all",
}
```

## Adding Sass

```bash
$ yarn add node-sass
```

Then change `src/App.css` to `src/App.scss`, and update the import statement in `src/App.js`.

## Adding Stylelint

Add the following packages to the project:

```bash
$ yarn add -D stylelint stylelint-config-recommended stylelint-scss
```

Add the following file to the root directory: `.stylelintrc.json`

```json
{
  "extends": [
    "stylelint-scss",
    "stylelint-config-recommended"
  ],
  "rules": {
    "at-rule-no-unknown": [
      true,
      {
        "ignoreAtRules": ["extends", "ignores"]
      }
    ],
    "indentation": 2,
    "block-closing-brace-newline-after": "always"
  }
}
```

Add this to VSCode settings:

```json
  "[scss]": {
    "editor.formatOnSave": true
  },
  "[css]": {
    "editor.formatOnSave": true
  },
  "stylelint.enable": true,
```

## Adding P5js

Add the p5js package:

```bash
$ yarn add p5
```

Update `src/index.js` file to run a sketch:

```javascript
import "./index.css";
import P5 from "p5";

const sketch = (p5) => {
  p5.setup = () => {
    p5.createCanvas(p5.windowWidth, p5.windowHeight);
    p5.background("#111");
  };

  p5.draw = () => {
    p5.createCanvas(p5.windowWidth, p5.windowHeight);
    p5.background("#111");
    p5.stroke("#84123E");
    p5.fill("#f06");
    p5.strokeWeight(10);
    p5.ellipse(p5.windowWidth / 2, p5.windowHeight / 2, 100, 100);
  };
};

new P5(sketch, document.getElementById("root"));
```
