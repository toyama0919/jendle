module Jendle
  class Plugin < Base

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
      @core.restart
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
        apply_proc(plugin, options[:'dry-run'])
      end
      @core.restart
    end

    def apply_proc(plugin, dryrun)
      if !(@client.plugin.list_installed.key?(plugin))
        unless dryrun
          @client.plugin.install(plugin)
          sleep 3
        end
      else
        @logger.info("already installed #{plugin}")
      end
    end
  end
end
