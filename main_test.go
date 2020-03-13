package main

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/julienschmidt/httprouter"
)

func TestGetVersion(t *testing.T) {
	router := httprouter.New()
	router.GET("/version", Version)

	req, _ := http.NewRequest("GET", "/version", nil)
	rr := httptest.NewRecorder()

	router.ServeHTTP(rr, req)
	if status := rr.Code; status != http.StatusOK {
		t.Errorf("Received unexpected status %v", status)
	}

	expected := `{"myapplication":{"version":"dev","lastcommitsha":"1234abc","description":"pre-interview technical test"}}`
	if strings.TrimRight(rr.Body.String(), "\n") != expected {
		t.Errorf("Received unexpected body: \n\treceived %v \n\texpected %s",
			rr.Body.String(), expected)
	}
}
