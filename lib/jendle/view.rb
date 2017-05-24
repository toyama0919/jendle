module Jendle
  class View < Base

    def restore(options, source_config)
      source_client = @core.get_client(
        source_config['server_ip'],
        source_config['username'],
        source_config['password']
      )
      get_config_pairs(source_client).each do |view_name, xml|
        apply_proc(job_name, xml, options[:'dry-run'])
      end
    end

    def export(options)
      File.write(options[:output], get_config_pairs.to_yaml)
      @logger.info("exported => #{options[:output]}")
    end

    def apply(options)
      jobs = YAML.load_file(options[:file])
      jobs.each do |view_name, xml|
        apply_proc(view_name, xml, options[:'dry-run'])
      end
    end

    private

    def get_config_pairs(client = @client)
      hash = {}
      client.view.list('.*').each do |view|
        hash[view] = client.view.get_config(view)
      end
      hash
    end

    def apply_proc(view_name, xml, dryrun)
      before_xml = if @client.view.exists?(view_name)
        @client.view.get_config(view_name)
      else
        nil
      end

      if (before_xml == xml)
        @logger.info("no change => #{view_name}")
      else
        puts Diffy::Diff.new(before_xml, xml, :context => 3).to_s(:color)
        unless dryrun
          if @client.view.exists?(view_name)
            @client.view.post_config(view_name, xml)
          else
            @client.post_config("/createView?name=#{view_name}", xml)
          end
        end
      end
      @logger.info("applied => #{view_name}")
      sleep 3
    end
  end
end
