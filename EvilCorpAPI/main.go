package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	fmt.Println("Starting Evil Core API")

	http.HandleFunc("/api/poll", pollHandler)
	http.HandleFunc("/api/toggle", toggleHandler)

	err := http.ListenAndServe(":8090", nil)
	if err != nil {
		log.Fatal(err)
	}
}
