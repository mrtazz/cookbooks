script "install mutt" do
  interpreter "sh"
  cwd "/usr/ports/mail/mutt"
  code <<-EOS
  make -DBATCH -DWITH_MUTT_IMAP_HEADER_CACHE -DWITH_MUTT_MAILDIR_HEADER_CACHE \
  -DWITH_MUTT_SMTP -DWITH_TOKYOCABINET install clean
  EOS
  not_if { File.exists? "/usr/local/bin/mutt" }
end
