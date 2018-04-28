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

## Focusing specific tests

If you want to focus an `it` or a `describe` section, use `only`

```javascript
it.only("verifies coolness", () => {
  const coolSpy = jest.spyOn(elliotIs, "cool");
  elliotIs.cool();
  expect(coolSpy).toHaveBeenCalled();
});
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

> Creates a mock function similar to jest.fn but also tracks calls to object[methodName]. Returns a Jest mock function.

> Note: By default, jest.spyOn also calls the spied method. This is different behavior from most other test libraries.

### Clearing, resetting and restoring mocks

`mockClear` resets all information stored in the `mockFn.mock.calls` and `mockFn.mock.instances` arrays.

> Often this is useful when you want to clean up a mock's usage data between two assertions.

```javascript
const mockFn = jest.fn();
// some tests
mockFn.mockClear()
```

`mockReset` resets all information stored in the mock, including any initial implementation and mock name given.

> This is useful when you want to completely restore a mock back to its initial state.

```javascript
const mockFn = jest.fn();
// some tests
mockFn.mockReset()
```

`mockRestor` removes the mock and restores the initial implementation.

> This is useful when you want to mock functions in certain test cases and restore the original implementation in others.

```javascript
const mockFn = jest.fn();
// some tests
mockFn.mockRestor()
```

### Mocking the implementation

> Note: `jest.fn(implementation)` is a shorthand for `jest.fn().mockImplementation(implementation)`

You can add a standin implementation for a mock

```javascript
const meaningOfLife = jest.fn(() => 42);
```

You can also mock the implementation once, so the first time the mock is called, it will return the mock implementation, and then after that, the original functionality is used.  These can be chanined:

```javascript
const meaningOfLife = jest
  .fn(() => "I mean, it's a silly question, really")
  .mockImplementationOnce(() => "42")
  .mockImplementationOnce(() => "I mean it, 42")
console.log(meaningOfLife(), meaningOfLife(), meaningOfLife(), meaningOfLife())
// => 42
// => I mean it, 42
// => I mean, it's a silly question, really
// => I mean, it's a silly question, really
```

You can use `mockReturnValue` instead of `jest.fn(() => 42)`

```javascript
const mock = jest.fn().mockReturnValue(42);
mock(); // 42
```

### Mocking imports

If you are testing a class that has imports you would like to mock out, you can use `jest.mock`

Implementation:

```javascript
import knowledge from "google";

class MeaningOfLife {
  ask() {
    const googleThinks = knowlege.meaningOfLife;
    return `${googleThinks}, or 42`;
  }
}
```

Test, this mocks out `google` in the implementation file.

```javascript
import MeaningOfLife from "./meaning-of-life";
import knowledge from "google";
jest.mock("google");
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

### Working with mount renderer

The mount renderer does a full DOM render.  You need this if you are testing methods that deal with references.

```javascript
describe("mouseEnterHandler", () => {
  it("sets the style transform property of myRef", () => {
    wrapper = mount(<Foo {...defaultProps} />);
    wrapper.instance().mouseEnterHandler("event-stub");
    expect(
      wrapper.instance().myRef.current.style.transform
    ).toEqual("rotate(0deg) translate(-50%, -50%)");
  });
});
```
