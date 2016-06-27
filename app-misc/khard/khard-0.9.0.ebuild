# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

# Python 3 compatibility should come with version 0.10.0 (judging from issue
# tracker)
PYTHON_COMPAT=( python2_7 )

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
	dev-misc/vdirsyncer[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
    dev-python/vobject[${PYTHON_USEDEP}]"

DOCS=( AUTHORS README.md misc/khard/khard.conf.example )

src_install() {
	distutils-r1_src_install
	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins misc/_khard
	fi
}
