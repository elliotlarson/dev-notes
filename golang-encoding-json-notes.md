# Golang Encoding JSON Notes

## Parsing JSON

Say you have the following JSON file `party-1.json`:

```json
{
	"party": {
		"id": 1,
		"name": "Democrats",
		"politicians": [
			{
				"id": 1,
				"first_name": "Hillary",
				"last_name": "Clinton"
			},
			{
				"id": 2,
				"first_name": "Bernie",
				"last_name": "Sanders"
			}
		]
	}
}
```

You can parse this into structs with this:

```go
type PartyResource struct {
	Party Party `json:"party"`
}

type Party struct {
	ID          int           `json:"id"`
	Name        string        `json:"name"`
	Politicians []*Politician `json:"politicians"`
}

type Politician struct {
	ID        int    `json:"id"`
	FirstName string `json:"first_name"`
	LastName  string `json:"last_name"`
}

func main() {
	jsonFile, err := os.Open("party-1.json")
	if err != nil {
		log.Fatal(err)
		return
	}
	defer jsonFile.Close()

	jsonData, err := ioutil.ReadAll(jsonFile)
	if err != nil {
		log.Fatal(err)
		return
	}

	var partyResource PartyResource
	json.Unmarshal(jsonData, &partyResource)

	fmt.Printf("party resource: %#v\n", partyResource)
	fmt.Printf("party: %#v\n", partyResource.Party)
	fmt.Printf("Hillary: %#v\n", partyResource.Party.Politicians[0])
	fmt.Printf("Bernie: %#v\n", partyResource.Party.Politicians[1])
}
```

We're opening the file, reading the data from it and then using the `json.Unmarshal` method to parse the data into our system's structs.

If the JSON has entities that are not included in a struct you are trying to unmarshal into, it will just get ignored.  For example, if the `politician` struct doesn't have an `email` field, but the JSON contains one, then the email gets ignored.

## Generating JSON from structs

Go's `json` package allows you to translate data structures from your app into JSON with the `Marshal` function.  Here is an example where we are marshaling the data structure from the JSON in the last example.

```go
func main() {
	hillary := politician{
		ID:        1,
		FirstName: "Hillary",
		LastName:  "Clinton",
	}
	bernie := politician{
		ID:        2,
		FirstName: "Bernie",
		LastName:  "Sanders",
	}
	democrats := party{
		ID:          1,
		Name:        "Democrats",
		Politicians: []politician{hillary, bernie},
	}
	partyResource := partyResource{
		Party: democrats,
	}

	jsonByteSlice, err := json.Marshal(partyResource)
	if err != nil {
		log.Fatal(err)
		return
	}

	fmt.Printf("%s\n", jsonByteSlice)
}
```

`Marshal` returns both an `error` and a `[]byte`, which represents the JSON.  Running this will take the nested structs, and translate them into the JSON in the previous section.

## Serving a JSON response

Notice the use of `WriteHeader` and `Header().Set()`.  With `WriteHeader` you're not really writing a header (confusingly).  You are setting the response code.  With `Header().Set()` you are setting the value for the specified header.

```go
import (
	"fmt"
	"net/http"
)

func rootHandler(w http.ResponseWriter, req *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	jsonString := `{"message": "Hello, World!"}`
	fmt.Fprintf(w, jsonString)
}

func main() {
	http.HandleFunc("/", rootHandler)
	http.ListenAndServe(":8888", nil)
}
```

```bash
$ curl -i http://localhost:8888
# HTTP/1.1 200 OK
# Content-Type: application/json
# Date: Wed, 27 Apr 2016 04:00:13 GMT
# Content-Length: 28
#
# {"message": "Hello, World!"}
```
