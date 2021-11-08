package main

import (
	"context"
	"fmt"
	"os"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"github.com/aws/aws-sdk-go-v2/service/sqs/types"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/sirupsen/logrus"
)

func main() {
	lambda.Start(Handle)
}

func Handle(ctx context.Context) error {
	log := logrus.New()

	queueURL := os.Getenv("SQS_QUEUE_URL")
	data := "{}"

	for range time.Tick(time.Second * 1) {
		var entries []types.SendMessageBatchRequestEntry

		for i := 0; i < 10; i++ {
			batchEntry := types.SendMessageBatchRequestEntry{
				Id:          aws.String(fmt.Sprintf("%d", i)),
				MessageBody: aws.String(data),
			}

			entries = append(entries, batchEntry)
		}

		cfg, err := config.LoadDefaultConfig(context.Background())
		if err != nil {
			log.Error("Error loading config", err)

			return err
		}

		sMInput := &sqs.SendMessageBatchInput{
			Entries:  entries,
			QueueUrl: aws.String(queueURL),
		}

		api := sqs.NewFromConfig(cfg)

		_, err = api.SendMessageBatch(ctx, sMInput)
		if err != nil {
			log.Error("Error sending events", err)

			return err
		}

		log.Info("Sent events")
	}

	return nil
}
