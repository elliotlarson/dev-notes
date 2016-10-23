# Vue.js Notes

## Installation & getting setup

#### Via npm

```bash
$ sudo npm install -g vue
```

#### Via CDN

```html
<!-- development version -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.0.1/vue.js"></script>

<!-- production version -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.0.1/vue.min.js"></script>
```

#### Vue CLI

The Vue CLI will help you bootstrap a SPA app with Vue:

```bash
$ sudo npm install -g vue-cli
```

Create the app with:

```bash
$ vue init webpack my-project
```

#### Dev tools Chrome extension

Also, grab the [**Vue devtools** Chrome extension](https://chrome.google.com/webstore/detail/vuejs-devtools/nhdogjmejiglipccpnnnanhbledajbpd).

## Hello world

Vue.js is meant to be used as either just a view layer, the vue core library, or as a full SPA solution by including additional vue libraries.  

The basic hello world in vue uses just the core library, and it looks like this:

```html
<html> 
	<head>
		<title>Hello Vue</title> 
	</head>
	<body>
		<div id="app">
			<h1>{{ message }}</h1>
			<input v-model="message">
		</div>
	</body> 
	<script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.0.1/vue.min.js"></script>
	<script>
		var data = { message: 'Hello, world!' };
		new Vue({ el: '#app', data: data });
	</script>
</html>
```

## Template directives

#### `v-show`

For conditionally showing or hiding an element.  This directive will apply a CSS style to either show or hide the element:

```html
<div id="app">
	<h1 v-show="!name">What's your name?</h1>
	<h1 v-show="name">Hi, {{ name }}!</h1>
	<input v-model="name">
</div>
