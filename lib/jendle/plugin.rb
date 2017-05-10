module Jendle
  class Plugin

    def initialize(core)
      @core = core
      @client = core.client
      @logger = core.logger
    end

    def restore(options, source_config)
      source_client = @core.get_client(
        source_config['server_ip'],
        source_config['username'],
        source_config['password']
      )
      plugins = source_client.plugin.list_installed
      plugins.each do |k, v|
        apply_proc(k)
      end
      restart
    end

    def export(options)
      plugins = @client.plugin.list_installed
      File.open(options[:output],'w:utf-8') { |file|
        plugins.each do |k, v|
          file.puts k
        end
      }
      @logger.info("exported => #{options[:output]}")
    end

    def apply(options)
      File.read(options[:file]).lines.each do |plugin|
        plugin = plugin.strip
        apply_proc(plugin)
      end
      restart
    end

    def apply_proc(plugin)
      if !(@client.plugin.list_installed.key?(plugin))
        @client.plugin.install(plugin)
        sleep 3
      else
        @logger.info("already installed #{plugin}")
      end
    end

    def restart
      if @client.plugin.restart_required?
        @logger.info("restarting...")
        @client.system.restart(true)
      end
    end
  end
end
