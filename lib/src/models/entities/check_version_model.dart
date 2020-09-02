import 'dart:convert';

CheckVersionModel checkVersionModelFromJson(String str) => CheckVersionModel.fromJson(json.decode(str));

String checkVersionModelToJson(CheckVersionModel data) => json.encode(data.toJson());

class CheckVersionModel {
    Customer transporter;
    Customer customer;

    CheckVersionModel({
        this.transporter,
        this.customer,
    });

    factory CheckVersionModel.fromJson(Map<String, dynamic> json) => CheckVersionModel(
        transporter: json["transporter"] == null ? null : Customer.fromJson(json["transporter"]),
        customer: json["customer"] == null ? null : Customer.fromJson(json["customer"]),
    );

    Map<String, dynamic> toJson() => {
        "transporter": transporter == null ? null : transporter.toJson(),
        "customer": customer == null ? null : customer.toJson(),
    };
}

class Customer {
    Android ios;
    Android android;

    Customer({
        this.ios,
        this.android,
    });

    factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        ios: json["ios"] == null ? null : Android.fromJson(json["ios"]),
        android: json["android"] == null ? null : Android.fromJson(json["android"]),
    );

    Map<String, dynamic> toJson() => {
        "ios": ios == null ? null : ios.toJson(),
        "android": android == null ? null : android.toJson(),
    };
}

class Android {
    int version;
    int major;
    int minor;
    int revisionNumber;

    Android({
        this.version,
        this.major,
        this.minor,
        this.revisionNumber,
    });

    factory Android.fromJson(Map<String, dynamic> json) => Android(
        version: json["version"] == null ? null : json["version"],
        major: json["major"] == null ? null : json["major"],
        minor: json["minor"] == null ? null : json["minor"],
        revisionNumber: json["revisionNumber"] == null ? null : json["revisionNumber"],
    );

    Map<String, dynamic> toJson() => {
        "version": version == null ? null : version,
        "major": major == null ? null : major,
        "minor": minor == null ? null : minor,
        "revisionNumber": revisionNumber == null ? null : revisionNumber,
    };
}
