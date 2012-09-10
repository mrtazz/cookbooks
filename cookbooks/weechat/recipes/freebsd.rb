script "install weechat from ports" do
  interpreter "sh"
  cwd "/usr/ports/irc/weechat"
  code <<-EOS
  make -DBATCH -DWITH_GNUTLS -DWITH_RUBY -DWITH_PYTHON -DWITH_LUA -DWITH_PERL -DWITH_TCL -DWITH_COLOR256 install clean
  EOS
  not_if { File.exists? "/usr/local/bin/weechat-curses" }
end
