# Kotlin IO Notes

## Reading a file

```kotlin
import java.io.File.separator as SEPARATOR
import java.io.File

fun main(args: Array<String>) {
    val filePath = "src${SEPARATOR}foo.txt"
    val file = File(filePath)
    val fileText = file.readText()
    println(fileText)
}
```
