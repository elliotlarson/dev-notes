# JavaScript Webpack Notes

## Getting started

Create a directory, cd into it and add webpack

```bash
$ mkdir mysite && cd mysite
$ yarn add webpack
```

The basic website structure:

```bash
$ tree -I 'node_modules' .
.
├── dist
│   ├── 36d1e2706cfa9b1a848601128ee24d63.png
│   ├── bundle.js
│   └── index.html
├── package.json
├── src
│   ├── index.js
│   ├── star.png
│   └── style.css
├── webpack.config.js
└── yarn.lock
```

A basic webpack config file `webpack.config.js`:

```javascript
const path = require('path');

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist')
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: [
          'style-loader',
          'css-loader'
        ]
      },
      {
        test: /\.(png|svg|jpg|gif)$/,
        use: [
          'file-loader'
        ]
      }
    ]
  }
};
```

Executing a webpack bundle:

```bash
$ npx webpack
```

## Webpack config sections

* Entry: The main source files (manifest files) that Webpack uses as an entry point
* Output: The resulting compiled files
* Loaders: These handle things like transpolation.  So processing from ES6 or SASS to something that the browser can understand.
* Plugins: from the documentation, "While loaders are used to transform certain types of modules, plugins can be leveraged to perform a wider range of tasks."

## Plugins

* [`HtmlWebpackPlugin`](https://webpack.js.org/plugins/html-webpack-plugin/): The plugin will generate an HTML5 file for you that includes all your webpack bundles in the body using script tags.
* [`clean-webpack-plugin`](https://www.npmjs.com/package/clean-webpack-plugin): A webpack plugin to remove/clean your build folder(s) before building

## Using ES6

Use the bable loader:

```bash
$ yarn add bable-loader babel-core babel-preset-env
```