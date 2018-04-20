# React Jest Notes

## Basic Syntax

Jest has a similar structure to Jasmine.

```javascript
describe("<MeaningOfLife />", () => {
  describe("askQuestion", () => {
    let answer;

    beforeEach(() => {
      answer = askQuestion();
    });

    it("gives the answer to everthing", () => {
      expect(answer).toEqual(42);
    });
  });
});
```

### Some common matchers

Here are the docs with a [complete list of matchers](https://facebook.github.io/jest/docs/en/expect.html).

```javascript
expect(value).toEqual(23);
expect(arr).toHaveLength(5);
expect(nullVal).toBeNull();
expect(myObj).toHaveProperty("firstName", "JimBob");
expect(myObj.foo).toBeUndefined();
expect(result).toBeCloseTo(3.14159);
```

You can negate any of them with the `not` method chain:

```javascript
expect(value).not.toEqual(23);
```

## Mocking

You can mock a method and then test that it was called:

```javascript
const doSomething = jest.fn();

it("did something", () => {
  doSomething('please');

  expect(doSomething.mock.calls.length).toEqual(1);
  expect(doSomething.mock.calls[0][0]).toEqual("please");

  expect(doSomething).toHaveBeenCalledTimes(1);
  expect(doSomething).toHaveBeenCalledWith("please");
});
```

You can also spy on a method:

```javascript
const elliotIs = { cool: () => {} };

it("verifies coolness", () => {
  const coolSpy = jest.spyOn(elliotIs, "cool");
  elliotIs.cool();
  expect(coolSpy).toHaveBeenCalled();
});
```

If you want to focus an `it` or a `describe` section, use `only`

```javascript
it.only("verifies coolness", () => {
  const coolSpy = jest.spyOn(elliotIs, "cool");
  elliotIs.cool();
  expect(coolSpy).toHaveBeenCalled();
});
```

## Command line usage

To execute the whole suite

```bash
$ jest test
```

To execute the whole suite with coverage

```bash
$ jest test --coverage
```

This will create a coverage report in `coverage/lcov-report/index.html`

To run the suite in watch mode, where it will re-run everytime a file is saved

```bash
$ jest test --watchAll
```

To run for a single file

```bash
$ jest test MyComponent.spec.js
```

To watch the one file

```bash
$ jest test --watch MyComponent.spec.js
```

## Working with Enzyme

Using the [Enzyme](http://airbnb.io/enzyme/) library from AirBnb can help make React component testing better.

### Snapshot testing

Snapshot testing with Enzyme is a bit simpler than with vanilla Jest

```javascript
describe("<Foo />", () => {
  let wrapper;

  beforeEach(() => {
    wrapper = shallow(<Foo />);
  });

  describe("snapshot", () => {
    it("renders correctly", () => {
      expect(wrapper).toMatchSnapshot();
    });
  });
});
```

### Working with the shallow render

Once you've used `shallow` to render the component, you can interact with it in a few useful ways.

#### Setting state

```javascript
wrapper.setState({ foo: "bar" });
```

#### Getting state

```javascript
wrapper.state("foo");
```

#### Setting props

```javascript
wrapper.setProps({ foo: "bar" });
```

#### Working with instance methods and properties

The shallow render is just a shallow rendered instance of the component class.  The instance of this object is available with `wrapper.instance()`.  Off of this you can work with methods and data on the class.

This can be useful for properties that are not a part of the object's state

```javascript
class Foo extends Component {
  constructor(props) {
    super(props);
    this.foo = "bar";
  }
}

// ... then in your test
wrapper.instance().foo; // bar
```

This can also be a useful way to mock out methods

```javascript
class Foo extends Component {
  myMethod() {
    // does some stuff
  }
}

// ... then in your test
const myMethodMock = jest.fn();
wrapper.instance().myMethod = myMethodMock;
// ... some testing stuff that calls myMethod()
expect(myMethodMock).toHaveBeenCalledTimes(1);
```

#### Simulating events

You can also use the shallow wrapper to find rendered elements and simulate events on them

```javascript
wrapper.find("button").simulate("click");
expect(onButtonClickMock).toHaveBeenCalledTimes(1);
```
