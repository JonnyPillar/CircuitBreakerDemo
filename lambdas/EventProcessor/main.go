package main

import (
	"context"
	"net/http"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/sirupsen/logrus"
)

func main() {
	lambda.Start(Handle)
}

func Handle(ctx context.Context, sqsEvent events.SQSEvent) error {
	log := logrus.New()
	log.SetFormatter(&logrus.JSONFormatter{})

	url := os.Getenv("API_URL")

	resp, err := http.Get(url)
	if err != nil {
		log.Error("error making request", err)

		return err
	}

	if resp.StatusCode != http.StatusTooManyRequests {
		log.WithField("api-event", "api-error").
			Error("api returned error: ", resp.StatusCode)

		return nil
	}

	log.WithField("api-event", "success").
		Infof("Successful API request %d", resp.StatusCode)

	return nil
}
