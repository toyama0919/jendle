require "thor"
require "yaml"

module Jendle
  class CLI < Thor

    map '--version' => :version

    class_option :config, aliases: '-c', type: :string, default: "#{ENV['HOME']}/.jendle", desc: 'config'
    class_option :profile, aliases: '-p', type: :string, default: 'default', desc: 'profile'
    def initialize(args = [], options = {}, config = {})
      super(args, options, config)
      @global_options = config[:shell].base.options
      config = get_config(@global_options[:profile])
      @core = Core.new(config)
      @job = Job.new(@core)
      @view = View.new(@core)
      @plugin = Plugin.new(@core)
    end

    desc 'export', 'export'
    def export
      invoke(:export_plugins, [], [])
      invoke(:export_jobs, [], [])
      invoke(:export_views, [], [])
    end

    desc 'apply', 'apply'
    option :'dry-run', aliases: '-d', type: :boolean, default: false, desc: 'dry-run'
    def apply
      invoke(:apply_plugins, [], ['-d', options[:'dry-run']])
      invoke(:apply_jobs, [], ['-d', options[:'dry-run']])
      invoke(:apply_views, [], ['-d', options[:'dry-run']])
    end

    desc 'restore', 'restore'
    option :source_profile, type: :string, required: true, desc: 'file'
    option :'dry-run', aliases: '-d', type: :boolean, default: false, desc: 'dry-run'
    def restore
      invoke(:restore_plugins, [], ['-d', options[:'dry-run'], 'source_profile', options[:source_profile]])
      invoke(:restore_jobs, [], ['-d', options[:'dry-run'], 'source_profile', options[:source_profile]])
      invoke(:restore_views, [], ['-d', options[:'dry-run'], 'source_profile', options[:source_profile]])
    end

    desc 'export_plugins', 'export_plugins'
    option :output, aliases: '-o', type: :string, default: 'Pluginfile', desc: 'output'
    def export_plugins
      @plugin.export(options)
    end

    desc 'apply_plugins', 'apply_plugins'
    option :file, aliases: '-f', type: :string, default: 'Pluginfile', desc: 'file'
    option :'dry-run', aliases: '-d', type: :boolean, default: false, desc: 'dry-run'
    def apply_plugins
      @plugin.apply(options)
    end

    desc 'restore_plugins', 'restore_plugins'
    option :source_profile, type: :string, required: true, desc: 'file'
    option :'dry-run', aliases: '-d', type: :boolean, default: false, desc: 'dry-run'
    def restore_plugins
      @plugin.restore(options, get_config(options[:source_profile]))
    end

    desc 'export_jobs', 'export_jobs'
    option :output, aliases: '-o', type: :string, default: 'Jobfile', desc: 'output'
    def export_jobs
      @job.export(options)
    end

    desc 'apply_jobs', 'apply_jobs'
    option :file, aliases: '-f', type: :string, default: 'Jobfile', desc: 'file'
    option :'dry-run', aliases: '-d', type: :boolean, default: false, desc: 'dry-run'
    def apply_jobs
      @job.apply(options)
    end

    desc 'restore_jobs', 'restore_jobs'
    option :source_profile, type: :string, required: true, desc: 'file'
    option :'dry-run', aliases: '-d', type: :boolean, default: false, desc: 'dry-run'
    option :job_name, aliases: '-j', type: :string, desc: 'job_name'
    def restore_jobs
      @job.restore(options, get_config(options[:source_profile]), options[:job_name])
    end

    desc 'export_views', 'export_views'
    option :output, aliases: '-o', type: :string, default: 'Viewfile', desc: 'output'
    def export_views
      @view.export(options)
    end

    desc 'apply_views', 'apply_views'
    option :file, aliases: '-f', type: :string, default: 'Viewfile', desc: 'file'
    option :'dry-run', aliases: '-d', type: :boolean, default: false, desc: 'dry-run'
    def apply_views
      @view.apply(options)
    end

    desc 'restore_views', 'restore_views'
    option :source_profile, type: :string, required: true, desc: 'file'
    option :'dry-run', aliases: '-d', type: :boolean, default: false, desc: 'dry-run'
    def restore_views
      @view.restore(options, get_config(options[:source_profile]))
    end

    desc 'restart', 'restart'
    def restart
      @core.restart
    end

    desc 'delete_jobs', 'delete_jobs'
    def delete_jobs
      @job.delete_jobs(options)
    end

    desc 'version', 'show version'
    def version
      puts VERSION
    end

    private

    def get_config(profile)
      YAML.load_file(@global_options[:config])[profile]
    end
  end
end
