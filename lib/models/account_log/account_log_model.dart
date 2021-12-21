class AccountLogModel {
  final String description;
  final int amount;
  final String timestamp;
  final String status;
  final String type;
  final String docId;

  AccountLogModel(
      this.description,
      this.amount,
      this.timestamp,
      this.status,
      this.type,
      this.docId,
      );


  AccountLogModel.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        amount = json['amount'],
        timestamp = json['timestamp'],
        status = json['status'],
        type = json['type'],
        docId = json['_id'];

}