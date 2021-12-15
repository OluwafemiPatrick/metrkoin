
class AccountMenuButtons {

  final String accountMenuButtonItems;
  const AccountMenuButtons(this.accountMenuButtonItems);
}

const List<AccountMenuButtons> accountMenuButtonItems = const <AccountMenuButtons>[
  const AccountMenuButtons('All'),
  const AccountMenuButtons('Completed games'),
  const AccountMenuButtons('Referrals'),
  const AccountMenuButtons('Daily rewards'),
  const AccountMenuButtons('Withdrawals'),

];