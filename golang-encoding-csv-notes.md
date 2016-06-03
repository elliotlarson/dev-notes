# Golang Encoding Notes

## Working with CSV

#### Writing a CSV file

In order to write to a CSV file, you need to create the file and then create a `Writer`.

```go
type Bread struct {
	Name     string
	Location string
}

var breads = []*Bread{
	{Name: "mantou", Location: "China"},
	{Name: "baguette", Location: "France"},
	{Name: "cottage loaf", Location: "England"},
	{Name: "pan", Location: "Spain"},
	{Name: "tortilla", Location: "Mexico"},
	{Name: "injera", Location: "Africa"},
	{Name: "corn bread", Location: "America"},
}

func main() {
	csvFile, err := os.Create("breads.csv")
	if err != nil {
		panic(err)
	}
	defer csvFile.Close()

	writer := csv.NewWriter(csvFile)

	header := []string{"bread", "location"}
	if err = writer.Write(header); err != nil {
		panic(err)
	}

	for _, bread := range breads {
		line := []string{bread.Name, bread.Location}
		if err := writer.Write(line); err != nil {
			panic(err)
		}
	}

	writer.Flush()
}
```

Notice that you have to `Flush` the writer to write to the file.  When you call `Write` on the writer, it adds the content to an internal buffer, which is added to the file when you call `Flush`.

The Go source code for the `Writer` struct and the `NewWriter` method look like:

```go
// A Writer writes records to a CSV encoded file.
//
// As returned by NewWriter, a Writer writes records terminated by a
// newline and uses ',' as the field delimiter.  The exported fields can be
// changed to customize the details before the first call to Write or WriteAll.
//
// Comma is the field delimiter.
//
// If UseCRLF is true, the Writer ends each record with \r\n instead of \n.
type Writer struct {
	Comma   rune // Field delimiter (set to ',' by NewWriter)
	UseCRLF bool // True to use \r\n as the line terminator
	w       *bufio.Writer
}

// NewWriter returns a new Writer that writes to w.
func NewWriter(w io.Writer) *Writer {
	return &Writer{
		Comma: ',',
		w:     bufio.NewWriter(w),
	}
}
```

#### Writing a tab delimited file

To export a tab delimited file, you just need to update the `Comma` value of the `csv.Writer` struct.

```go
writer := csv.NewWriter(csvFile)
writer.Comma = '\t'
```

#### Reading a CSV file

Say we have a `breads.csv` file:

```csv
bread,location
mantou,China
baguette,France
cottage loaf,England
pan,Spain
tortilla,Mexico
injera,Africa
corn bread,America
```

We can load the file and work with the rows (records) of data:

```go
func main() {
	file, err := os.Open("breads.csv")
	if err != nil {
		panic(err)
	}
	defer file.Close()
	reader := csv.NewReader(file)
	records, err := reader.ReadAll()
	if err != nil {
		panic(err)
	}
	for i, record := range records {
		if i == 0 { // skip header line
			continue
		}
		fmt.Printf("Bread: %s, Location: %s\n", record[0], record[1])
	}
}
```

The Go source code for the `Reader` struct and the `NewReader` function, look like this:

```go
// A Reader reads records from a CSV-encoded file.
//
// As returned by NewReader, a Reader expects input conforming to RFC 4180.
// The exported fields can be changed to customize the details before the
// first call to Read or ReadAll.
//
// Comma is the field delimiter.  It defaults to ','.
//
// Comment, if not 0, is the comment character. Lines beginning with the
// Comment character are ignored.
//
// If FieldsPerRecord is positive, Read requires each record to
// have the given number of fields.  If FieldsPerRecord is 0, Read sets it to
// the number of fields in the first record, so that future records must
// have the same field count.  If FieldsPerRecord is negative, no check is
// made and records may have a variable number of fields.
//
// If LazyQuotes is true, a quote may appear in an unquoted field and a
// non-doubled quote may appear in a quoted field.
//
// If TrimLeadingSpace is true, leading white space in a field is ignored.
type Reader struct {
	Comma            rune // field delimiter (set to ',' by NewReader)
	Comment          rune // comment character for start of line
	FieldsPerRecord  int  // number of expected fields per record
	LazyQuotes       bool // allow lazy quotes
	TrailingComma    bool // ignored; here for backwards compatibility
	TrimLeadingSpace bool // trim leading space
	line             int
	column           int
	r                *bufio.Reader
	field            bytes.Buffer
}

// NewReader returns a new Reader that reads from r.
func NewReader(r io.Reader) *Reader {
	return &Reader{
		Comma: ',',
		r:     bufio.NewReader(r),
	}
}
```
