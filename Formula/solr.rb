class Solr < Formula
  desc "Enterprise search platform from the Apache Lucene project"
  homepage "https://lucene.apache.org/solr/"
  url "https://www.apache.org/dyn/closer.lua?path=lucene/solr/8.4.1/solr-8.4.1.tgz"
  mirror "https://archive.apache.org/dist/lucene/solr/8.4.1/solr-8.4.1.tgz"
  sha256 "ec39e1e024b2e37405149de41e39e875a39bf11a53f506d07d96b47b8d2a4301"
  revision 2

  bottle :unneeded

  depends_on "openjdk"

  def install
    pkgshare.install "bin/solr.in.sh"
    (var/"lib/solr").install "server/solr/README.txt", "server/solr/solr.xml", "server/solr/zoo.cfg"
    prefix.install %w[contrib dist server]
    libexec.install Dir["bin"]
    bin.install [libexec/"bin/solr", libexec/"bin/post", libexec/"bin/oom_solr.sh"]
    bin.env_script_all_files libexec, :JAVA_HOME => Formula["openjdk"].opt_prefix, :SOLR_HOME => var/"lib/solr"
    (libexec/"bin").rmtree
  end

  plist_options :manual => "solr start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/solr</string>
            <string>start</string>
            <string>-f</string>
            <string>-s</string>
            <string>/usr/local/var/lib/solr</string>
          </array>
          <key>ServiceDescription</key>
          <string>#{name}</string>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
          <key>RunAtLoad</key>
          <true/>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"solr"
  end
end
