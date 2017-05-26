module Jendle
  class Job < Base

    def delete_jobs(options)
      get_config_pairs.keys.each do |job_name|
        @client.job.delete(job_name)
      end
    end

    def restore(options, source_config, apply_job_name = nil)
      source_client = @core.get_client(
        source_config['server_ip'],
        source_config['username'],
        source_config['password']
      )
      get_config_pairs(source_client).each do |job_name, xml|
        if (job_name == apply_job_name) || apply_job_name.nil?
          apply_proc(job_name, xml, options[:'dry-run'])
        end
      end
    end

    def export(options)
      File.write(options[:output], get_config_pairs.to_yaml)
      @logger.info("exported => #{options[:output]}")
    end

    def apply(options)
      jobs = YAML.load_file(options[:file])
      jobs.each do |job_name, xml|
        apply_proc(job_name, xml, options[:'dry-run'])
      end
    end

    private

    def get_config_pairs(client = @client)
      hash = {}
      client.job.list_all_with_details.each do |job|
        hash[job['name']] = client.job.get_config(job['name'])
      end
      hash
    end

    def apply_proc(job_name, xml, dryrun)
      before_xml = if @client.job.exists?(job_name)
        @client.job.get_config(job_name)
      else
        nil
      end

      if (before_xml == xml)
        @logger.info("no change => #{job_name}")
      else
        puts Diffy::Diff.new(before_xml, xml, :context => 3).to_s(:color)
        unless dryrun
          @client.job.create_or_update(job_name, xml)
        end
        @logger.info("applied => #{job_name}")
      end
      sleep 3
    end
  end
end
