{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  flask,
  stem,
  pyqt5,
  pycrypto,
  pysocks,
  pytest,
  tor,
  obfs4,
}:

buildPythonApplication {
  pname = "onionshare";
  version = "2.1";
  src = fetchFromGitHub {
    owner = "micahflee";
    repo = "onionshare";
    rev = "v2.1";
    sha256 = "1lx21p12888qnbhsyin4lrnn4xizb39ldk77r71y53hn8mfxi54z";
  };

  propagatedBuildInputs = [
    flask
    stem
    pyqt5
    pycrypto
    pysocks
  ];
  buildInputs = [
    tor
    obfs4
  ];
  checkInputs = [
    pytest
  ];

  patches = [ ./nixify.patch ];

  # replace @tor@, @obfs4@, @geoip@ w/ store paths.
  inherit tor obfs4;
  inherit (tor) geoip;
  postPatch = "substituteAllInPlace onionshare/common.py";

  doCheck = false;  # need a $HOME

  meta = with lib; {
    description = "Securely and anonymously send and receive files";
    longDescription = ''
    OnionShare is an open source tool for securely and anonymously sending
    and receiving files using Tor onion services. It works by starting a web
    server directly on your computer and making it accessible as an
    unguessable Tor web address that others can load in Tor Browser to
    download files from you, or upload files to you. It doesn't require
    setting up a separate server, using a third party file-sharing service,
    or even logging into an account.

    Unlike services like email, Google Drive, DropBox, WeTransfer, or nearly
    any other way people typically send files to each other, when you use
    OnionShare you don't give any companies access to the files that you're
    sharing. So long as you share the unguessable web address in a secure way
    (like pasting it in an encrypted messaging app), no one but you and the
    person you're sharing with can access the files.
    '';

    homepage = https://onionshare.org/;

    license = licenses.gpl3Plus;
  };
}
