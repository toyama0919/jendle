require 'logger'
require "diffy"
require "jenkins_api_client"

module Jendle
  class Core

    attr_accessor :client
    attr_accessor :logger

    def initialize(config)
      @client = get_client(config['server_ip'], config['username'], config['password'])
      @logger = Logger.new(STDOUT)
    end

    def get_client(server_ip, username, password)
      params = {
        :server_ip => server_ip
      }
      params[:username] = username if username
      params[:password] = password if password
      @client = JenkinsApi::Client.new(params)
    end

    def restart
      @client.system.restart(true)
    end
  end
end
