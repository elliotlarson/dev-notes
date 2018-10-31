# Java Notes

## Finding the JDK directory

This command will tell you where the JDK directory is stored:

```bash
$ /usr/libexec/java_home
# => /Library/Java/JavaVirtualMachines/jdk-11.jdk/Contents/Home
```

<<<<<<< HEAD
## `final`

You use the `final` keyword to denote a constant:

```java
final double FOO = 2.5;
```

## To make a class constant

```java
class Hello {
  public static final double FOO = 2.5;
}
```

... which is accessible as:

```java
Hello.FOO
```

## Reading input and printing output

Here you need to use the Java util, `Scanner`:

```java
import java.util.*;

public class PrintName {
    public static void main(String[] args) {
        Scanner in = new Scanner(System.in);
        System.out.print("What's your name? ");
        String name = in.nextLine();
        System.out.println("Hello, " + name + "!");
    }
}
```

## Method parameters

Java always uses call by value, meaning methods always get a copy of all parameter values.  The method can not modify the contents of a variable passed to it.

## Get a random item

You can get a random index of an array with the Java util, `Random`:

```java
String[] fortunes = {
    "Today is your lucky day!",
    "Gosh darn it, people like you!",
    "They're laughing with you, they're laughing with you, ..."
};
int rnd = new Random().nextInt(fortunes.length);
return fortunes[rnd];
=======
## Bitwise XOR `^`

Java has a conditional operator that is "one or the other".  If only one side of the comparison is true, then it is true:

```java
(true ^ true) // => false
(false ^ true) // => true
(true ^ false) // => true
(false ^ false) // => false
>>>>>>> Java notes
```
