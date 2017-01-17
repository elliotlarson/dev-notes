# Angular Notes

I'm starting to learn Angular with version 2, so these are Angular 2 notes.

## Expressions

You can render a value from your component in your template with double curly braces.

```typescript
@Component({
  selector: 'foo',
  template: `
    <h1>{{ title }}</h1>
  `
})
export class AppComponent {
  title: string = 'Foo';
  
  constructor() {}
}
```

This will place the value of title ("Foo") in the `<h1>` tag.

The code in the curly braces is interpolated JavaScript, so you can manipulate values.  For example, you can add:

```typescript
@Component({
  selector: 'foo',
  template: `
    <h1>{{ numberOne + numberTwo }}</h1>
  `
})
export class AppComponent {
  numberOne: number = 1;
  numberTwo: number = 2;
  
  constructor() {}
}
```

This will place the number 3 in the `<h1>` tag.

## Property binding

### One way data flow

You use square brackets `[]` to wrap a property you want to set to a value in your component class.  For example:

```typescript
@Component({
  selector: 'foo',
  template: `
    <img [src]='logoUrl' />
  `
})
export class AppComponent {
  logoUrl: string = './img/logo.svg';
  
  constructor() {}
}
```

This will bind the `src` attribute value of the image in the template to the component class's `logoUrl` property.

However, changing the value of an attribute bound like this after it has been rendered will not update the value in the component class.  For example, if we bind to an `<input>` value and then update the input's value in the browser by typing into it, it will not update the value in the component class:

```typescript
@Component({
  selector: 'foo',
  template: `
    <input [value]='name' />
    {{ name }}
  `
})
export class AppComponent {
  name: string = 'Elliot';
  
  constructor() {}
}
```

### Two way binding

In order for the data to flow both ways (from the component class to the template and from the template to the component class), you need to use two way binding.

## Angular CLI

### Testing a single file

It looks like the `ng test` command doesn't give you the ability to run specs for a single file, but you can do it with `karma` directly:

First, start the `karma` test runner with `start`.  This will unfortunately run all of your tests when it starts up:

```bash
$ node_modules/.bin/karma start
```

Then you can run the tests for a single file by calling the `karma run` command with the `--grep` option.  

The string provided for grepping is the top level describe block for the test file you care about.

```bash
$ node_modules/.bin/karma run -- --grep='Todo model'
```

This will only run the test for that file once.  If you want it to run each time the test or implementation file are updated, you can use `nodemon`:

```bash
$ node_modules/.bin/nodemon -x "node_modules/.bin/karma run -- --grep='Todo model'" -w src/app/models/todo.model.ts -w src/
app/models/todo.model.spec.ts
```

## Dependency injection

Angular includes a dependency injection framework.  The use of DI in Angular allows you to more easily test classes with dependencies.  Instead of placing dependencies inside of a class, we pass them into the constructor (inject them).  This is what's referred to as composition.  We compose a class by passing dependencies into it.  In Angular you define the dependencies you want your class to have in the constructor.  For example, we might have a `Car` class that uses an instance of an `Engine` class.  The constructor might look like `constructor(private engine: Engine)`.  Then we might instantitate it with `new Car(new Engine())`.  So, the engine dependency is passed into the `Car` class.  However, in Angular the dependency injection is handled by the DI framework.  The `Car` instance is created by the framework, and it handles creating an instance of the `Engine` class and passing into the constructor of the `Car` class for you.

In order for a class to be available as an injectable, you need to add it either to either a module or component providers section.

For example, here lets make a TodoService available application wide by adding it to the `providers` array of the `app.module.ts` file:

```typescript
@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    FormsModule,
    HttpModule,
    FirebaseModule,
  ],
  providers: [
    TodoService
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

Now, when you create a component with the `TodoService` in the constructor, Angular will inject it for you when creating an instance.

### `useClass`

Then, when you're testing a component that uses this service, you can tell the injector to use a mock in the testbed, like so:

```typescript
TestBed.configureTestingModule({
  declarations: [ TodosComponent ],
  providers: [
    { provide: TodoService, useClass: MockTodoService }
  ]
})
.compileComponents();
```

Instead of passing the `TodoService` directly to the `providers` array of the `TestBed`, we pass an object with two keys.  The `provide` key is set to the expected service class, and the `useClass` key is set to the mock used for testing.

### `useValue`

You can also use the `useValue` key instead of the `useClass` key.  `useClass` passes in the class you want to instantiate using the DI system.  If you use `useValue` instead, this becomes the value used as the instance, instead of instantiating an instance of the class.  So, if you want to instantiate your own instance outside the DI system and then just pass this in, this is your option.

### `useFactory`

If you need to define a custom factory method for instantiating an instance, you can use `useFactory`.  Here you pass in a method that constructs the instance.  You also need to provide a `deps` array that defines the objects that need to be instantiated and passed into the method.

```typescript
let heroServiceFactory = (logger: Logger, userService: UserService) => {
  return new HeroService(logger, userService.user.isAuthorized);
};

export let heroServiceProvider =
  { provide: HeroService,
    useFactory: heroServiceFactory,
    deps: [Logger, UserService]
  };
```

Then, elsewhere in the providers array:

```typescript
{
  providers: [heroServiceProvider]
}
```

## Testing

### `TestBed`

The `TestBed` helps to create an isolated testing environment for testing components.  It is essentially a special `NgModule` that you attach your component to.  The `TestBed` class's `configureTestingModule` takes a hash like `NgModule`.


