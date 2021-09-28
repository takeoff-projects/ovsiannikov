package petsdb

import (
	
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"cloud.google.com/go/datastore"
	"github.com/google/uuid"
)

var projectID string

// Pet model stored in Datastore
type Pet struct {
	Added   time.Time `datastore:"added"`
	Caption string    `datastore:"caption"`
	Email   string    `datastore:"email"`
	Image   string    `datastore:"image"`
	Likes   int       `datastore:"likes"`
	Owner   string    `datastore:"owner"`
	Petname string    `datastore:"petname"`
	Name    string     // The ID used in the datastore.
}

// GetPets Returns all pets from datastore ordered by likes in Desc Order
func GetPets() ([]Pet, error) {

	projectID = os.Getenv("GOOGLE_CLOUD_PROJECT")
	if projectID == "" {
		log.Fatal(`You need to set the environment variable "GOOGLE_CLOUD_PROJECT"`)
	}

	var pets []Pet
	ctx := context.Background()
	client, err := datastore.NewClient(ctx, projectID)
	if err != nil {
		log.Fatalf("Could not create datastore client: %v", err)
	}

	// Create a query to fetch all Pet entities".
	query := datastore.NewQuery("Pet")
	keys, err := client.GetAll(ctx, query, &pets)
	if err != nil {
		fmt.Println(err)
		return nil, err
	}

	// Set the id field on each Task from the corresponding key.
	for i, key := range keys {
		pets[i].Name = key.Name
	}

	client.Close()
	return pets, nil
}

func PutPet(Owner string, petName string){
    id := uuid.New()
    newPet := Pet{
       Petname: petName,
       Owner: Owner,
    }
    projectID = os.Getenv("GOOGLE_CLOUD_PROJECT")
    if projectID == "" {
        log.Fatal(`You need to set the environment variable "GOOGLE_CLOUD_PROJECT"`)
    }

    ctx := context.Background()
    client, err := datastore.NewClient(ctx, projectID)
    if err != nil {
        log.Fatalf("Could not create datastore client: %v", err)
    }

    k := datastore.NameKey("Pet", "Pet" + id.String(), nil)
    _, err = client.Put(ctx, k, &newPet)
    if err != nil {
        fmt.Println(err)
    }

    log.Println("new Pet:", newPet)
    client.Close()
}
