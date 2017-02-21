# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

# Python 3 compatibility should come with version 0.10.0 (judging from issue
# tracker), for now depend on lower version vdirsyncer whose ebuild still
# supports python 2.7
PYTHON_COMPAT=( python3_4 )

inherit distutils-r1

DESCRIPTION="A console CardDAV client"
HOMEPAGE="https://github.com/scheibler/khard/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="zsh-completion"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/vdirsyncer[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	=dev-python/vobject-0.9.2[${PYTHON_USEDEP}]
	zsh-completion? ( app-shells/zsh )"

DOCS=( AUTHORS README.md misc/khard/khard.conf.example )

src_install() {
	distutils-r1_src_install
	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins misc/_khard
	fi
}