# Reward Service

[![CI](https://github.com/Team-OrByte/reward-service/actions/workflows/automation.yaml/badge.svg)](https://github.com/Team-OrByte/reward-service/actions/workflows/automation.yaml)
[![Docker Image](https://img.shields.io/badge/docker-thetharz%2Forbyte__review__service-blue)](https://hub.docker.com/r/thetharz/orbyte_reward_service)

A microservice built with Ballerina to manage reward points for users based on their ride activities. The service provides functionality to create, manage, and distribute reward points using various mathematical formulas.

The service is automatically built and deployed using GitHub Actions with Docker image publishing to Docker Hub.

## How Ballerina is Used

This project leverages Ballerina's capabilities in several key areas:

- **HTTP Service Development**: Utilizes Ballerina's HTTP module to create RESTful endpoints with built-in CORS support
- **MongoDB Integration**: Uses the Ballerina MongoDB connector for database operations and data persistence
- **JWT Authentication**: Implements JWT-based authentication with scope-based authorization using Ballerina's auth features
- **Type Safety**: Leverages Ballerina's strong type system with custom record types for API contracts
- **Error Handling**: Uses Ballerina's error handling mechanisms for robust service operation
- **Configuration Management**: Employs configurable variables for environment-specific settings

## Configuration Example

Create a `Config.toml` file with the following configuration:

```toml
# MongoDB Configuration
host = "localhost"
# or for Docker: host = "reward_service_mongodb"
port = 27017
database = "reward-db"
username = "your-db-username"
password = "your-db-password"

# Collections
MONGO_REWARD_COLLECTION = "reward_types"
MONGO_USER_REWARD_COLLECTION = "user_reward"

# JWT Authentication
pub_key = "./path/to/public.crt"
```

## API Endpoints

### Health Check

**GET** `/`

- **Description**: Service health check
- **Response**:

```json
"server is up and running!"
```

### Reward Types Management

**POST** `/rewardTypes`

- **Description**: Create a new reward type (Admin only)
- **Authentication**: Required (JWT with admin scope)
- **Request Body**:

```json
{
  "threshold": 0.0,
  "timeMultiplier": 1.0,
  "distanceMultiplier": 1.5,
  "formulaCoefficient": 2.0,
  "formularType": "LINEAR",
  "rewardPoints": 10.0,
  "timestamp": 1693459200,
  "isActive": true
}
```

- **Response**:

```json
{
  "id": "generated-uuid",
  "threshold": 0.0,
  "timeMultiplier": 1.0,
  "distanceMultiplier": 1.5,
  "formulaCoefficient": 2.0,
  "formularType": "LINEAR",
  "rewardPoints": 10.0,
  "timestamp": 1693459200,
  "isActive": true
}
```

**GET** `/rewardTypes`

- **Description**: Get all reward types (Admin only)
- **Authentication**: Required (JWT with admin scope)
- **Response**: Array of reward types

**GET** `/rewardTypes/{id}`

- **Description**: Get a specific reward type by ID (Admin only)
- **Authentication**: Required (JWT with admin scope)
- **Response**: Single reward type object

**PUT** `/rewardTypes/{id}`

- **Description**: Update a reward type (Admin only)
- **Authentication**: Required (JWT with admin scope)
- **Request Body**: Partial reward type object with fields to update
- **Response**: Updated reward type object

**DELETE** `/rewardTypes/{id}`

- **Description**: Delete a reward type (Admin only)
- **Authentication**: Required (JWT with admin scope)
- **Response**: Deleted reward type ID

### Reward Points Operations

**GET** `/getLatestActiveRewardType`

- **Description**: Get the latest active reward type
- **Response**: Active reward type object

**POST** `/rewardPoints`

- **Description**: Calculate and award reward points for a ride
- **Request Body**:

```json
{
  "rideId": "ride-123",
  "timestamp": 1693459200,
  "distance": 5.2,
  "time": 1800,
  "startFrom": "Location A",
  "stopAt": "Location B",
  "userId": "user-456",
  "vehicleId": "vehicle-789",
  "message": "Completed ride"
}
```

- **Response**:

```json
{
  "user": {
    "userId": "user-456",
    "rewardType": {
      /* reward type object */
    },
    "rewardPoints": 25.5,
    "timestamp": 1693459200,
    "message": "Rewarded successfully"
  },
  "rewardPointUpdate": {
    /* update result */
  }
}
```

**POST** `/spendRewardPoints`

- **Description**: Spend/deduct reward points from a user
- **Request Body**:

```json
{
  "userId": "user-456",
  "points": 10.0
}
```

- **Response**: Update result with remaining balance

## Reward Formula Types

The service supports four mathematical formulas for calculating reward points:

1. **LINEAR**: `rewardPoints + (formulaCoefficient * distance)`
2. **PARABOLIC**: `rewardPoints + (formulaCoefficient * distance²)`
3. **HYPERBOLIC**: `rewardPoints + (formulaCoefficient / distance)`
4. **EXPONENTIAL**: `rewardPoints + (formulaCoefficient * distance * e)`

## Database Collections

- **reward_types**: Stores different reward type configurations
- **user_reward**: Stores user reward points, transaction history, and spending records

## License

This project does not currently specify a license.
