script "install mosh" do
  interpreter "sh"
  cwd "/usr/ports/net/mosh"
  code <<-EOS
  make -DBATCH install clean
  EOS
  not_if { File.exists? "/usr/local/bin/mosh-server" }
end
