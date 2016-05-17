# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# Based on the ebuild from github.com/mrpdaemon/gentoo-overlay, and some tips
# from the AUR PKGBUILD.

EAPI=5

inherit unpacker systemd

DESCRIPTION="Advanced cross-platform Google Drive client"
HOMEPAGE="https://www.insynchq.com/"
MAGIC="36076"
EXTRA_PV="1.2.8"
EXTRA_MAGIC="35136"
SRC_URI="
	abi_x86_64?    ( http://s.insynchq.com/builds/insync_${PV}.${MAGIC}-trusty_amd64.deb )
	nautilus? ( http://s.insynchq.com/builds/insync-nautilus_${EXTRA_PV}.${EXTRA_MAGIC}-precise_all.deb )
	dolphin?  ( http://s.insynchq.com/builds/insync-dolphin_${EXTRA_PV}.${EXTRA_MAGIC}-precise_all.deb )
	thunar?   ( http://s.insynchq.com/builds/insync-thunar_${EXTRA_PV}.${EXTRA_MAGIC}-precise_all.deb )
	caja?     ( http://s.insynchq.com/builds/insync-caja_${EXTRA_PV}.${EXTRA_MAGIC}-precise_all.deb )"

SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
DEPEND=""
RDEPEND="${DEPEND}
	nautilus? ( dev-python/nautilus-python )
	dolphin? ( kde-apps/dolphin )
	thunar? ( dev-python/thunarx-python )"
IUSE="+abi_x86_64 nautilus +dolphin thunar caja"

# stuff is pre-stripped
QA_PREBUILT="/usr/lib/insync/*"

S="${WORKDIR}"

src_unpack() {
	if use abi_x86_64 ; then
		unpack_deb insync_"${PV}.${MAGIC}"-trusty_amd64.deb
	fi

	for i in nautilus dolphin thunar caja ; do
		if use ${i} ; then
			unpack_deb insync-"${i}_${EXTRA_PV}.${EXTRA_MAGIC}"-precise_all.deb
		fi
	done
}

src_prepare() {
	# fix missing semicolon to hush QA notice.
	sed -i -e 's/MimeType=.*/&;/' usr/share/applications/insync-helper.desktop
}

src_install() {
	doins -r *
	# fix exe permissions
	fperms a+x /usr/{bin,lib/insync}/insync{,-headless}

	# install service menu for kf5 as well
	if use dolphin ; then
		dosym ../../kde4/services/ServiceMenus/insync_servicemenu.desktop /usr/share/kservices5/ServiceMenus/insync_servicemenu.desktop
	fi

	# install systemd service file (from AUR PKGBUILD)
	systemd_newunit "${FILESDIR}"/insync_at.service "insync@.service"

	dodir "/etc/revdep-rebuild"
	insinto "/etc/revdep-rebuild"
	doins "${FILESDIR}/70insync"
}
