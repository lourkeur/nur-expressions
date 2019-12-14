{ stdenv, fetchFromGitLab, substituteAll, pkgconfig, libxslt, ninja, libX11, gnome3, gtk3, glib
, gettext, libxml2, xkeyboard_config, isocodes, meson, wayland
, libseccomp, systemd, bubblewrap, gobject-introspection, gtk-doc, docbook_xsl, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  pname = "gnome-desktop";
  version = "3.32.2";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "lourkeur";
    repo = "gnome-desktop";
    rev = "${version}%2Bimplement_130";
    sha256 = "1yi8i5a8h9wakwj4jly39w7bycrkiial9mdxk38f8v0923m2lnbd";
  };

  nativeBuildInputs = [
    pkgconfig meson ninja gettext libxslt libxml2 gobject-introspection
    gtk-doc docbook_xsl
  ];
  buildInputs = [
    libX11 bubblewrap xkeyboard_config isocodes wayland
    gtk3 glib libseccomp systemd
  ];

  propagatedBuildInputs = [ gsettings-desktop-schemas ];

  patches = [
    (substituteAll {
      src = ./bubblewrap-paths.patch;
      bubblewrap_bin = "${bubblewrap}/bin/bwrap";
      inherit (builtins) storeDir;
    })
  ];

  mesonFlags = [
    "-Dgtk_doc=true"
    "-Ddesktop_docs=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-desktop";
      attrPath = "gnome3.gnome-desktop";
    };
  };

  meta = with stdenv.lib; {
    description = "Library with common API for various GNOME modules";
    license = with licenses; [ gpl2 lgpl2 ];
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
