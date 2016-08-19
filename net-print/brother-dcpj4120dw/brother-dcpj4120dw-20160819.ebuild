# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit rpm multilib

HOMEPAGE=""
SRC_URI=""

MODEL="${PN#*-}"
PV_LPR="3.0.1-1"
PV_CUPSWRAPPER="3.0.1-1"

DESCRIPTION="Brother DPC-J4120DW LPR+cupswrapper drivers"
HOMEPAGE="http://support.brother.com/g/b/producttop.aspx?c=nl&lang=nl&prod=dcpj4120dw_eu_as"
SRC_URI="http://download.brother.com/welcome/dlf101557/${MODEL}lpr-${PV_LPR}.i386.rpm
         http://download.brother.com/welcome/dlf101558/${MODEL}cupswrapper-${PV_CUPSWRAPPER}.i386.rpm"

LICENSE="GPL-2+ Brother-lpr no-source-code"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+metric"
RESTRICT="strip"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

S="${WORKDIR}/opt/brother/Printers/${MODEL}"

src_unpack() {
	rpm_unpack ${A}
}

src_prepare() {
	eapply_user
	if use metric; then
		sed -i "/^PaperType/s/Letter/A4/" inf/br${MODEL}rc || die
	fi
}

src_install() {
	has_multilib_profile && ABI=x86

	local dest=/opt/brother/Printers/${MODEL}
	cd "${S}"/lpd || die
	exeinto ${dest}/lpd
	doexe br${MODEL}filter filter${MODEL} psconvertij2

	dosym ${dest}/lpd/filter${MODEL} \
		  /usr/libexec/cups/filter/brother_lpdwrapper_${MODEL}

	cd "${S}"/inf || die
	insinto ${dest}/inf
	doins br${MODEL}func ImagingArea PaperDimension paperinfij2
	doins -r lut
	insinto /etc${dest}/inf
	doins br${MODEL}rc			# config file
	dosym /etc${dest}/inf/br${MODEL}rc ${dest}/inf/br${MODEL}rc

	cd "${S}"/cupswrapper || die
	insinto ${dest}/cupswrapper
	doins brother_${MODEL}_printer_en.ppd
	dosym ${dest}/cupswrapper/brother_${MODEL}_printer_en.ppd \
		  /usr/share/cups/model/Brother/brother_${MODEL}_printer_en.ppd

	# The brprintconf utility is very broken and mangles the path
	# of the function list file. Therefore, don't install it.
	# exeinto ${dest}/bin
	# doexe "${WORKDIR}"/usr/bin/brprintconf_${MODEL}
}

# pkg_postinst () {
# 	elog "You may use brprintconf_${MODEL} to change printer options"
# 	elog
# 	elog "Set 'Fast Normal' quality:"
# 	elog "		${dest}/bin/brprintconf_${MODEL} -reso 300x300dpi"
# 	elog
# 	elog "For more options just execute brprintconf_${MODEL} as root"
# 	elog "You can check current settings in:"
# 	elog "		/opt/brother/Printers/${MODEL}/inf/br${MODEL}rc"
# }

