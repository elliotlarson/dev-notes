# Spring Boot Resources

## Installing the CLI

```bash
$ brew tap pivotal/tap && brew install springboot
```

## Customize the spring terminal banner

Sort of silly, but you can customize this by adding a `banner.txt` file with overriding banner content to the `resources` directory.

## Component scanning

Spring Boot will automatically scan for packages under the app's current directory.

```java
@SpringBootApplication
public class MyAppApplication {
  public static void main(String[] args) {
    SpringApplication.run(MyAppApplication.class, args);
  }
}
```

If you have packages elsewhere that you need to add auto scanning for, you can use the `@ComponentScan` annotation.

In the following example, we're telling Spring Boot to look in the current base directory `io.onehouse` and a sibling directory `io.services`:

```java
@SpringBootApplication
@ComponentScan(basePackages = {"io.onehouse", "io.services"})
public class MyAppApplication {
  public static void main(String[] args) {
    SpringApplication.run(MyAppApplication.class, args);
  }
}
```

## Configuring dependency injection of external jar

You can configure a class to automatically accept the injection of a class from an external jar.

For example, this class uses a third party class from a Maven dependency.  Spring Boot will attempt to automatically instantiate this class with an instance of the `ChuckNorrisQuotes`.  When you first write this, your editor may highlight the constructor in red, with the error message:

> Could not autowire. No beans of 'ChuckNorrisQuotes' type found.

```java
// ... imports
@Service
public class JokeServiceImpl implements JokeService {
  private final ChuckNorrisQuotes chuckNorrisQuotes;

  public JokeServiceImpl(ChuckNorrisQuotes chuckNorrisQuotes) {
    this.chuckNorrisQuotes = chuckNorrisQuotes;
  }

  @Override
  public String getJoke() {
    return chuckNorrisQuotes.getRandomQuote();
  }
}
```

You can use a config file to solve this.  `/src/main/java/io/onehouse/joke/config/ChuckConfiguration.java`

```java
// ... imports
@Configuration
public class ChuckConfiguration {
  @Bean
  public ChuckNorrisQuotes chuckNorrisQuotes() {
    return new ChuckNorrisQuotes();
  }
}
```

## Loading config from a config file

In your `resources` directory, add a property file (name doesn't matter, but the convension is to use the `.properties` extension):

`resources/datasource.properties`

```java
db.user=joebob23
db.pass=supersecret
db.host=127.0.0.1
```

Then in your top package add a `config` directory with the following file:

`<root-package>/config/PropertyConfig.java`

```java
@Configuration
@PropertySource("classpath:db.properties")
public class PropertyConfig {
  @Value("${db.user}")
  String user;

  @Value("${db.pass}")
  String pass;

  @Value("${db.host}")
  String host;

  @Bean
  public FakeDataSource fakeDataSource() {
    FakeDataSource fakeDataSource = new FakeDataSource();
    fakeDataSource.setUser(user);
    fakeDataSource.setPass(pass);
    fakeDataSource.setHost(host);
    return fakeDataSource;
  }

  @Bean
  public static PropertySourcesPlaceholderConfigurer properties() {
    PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer =
      new PropertySourcesPlaceholderConfigurer();
    return propertySourcesPlaceholderConfigurer;
  }
}
```

Then in your main app:

```java
FakeDataSource fakeDataSource = (FakeDataSource) ctx.getBean(FakeDataSource.class);
```

## Basic MVC

Imagine we want to list out some fruit names as a basic example.

Create a Spring Boot starter with `web` and `thymeleaf` templates.

### Model

Create a `model` package in your base package and add a `Fruit.java` pojo:

`<base-package>/model/Fruit.java`

```java
class Fruit {
  private String name;

  Fruit(String name) {
    this.name = name;
  }

  public String getName() {
    return name;
  }

  public setName(String name) {
    this.name = name;
  }
}
```

### View

In the `/resources/templates` directory create a `fruits` directory and add an `index.html` file:

`/resources/templates/fruits/index.html`

```html
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
  <head>
    <meta charset="UTF-8">
    <title>Fruits</title>
  </head>
  <body>
    <table>
      <thead>
        <tr>
          <th>Fruit</th>
        </tr>
      </thead>
      <tbody>
        <tr th:each="fruit : ${fruits}">
          <td th:text="${fruit.name}">Banana</td>
        </tr>
      </tbody>
    </table>
  </body>
</html>
```

### Controller

Create a `controllers` package in your base package and add a controller file:

`<base-package>/controllers/FruitsController.java`

```java
// ... imports here
@Controller
class FruitsController {
  @RequestMapping({ "/fruits", "/fruits/index" })
  public String getFruits(Model model) {
    // create some fruit objects
    List fruits = new ArrayList();
    Fruit apple = new Fruit("apple");
    fruits.add(apple);
    Fruit pear = new Fruit("pear");
    fruits.add(pear);
    Fruit orange = new Fruit("orange");
    fruits.add(orange);

    // add fruits to the model
    model.addAttribute("fruits", fruits);

    // render the view
    return "fruits/index.html";
  }
}
```
