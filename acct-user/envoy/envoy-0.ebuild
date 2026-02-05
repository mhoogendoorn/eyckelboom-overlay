EAPI=8

KEYWORDS="~amd64 ~arm64"

inherit acct-user

ACCT_USER_ID=-1
ACCT_USER_GROUPS=( "envoy" )

acct-user_add_deps
