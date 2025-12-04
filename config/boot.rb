ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

if File.exist?(ENV['BUNDLE_GEMFILE'])
  require 'bundler/setup'
  # bootsnap é opcional — só carrega se estiver no Gemfile e instalado
  begin
    require 'bootsnap/setup' # speeds up boot time
  rescue LoadError
    # ignore if bootsnap is not available
  end
end