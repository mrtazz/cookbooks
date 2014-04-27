name             'ohai-public_ip'
maintainer       'Robby Grossman'
maintainer_email 'robby@freerobby.com'
license          'All rights reserved'
description      'Installs/Configures public_ip'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.16'

depends 'chef-client'
depends 'ohai'
