# Tailwind CSS Notes

## Responsive breakpoints

* sm - 640px: `@media (min-width: 640px) { ... }`
* md - 768px: `@media (min-width: 768px) { ... }`
* lg - 1024px: `@media (min-width: 1024px) { ... }`
* xl - 1280px: `@media (min-width: 1280px) { ... }`
* 2xl - 1536px: `@media (min-width: 1536px) { ... }`

You can apply a size prefix to any utility class in the system.

For example:

```html
<div class="bg-yellow-500 md:bg-red-500 lg:bg-green-500">
  <!-- ... -->
</div>
```

This will be `yellow-500` on mobile and through the small breakpoint, even though `sm` isn't defined.  Then it will be `red-500` for the `md` breakpoint, and `green-500` for the `lg` breakpoint.  Even though `xl` and `2xl` are not defined, these breakpoints will also be `green-500`.

## Hover

You can define the hover state for the following utilities:

* `backgroundColor`
* `backgroundOpacity`
* `borderColor`
* `borderOpacity`
* `boxShadow`
* `gradientColorStops`
* `opacity`
* `rotate`
* `scale`
* `skew`
* `textColor`
* `textDecoration`
* `textOpacity`
* `translate`

```html
<button class="bg-red-500 hover:bg-red-700 ...">
  Hover me
</button>
```

You can also use `group-hover` for hovering over multiple elements:

```html
<div class="group border-indigo-500 hover:bg-white hover:shadow-lg hover:border-transparent ...">
  <p class="text-indigo-600 group-hover:text-gray-900 ...">New Project</p>
  <p class="text-indigo-500 group-hover:text-gray-500 ...">Create a new project from a variety of starting templates.</p>
</div>
```

## Misc

Vertically center div in screen

```html
<div class="h-screen flex flex-col justify-center">
</div>
```
