package 'ack'

template "#{ENV['HOME']}/.ackrc" do
    mode   0700
    owner  ENV['USER']
    group  Etc.getgrgid(Process.gid).name
    source "dot.ackrc.erb"
    variables({ :home => ENV['HOME'] })
end

