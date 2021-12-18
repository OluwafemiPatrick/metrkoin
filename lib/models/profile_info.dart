class ProfileInfo {

  final String userId;
  final String actCreationDate;
  final String email;
  final String gameSudokuEarning;
  final String game2048Earning;
  final String gameNumSliderEarning;
  final String lastLogin;
  final String mtrkBalance;
  final String mtrkWithdrawn;
  final String mtrkTotalEarning;
  final String profilePicUrl;
  final String referralCode;
  final String referralChain;
  final String referredById;
  final String referredByCode;
  final String referralEarning;
  final String referralSubLevelEarning;
  final String totalRefCount;
  final String totalSubRefCount;
  final String username;

  ProfileInfo(
      this.userId,
      this.actCreationDate,
      this.email,
      this.gameSudokuEarning,
      this.game2048Earning,
      this.gameNumSliderEarning,
      this.lastLogin,
      this.mtrkBalance,
      this.mtrkWithdrawn,
      this.mtrkTotalEarning,
      this.profilePicUrl,
      this.referralCode,
      this.referralChain,
      this.referredById,
      this.referredByCode,
      this.referralEarning,
      this.referralSubLevelEarning,
      this.totalRefCount,
      this.totalSubRefCount,
      this.username);

  ProfileInfo.fromJson(Map<String, dynamic> json)
        : userId = json['_id'],
          actCreationDate = json['act_creation_date'],
          email = json['email'],
          gameSudokuEarning = json['game_sudoku_earning'],
          game2048Earning = json['game_2048_earning'],
          gameNumSliderEarning = json['game_num_slider_earning'],
          lastLogin = json['last_login'],
          mtrkBalance = json['mtrk_balance'],
          mtrkWithdrawn = json['mtrk_withdrawn'],
          mtrkTotalEarning = json['mtrk_total_earning'],
          profilePicUrl = json['profile_pic_url'],
          referralCode = json['referral_code'],
          referralChain = json['referral_chain'],
          referredByCode = json['referred_by_code'],
          referredById = json['referred_by_id'],
          referralEarning = json['referral_earning'],
          referralSubLevelEarning = json['referral_sub_level_earning'],
          totalRefCount = json['total_ref_count'],
          totalSubRefCount = json['total_sub_ref_count'],
          username = json['username'];

}