package main

import (
	"encoding/json"
	"log"
	"net/http"
	"time"

	"github.com/julienschmidt/httprouter"
)

// These are defaults used for tests and change at build time.
var (
	GitChecksum = "1234abc"
	GitVersion  = "dev"
)

// ResponseWrapper provides a top level key for serialised JSON responses.
type ResponseWrapper struct {
	App AppInfo `json:"myapplication"`
}

// AppInfo provides the current build and version details for the app.
// Members are out of alphabetical order as instructed by specification document.
type AppInfo struct {
	Version     string `json:"version"`
	Checksum    string `json:"lastcommitsha"`
	Description string `json:"description"`
}

// Version provides an HTTP handler for the /version endpoint.
func Version(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	myapp := AppInfo{
		Checksum: GitChecksum,
		Description: "pre-interview technical test",
		Version: GitVersion,
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	json.NewEncoder(w).Encode(ResponseWrapper{App: myapp})
}

func main() {
	router := httprouter.New()
	router.GET("/version", Version)

	srv := &http.Server{
		Handler:      router,
		Addr:         "0.0.0.0:8000",
		WriteTimeout: 15 * time.Second,
		ReadTimeout:  15 * time.Second,
	}

	log.Print("Starting server on port 8000...")
	err := srv.ListenAndServe()
	if err != nil && err != http.ErrServerClosed {
		log.Fatal(err)
	}
}
