# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit qmake-utils

DESCRIPTION="A Qt-based UPnP audio Control point"
HOMEPAGE="http://www.lesbonscomptes.com/upplay"
SRC_URI="http://www.lesbonscomptes.com/upplay/downloads/${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+webengine"

DEPEND="
		dev-libs/expat
		dev-libs/jsoncpp
		dev-qt/qtnetwork:5
		!webengine? ( dev-qt/qtwebkit:5 )
		webengine? ( dev-qt/qtwebengine:5 )
		media-libs/libupnpp
		|| (
			>=media-libs/libupnpp-0.19.0
			>=net-libs/libnpupnp-0.19.0
		)
		net-misc/curl"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user

	use webengine && sed -e "s:#WEBPLATFORM = webengine:WEBPLATFORM = webengine:" -i upplay.pro

}

src_compile() {
	eqmake5 PREFIX="/usr"
	sed -e "s:Categories=.*$:Categories=Audio;AudioVideo;:" \
                -i upplay.desktop
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
