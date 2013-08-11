cron "portsnap update" do
  user "root"
  minute "0"
  hour "3"
  command "portsnap -I cron update && pkg_version -vIL="
end
