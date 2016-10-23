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

#### `v-model`

Places the contents of the data item in the element it is attached to.  There is two way binding on this, so if you update the value on the element, the data value of the Vue object will also get updated.

You can see an example of this in the hello world example above.

#### `v-show`

For conditionally showing or hiding an element.  This directive will apply a CSS style to either show or hide the element:

```html
<div id="app">
	<h1 v-show="!name">What's your name?</h1>
	<h1 v-show="name">Hi, {{ name }}!</h1>
	<input v-model="name">
</div>
```

#### `v-if`

You can also use `v-if` to show or hide an element.  However, this directive will not use CSS.  It will either render the element or not.

```html
<div id="app">
	<h1 v-if="!name">What's your name?</h1>
	<h1 v-if="name">Hi, {{ name }}!</h1>
	<input v-model="name">
</div>
```

If you use the `<template>` tag with `v-if` and the data value is truthy, the contents will be rendered, but the template tag will not:

```html
<div id="app">
	<h1 v-if="!name">What's your name?</h1>
	<template v-if="name">
		<h1>Hi, {{ name }}!</h1>
		<p>It's nice to meet you.</p>
	</template>
	<input v-model="name">
</div>
```

You can also use standard conditional operators in the `v-if` and `v-show` directives:

```html
<h1 v-show="name">
	Hello, 
	<span v-if="gender == 'female'">miss</span>
	<span v-if="gender == 'male'">mister</span>
	{{ name }}.
</h1>
```

#### `v-else`

Following an element with a `v-if` directive, you can add an element with a `v-else` directive:

```html
<div id="app">
	<template v-if="name">
		<h1>Hi, {{ name }}!</h1>
		<p>It's nice to meet you.</p>
	</template>
	<template v-else>
		<h1>What's your name?</h1>
	</template>
	<input v-model="name">
</div>
```

#### `v-if` vs `v-show`

From the documentation:

> When using v-if, if the condition is false on initial render, it will not do anything - - the conditional block won’t be rendered until the condition becomes true for the first time. Generally speaking, v-if has higher toggle costs while v-show has higher initial render costs. So prefer v-show if you need to toggle something very often, and prefer v-if if the condition is unlikely to change at runtime.

#### `v-for`

Iterate a specified number of times:

```html
<ul>
	<li v-for="i in 11" class="list-group-item"> 
  		{{ i-1 }} times 4 equals {{ (i-1) * 4 }}.
	</li>
</ul>
```

Iterate through an array of strings:

```html
<ul>
	<li v-for="movie in movies">
		{{ movie }}
	</li>
</ul>
```

Iterate through an array of objects:

```html
<ul>
	<li v-for="movie in movies">
		{{ movie.title }} - {{ movie.release_date }}
	</li>
</ul>
```
