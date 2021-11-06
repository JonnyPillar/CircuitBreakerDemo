package main

import (
	"context"
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/sirupsen/logrus"
)

func main() {
	lambda.Start(Handle)
}

func Handle(ctx context.Context, sqsEvent events.SQSEvent) error {
	log := logrus.New()

	resp, err := http.Get("http://localhost:8090/api/poll")
	if err != nil {
		log.Error("error making request", err)

		return err
	}

	if resp.StatusCode != http.StatusOK {
		log.WithField("api-event", "api-error").
			Error("api returned error: ", resp.StatusCode)

		return fmt.Errorf("api error, %d", resp.StatusCode)
	}

	log.WithField("api-event", "success").
		Infof("Successful API request %d", resp.StatusCode)

	// Do something with the returned request

	return nil
}
