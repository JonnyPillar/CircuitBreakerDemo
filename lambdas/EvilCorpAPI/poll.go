package main

import (
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

func pollHandler(c *gin.Context) {
	log := logrus.New()
	log.SetFormatter(&logrus.JSONFormatter{})

	toggle := os.Getenv("TOGGLE") == "true"

	log.WithField("api-event", "api-request").Info("Received request")

	switch toggle {
	case true:
		c.JSON(200, gin.H{
			"success": true,
			"message": "Continue being evil",
		})
	default:
		c.JSON(http.StatusTooManyRequests, gin.H{
			"success": false,
			"message": "Too many people being evil",
		})
	}
}
