require 'formula'

class LibgpgError < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.26.tar.bz2'
  homepage 'http://www.gnupg.org/'
  sha256 '4c4bcbc90116932e3acd37b37812d8653b1b189c1904985898e860af818aee69'
  
  keep_install_names true
  
  depends_on "libiconv"
  depends_on "gettext"
  
  def install
    ENV.j1
    ENV.universal_binary if ARGV.build_universal? # build fat so wine can use it
    # Make sure that deployment target is 10.6+ so the lib works
    # on 10.6 and up not only on host system os x version.
    ENV.macosxsdk("10.6")
    # It's necessary to add the -rpath to the LDFLAGS, otherwise
    # programs can't link to libraries using @rpath.
    ENV.prepend 'LDFLAGS', '-headerpad_max_install_names'
    ENV.prepend 'LDFLAGS', "-Wl,-rpath,@loader_path/../lib -Wl,-rpath,#{HOMEBREW_PREFIX}/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libiconv-prefix=#{HOMEBREW_PREFIX}",
                          "--with-libintl-prefix=#{HOMEBREW_PREFIX}",
                          "--enable-static=no", "--disable-maintainer-mode"
    
    system "make check"
    system "make install"
  end
end
