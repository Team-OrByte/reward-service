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
    string userId;
    string vehicleId?;
    string message?;
|};

//No need RewardResponse , I user anydata instead of this.
public type RewardResponse record {|
    string userId;
    RewardType rewardType;
    decimal rewardPoints;
    int timestamp;
    string message?;
|};

public type RewardedReport record {|
    RewardType rewardType;
    decimal rewardPoints;
    int timestamp;
    string message?;
|};

type SpendRewardPointsRequest record {|
    string userId;
    decimal points;
|};

public type spendedRewardResponse record {|
    string userId;
    decimal requestedRewardPoints;
    decimal rewardPointsBalance;
    int timestamp;
    string message?;
|};

public type spendedRewardType record {|
    decimal requestedRewardPoints;
    decimal rewardPointsBalance;
    int timestamp;
    string message?;
|};

public type UserRewardType record {|
    string userId;
    RewardedReport[] rewards;
    spendedRewardType[] usedRewardPoints;
    decimal TotalrewardPoints;
    int timestamp;
    string message?;
|};
