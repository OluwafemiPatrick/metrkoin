
const PAGE_TRANSITION_DURATION = 250;

const MY_BNB_ADDRESS = 'kjdih89r4034j94';

const SUPPORT_EMAIL_ADDRESS = 'support@metrkoin.com';

const VERSION_NUMBER = "1.1.0";

const WEBSITE_URL = 'https://metrkoin.com';


int _mtrkBalance = 0;

int get mtrkGlobalBalance {
  return _mtrkBalance;
}

set mtrkGlobalBalance(int value) {
  _mtrkBalance = value;
}