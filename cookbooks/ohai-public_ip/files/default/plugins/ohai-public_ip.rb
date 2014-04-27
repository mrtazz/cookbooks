provides 'public_ip'

cmd = 'curl http://icanhazip.com'
status, stdout, stderr = run_command(:command => cmd)
public_ip (stdout.nil? || stdout.length < 1) ? '' : stdout
