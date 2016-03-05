$:.unshift File.join(File.dirname(__FILE__), "lib")
require 'socrata-layar'
require 'socrata-layar-app'

run SocrataLayar::App