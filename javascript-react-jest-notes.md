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
