package main

import (
	"encoding/json"
	"fmt"
	"net/http"
)

var (
	toggle bool = false
)

type Response struct {
	Success bool   `json:"success"`
	Message string `json:"message,omitempty"`
}

func pollHandler(w http.ResponseWriter, req *http.Request) {
	var resp Response
	switch toggle {
	case true:
		w.WriteHeader(http.StatusOK)
		resp = Response{
			Success: true,
			Message: "Continue being evil",
		}
	default:
		w.WriteHeader(http.StatusInternalServerError)
		resp = Response{
			Success: false,
			Message: "Something went wrong being evil",
		}
	}

	r, _ := json.Marshal(resp)

	fmt.Fprintf(w, "%s\n", r)
}

func toggleHandler(w http.ResponseWriter, req *http.Request) {
	toggle = !toggle
}
