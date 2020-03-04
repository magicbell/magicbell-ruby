require 'rails'
require 'yaml'

module MagicBell
  module Init
    module Rails
      class Railtie < ::Rails::Railtie
        #rake_tasks do
        #  load 'magicbell/tasks.rb'
        #end

        config.after_initialize do
          MagicBell.init!({
            :root           => ::Rails.root.to_s,
            :env            => ::Rails.env,
            :'config.path'  => ::Rails.root.join('config', 'magicbell.yml'),
            :logger         => Logging::FormattedLogger.new(::Rails.logger),
            :framework      => :rails
          })
          MagicBell.load_plugins!
        end
      end
    end
  end
end

MagicBell.install_at_exit_callback