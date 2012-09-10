package 'tmux'

template "/usr/local/etc/tmux.conf" do
    mode   0750
    owner  ENV['USER']
    group  Etc.getgrgid(Process.gid).name
    source "dot.tmux.conf"
    variables({ :home => ENV['HOME'] })
end

