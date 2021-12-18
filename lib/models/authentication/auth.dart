class RefereeDataModel {
  final String refByChain;
  final String refByCode;
  final String refById;
  final String refByMTRKBalance;
  final String refByMTRKEarning;
  final String refByRefCount;
  final String refByRefEarning;

  RefereeDataModel(
      this.refByChain,
      this.refByCode,
      this.refById,
      this.refByMTRKBalance,
      this.refByMTRKEarning,
      this.refByRefCount,
      this.refByRefEarning);

  RefereeDataModel.fromJson(Map<String, dynamic> json)
      : refByChain = json['ref_by_chain'],
        refByCode = json['ref_by_code'],
        refById = json['ref_by_id'],
        refByMTRKBalance = json['ref_by_mtrk_bal'],
        refByMTRKEarning = json['ref_by_mtrk_earning'],
        refByRefCount = json['ref_by_ref_count'],
        refByRefEarning = json['ref_by_ref_earning'];

}