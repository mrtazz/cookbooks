cookbook_file "/usr/local/sbin/scrub_zpools.sh" do
  source "scrub_zpools.sh"
  owner "root"
  group "wheel"
  mode 0750
end

cron "weekly zpool scrub" do
  user "root"
  minute "0"
  hour "2"
  weekday "0"
  command "/usr/local/sbin/scrub_zpools.sh"
end
