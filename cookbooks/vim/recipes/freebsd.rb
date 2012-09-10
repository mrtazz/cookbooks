script "install vim" do
  interpreter "sh"
  cwd "/usr/ports/editors/vim"
  code <<-EOS
  make -DBATCH -DWITH_PYTHON -DWITH_RUBY -DWITHOUT_X11 install clean
  EOS
  not_if { File.exists? "/usr/local/bin/vim" }
end
