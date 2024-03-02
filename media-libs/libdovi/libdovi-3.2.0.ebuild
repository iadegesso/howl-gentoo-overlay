# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aho-corasick@1.1.2
	anes@0.1.6
	anstyle@1.0.6
	anyhow@1.0.80
	autocfg@1.1.0
	bitstream-io@2.2.0
	bitvec@1.0.1
	bitvec_helpers@3.1.3
	bumpalo@3.15.3
	cast@0.3.0
	cfg-if@1.0.0
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.5.1
	clap_builder@4.5.1
	clap_lex@0.7.0
	crc-catalog@2.4.0
	crc@3.0.1
	criterion-plot@0.5.0
	criterion@0.5.1
	crossbeam-deque@0.8.5
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.19
	crunchy@0.2.2
	either@1.10.0
	equivalent@1.0.1
	funty@2.0.0
	half@2.3.1
	hashbrown@0.14.3
	hermit-abi@0.3.8
	indexmap@2.2.3
	is-terminal@0.4.12
	itertools@0.10.5
	itoa@1.0.10
	js-sys@0.3.68
	libc@0.2.153
	log@0.4.20
	memchr@2.7.1
	num-traits@0.2.18
	once_cell@1.19.0
	oorandom@11.1.3
	plotters-backend@0.3.5
	plotters-svg@0.3.5
	plotters@0.3.5
	proc-macro2@1.0.78
	quote@1.0.35
	radium@0.7.0
	rayon-core@1.12.1
	rayon@1.8.1
	regex-automata@0.4.5
	regex-syntax@0.8.2
	regex@1.10.3
	roxmltree@0.18.1
	ryu@1.0.17
	same-file@1.0.6
	serde@1.0.197
	serde_derive@1.0.197
	serde_json@1.0.114
	syn@2.0.50
	tap@1.0.1
	tinytemplate@1.2.1
	unicode-ident@1.0.12
	walkdir@2.4.0
	wasm-bindgen-backend@0.2.91
	wasm-bindgen-macro-support@0.2.91
	wasm-bindgen-macro@0.2.91
	wasm-bindgen-shared@0.2.91
	wasm-bindgen@0.2.91
	web-sys@0.3.68
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.6
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-sys@0.52.0
	windows-targets@0.52.3
	windows_aarch64_gnullvm@0.52.3
	windows_aarch64_msvc@0.52.3
	windows_i686_gnu@0.52.3
	windows_i686_msvc@0.52.3
	windows_x86_64_gnu@0.52.3
	windows_x86_64_gnullvm@0.52.3
	windows_x86_64_msvc@0.52.3
	wyz@0.5.1
	xmlparser@0.13.6
"

inherit cargo git-r3

DESCRIPTION="CLI tool combining multiple utilities for working with Dolby Vision"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/quietvoid/dovi_tool"
SRC_URI="$(cargo_crate_uris)"
MY_PN="dovi_tool"
MY_PV="2.1.0"
EGIT_COMMIT="${MY_PV}"
EGIT_REPO_URI="https://github.com/quietvoid/dovi_tool.git"
RESTRICT="network-sandbox"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="Apache-2.0 Boost-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64"

src_unpack() {
	cargo_src_unpack
	git-r3_src_unpack

	# TODO: Figure out how to get these deps for offline mode.
	pushd "${S}"
	cargo -v --config "net.offline = false" fetch --manifest-path ${S}/dolby_vision/Cargo.toml
	popd
}

src_compile() {
    export CARGO_HOME="${ECARGO_HOME}"
    local args=$(usex debug "" --release)

    cargo cbuild ${args} --frozen --prefix=/usr --manifest-path ${S}/dolby_vision/Cargo.toml \
        || die "cargo build failed"
}

src_install() {
    export CARGO_HOME="${ECARGO_HOME}"
    local args=$(usex debug "" --release)
    
    cargo cinstall ${args} --frozen --prefix=/usr --libdir="/usr/$(get_libdir)" --destdir="${ED}" --manifest-path ${S}/dolby_vision/Cargo.toml \
    || die "cargo cinstall failed"
    
#    cargo_src_install --path ${S}/dolby_vision/

#    dobin "${S}/dolby_vision/target/x86_64-unknown-linux-gnu/release"
}
