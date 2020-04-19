package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

func main() {
	// curl -SsLD- -X POST -H 'Content-Type: text/plain' -d $'hello\n' 'http://localhost:8080/hello?a=1&a=2'
	// curl -SsLD- -X POST -F b=3 'http://localhost:8080/hello?a=1&a=2'

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		writer := io.MultiWriter(os.Stdout, w)
		fmt.Print("\033[2J\033[H")

		fmt.Fprintln(writer, "url:\n````")
		fmt.Fprintf(writer, "\t%+v\n", r.URL)

		fmt.Fprintln(writer, "```\n\nheaders:\n```")
		for k, v := range r.Header {
			fmt.Fprintln(writer, "\t", k, v)
		}
		fmt.Fprintln(writer, "```\n\nquerystring:\n````")
		for k, v := range r.URL.Query() {
			fmt.Fprintln(writer, "\t", k, v)
		}
		fmt.Fprintln(writer, "```\n\nform:\n````")
		// r.ParseForm()
		r.ParseMultipartForm(32 << 20)
		for k, v := range r.PostForm {
			fmt.Fprintln(writer, "\t", k, v)
		}
		fmt.Fprintln(writer, "```\n\nbody:\n```")
		io.Copy(writer, r.Body)
		fmt.Fprintln(writer, "```")
	})
	log.Println(http.ListenAndServe(":8080", nil))
}
