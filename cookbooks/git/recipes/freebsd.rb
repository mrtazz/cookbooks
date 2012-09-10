script "install git" do
  interpreter "sh"
  cwd "/usr/ports/devel/git"
  code <<-EOS
  make -DBATCH install clean
  EOS
  not_if { File.exists? "/usr/local/bin/git" }
end
