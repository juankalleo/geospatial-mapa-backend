require_relative "config/boot"
require_relative "config/application"

begin
  require 'yaml'
  require 'erb'
  db_yml = ERB.new(File.read(File.expand_path("config/database.yml", __dir__))).result
  db_cfg = YAML.safe_load(db_yml, aliases: true) rescue YAML.load(db_yml) rescue nil

  if db_cfg
    if defined?(Rails) && Rails.respond_to?(:application) && Rails.application.respond_to?(:config)
      Rails.application.config.database_configuration ||= db_cfg
    end

    if defined?(ActiveRecord) && ActiveRecord::Base.respond_to?(:configurations=)
      ActiveRecord::Base.configurations = db_cfg
    end
  end
rescue => e
  warn "Rakefile: failed to pre-load database.yml: #{e.class}: #{e.message}"
end

Rails.application.load_tasks