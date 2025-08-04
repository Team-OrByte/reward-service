import ballerina/http;
import ballerina/uuid;
import ballerinax/mongodb;
import ballerina/os;
//import ballerina/math;

configurable string mongoCollection = os:getEnv("MONGO_COLLECTION");
configurable string host = "localhost";
configurable int port = 27017;
configurable string username = os:getEnv("MONGO_USER");
configurable string password = os:getEnv("MONGO_PASSWORD");
configurable string database = os:getEnv("MONGO_DB");


final mongodb:Client mongoDb = check new ({
    connection: {
        serverAddress: {
            host,
            port
        },
        auth: <mongodb:ScramSha256AuthCredential>{
            username,
            password,
            database
        }
    }
});

service on new http:Listener(9092) {
    private final mongodb:Database db;

    function init() returns error? {
        self.db = check mongoDb->getDatabase("reward_db");
    }

    resource function post rewardTypes(RewardTypeInput input) returns RewardType|error {
        mongodb:Collection rewardCollection = check self.db->getCollection("reward_types");
        string id = uuid:createType1AsString();
        RewardType reward = {
            id,
            ...input
        };
        check rewardCollection->insertOne(reward);
        return reward;
    }

    resource function get rewardTypes() returns RewardType[]|error {
        mongodb:Collection rewardCollection = check self.db->getCollection("reward_types");
        stream<RewardType, error?> resultStream = check rewardCollection->find();
        return from RewardType reward in resultStream select reward;
    }

    resource function get rewardTypes/[string id]() returns RewardType|error {
        mongodb:Collection rewardCollection = check self.db->getCollection("reward_types");
        map<json> filter = { "id": id };
        stream<RewardType, error?> resultStream = check rewardCollection->find(filter);
        record {RewardType value;}|error? result = resultStream.next();
        if result is error? {
            return error(string `Cannot find the reward type with id: ${id}`);
        }
        return result.value;
    }

    resource function put rewardTypes/[string id](RewardTypeUpdate update) returns RewardType|error {
        mongodb:Collection rewardCollection = check self.db->getCollection("reward_types");
        mongodb:UpdateResult updateResult = check rewardCollection->updateOne({id}, {set: update});
        if updateResult.modifiedCount != 1 {
            return error(string `Failed to update the reward with id ${id}`);
        }
        return getRewardTypes(self.db, id);
    }

    resource function delete rewardTypes/[string id]() returns string|error {
        mongodb:Collection reward_types = check self.db->getCollection("reward_types");
        mongodb:DeleteResult deleteResult = check reward_types->deleteOne({id});
        if deleteResult.deletedCount != 1 {
            return error(string `Failed to delete the reward ${id}`);
        }
        return id;
    }

    resource function get getLatestActiveRewardType() returns RewardType|error {
        return getLatestActiveReward(self.db);
    }

    resource function post rewardPoints(GetRewardRequest req) returns RewardResponse|error {
        RewardType|error latestActiveReward = getLatestActiveReward(self.db);

        if(latestActiveReward is error){
            return error(string `Failed to get the latest reward`);
        }

        decimal rewardPoint = calculateRewardPoints(latestActiveReward, req.distance, req.time);

        if(rewardPoint == -1.0d){
            return error(string `Failed to get the calculate reward points`);
        }

        RewardResponse res = {
            rewardType: latestActiveReward,
            rewardPoints: rewardPoint,
            timestamp: latestActiveReward.timestamp,
            message: "Rewarded successfully"
        };

        return res;
    }
}

isolated function getLatestActiveReward(mongodb:Database db) returns RewardType|error {
    mongodb:Collection rewardCollection = check db->getCollection("reward_types");

    stream<RewardType, error?> results = check rewardCollection->find(
        { isActive: true }, { sort: { timestamp: -1 } });

    record { RewardType value; }|error? result = results.next();
    if result is null || result is error? {
        return error("No active reward found");
    }
    return result.value;
}


isolated function getRewardTypes(mongodb:Database db, string id) returns RewardType|error {
    mongodb:Collection reward_types = check db->getCollection("reward_types");
    stream<RewardType, error?> findResult = check reward_types->find({id});
    RewardType[] result = check from RewardType m in findResult
        select m;
    if result.length() != 1 {
        return error(string `Failed to find a reward types with id ${id}`);
    }
    return result[0];
}

isolated function calculateRewardPoints(RewardType rewardType, decimal distance, decimal time) returns decimal {
    if(!rewardType.isActive){
        return -1.0;
    }
    if(rewardType.formularType == "LINEAR") {
        return rewardType.rewardPoints + (rewardType.formulaCoefficient * distance);
    } else if(rewardType.formularType == "PARABOLIC") {
        return rewardType.rewardPoints + (rewardType.formulaCoefficient * distance * distance);
    } else if(rewardType.formularType == "HYPERBOLIC") {
        return rewardType.rewardPoints + (rewardType.formulaCoefficient / distance);
    } else if(rewardType.formularType == "EXPONENTIAL") {
        return rewardType.rewardPoints + (rewardType.formulaCoefficient * (distance*2.7828));
    }
    return -1.0;
}