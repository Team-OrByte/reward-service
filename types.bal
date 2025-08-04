public enum FormularType {
    LINEAR = "LINEAR",
    PARABOLIC = "PARABOLIC",
    HYPERBOLIC = "HYPERBOLIC",
    EXPONENTIAL = "EXPONENTIAL"
}

public type RewardTypeInput record {|
    decimal threshold;
    decimal timeMultiplier;
    decimal distanceMultiplier;
    decimal formulaCoefficient;
    FormularType formularType;
    decimal rewardPoints;
    int timestamp;
    boolean isActive;
|};

public type RewardTypeUpdate record {|
    decimal threshold?;
    decimal timeMultiplier?;
    decimal distanceMultiplier?;
    decimal formulaCoefficient?;
    FormularType formularType?;
    decimal rewardPoints?;
    int timestamp?;
    boolean isActive?;
|};

public type RewardType record {|
    readonly string id;
    *RewardTypeInput;
|};

public type ErrorResponse record {|
    string message;
    string code?;
    int timestamp;
|};

public type DeleteResponse record {|
    string message;
    string id?;
    int timestamp;
|};

public type GetRewardRequest record {|
    string rideId;
    int timestamp;
    decimal distance;
    decimal time;
    string startFrom;
    string stopAt;
    string userId?;
    string vehicleId?;
    string message?;
|};

public type RewardResponse record {|
    RewardType rewardType;
    decimal rewardPoints;
    int timestamp;
    string message?;
|};
