# 🎁 Reward Service (Ballerina + MongoDB)

This is the reward service that integrates with MongoDB to manage reward types, calculate points, and manage user reward balances.

---

## 🔧 Requirements

- [Ballerina](https://ballerina.io/downloads/) (v2201.9.0 or compatible)
- MongoDB (running locally or remotely)
- Docker (optional, for containerization)

---

## 📦 Setup

### 1. Clone the Repository

```bash
git clone https://github.com/Team-OrByte/reward-service.git
cd reward-service
```

### 2. Set Environment Variables

Create a `.env` file or export manually:

```bash
export MONGO_URL=mongodb://localhost:27017
export MONGO_DB=reward-service-db
export MONGO_REWARD_COLLECTION=rewardRecords
export MONGO_USER_REWARD_COLLECTION=rewardRecords
export MONGO_USER=<your-mongo-username>
export MONGO_PASSWORD=<your-mongo-password>
```


## 🚀 Run the Service

```bash
bal run
```

> The service will start on port **9092**.

---

## 🧪 Available API Endpoints

All APIs are available under: `http://localhost:9092/`

### 🎯 Reward Types

| Method | Endpoint                         | Description                    |
|--------|----------------------------------|--------------------------------|
| GET    | `/rewardTypes`                   | Get all reward types           |
| GET    | `/rewardTypes/{id}`              | Get reward type by ID          |
| POST   | `/rewardTypes`                   | Create a new reward type       |
| PUT    | `/rewardTypes/{id}`              | Update an existing reward type |
| DELETE | `/rewardTypes/{id}`              | Delete reward type by ID       |

### ⭐ Reward Points

| Method | Endpoint                      | Description                          |
|--------|-------------------------------|--------------------------------------|
| POST   | `/rewardPoints`               | Calculate & assign reward to user    |
| GET    | `/getLatestActiveRewardType`  | Get the latest active reward type    |

### 💸 Spend Reward Points

| Method | Endpoint              | Description                 |
|--------|-----------------------|-----------------------------|
| POST   | `/spendRewardPoints`  | Spend user reward points    |

---

## 📘 Sample Payloads

### ➕ Add Reward Type

```json
POST /rewardTypes
{
  "threshold": 10,
  "timeMultiplier": 1,
  "distanceMultiplier": 2,
  "formulaCoefficient": 1.5,
  "formularType": "LINEAR",
  "rewardPoints": 50,
  "timestamp": 1690000000,
  "isActive": true
}
```

### 🧮 Calculate Reward Points

```json
POST /rewardPoints
{
  "rideId": "ride123",
  "timestamp": 1690000010,
  "distance": 10,
  "time": 5,
  "startFrom": "Colombo",
  "stopAt": "Kandy",
  "userId": "user123"
}
```

### 💰 Spend Reward Points

```json
POST /spendRewardPoints
{
  "userId": "user123",
  "points": 20
}
```