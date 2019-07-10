package main
 
import (
	"fmt"
	"os"
	"log"
    "net/http"
 
    "github.com/gorilla/mux"
)
 
func main() {
 
    router := mux.NewRouter().StrictSlash(true)
    router.HandleFunc("/", Index)
    router.HandleFunc("/ready", Healthcheck)
    router.HandleFunc("/healthcheck", Healthcheck)
 
    log.Fatal(http.ListenAndServe(":80", router))
}
 
func Index(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "Works!")
}
 
func Healthcheck(w http.ResponseWriter, r *http.Request) { 
	healthy := os.Getenv("APP_HEALTHY")

	if healthy == "false" {
		w.WriteHeader(http.StatusInternalServerError)
	} else {
		w.WriteHeader(http.StatusOK)
	}
}

func Ready(w http.ResponseWriter, r *http.Request) { 
	w.WriteHeader(http.StatusOK)
}
