[
    {
      "name": "${name}",
      "image": "${image}",
      "portMappings": [
        {
          "containerPort": 80
        }
      ],
      "networkMode": "awsvpc",
      "environment": [
        {
          "name": "VARIABLE_EXAMPLE",
          "value": "foobar"
        }
      ],
      "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/aws/ecs/${name}",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "ecs"}
      }
    }
]
