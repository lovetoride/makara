require 'active_record/connection_adapters/makara_abstract_adapter'
require 'active_record/connection_adapters/postgis_adapter'

if ActiveRecord::VERSION::MAJOR >= 4

  module ActiveRecord
    module ConnectionHandling
      def postgis_makara_connection(config)
        ActiveRecord::ConnectionAdapters::MakaraPostgisAdapter.new(config)
      end
    end
  end

else

  module ActiveRecord
    class Base
      def self.postgis_makara_connection(config)
        ActiveRecord::ConnectionAdapters::MakaraPostgisAdapter.new(config)
      end
    end
  end

end

module ActiveRecord
  module ConnectionAdapters
    class MakaraPostgisAdapter < ActiveRecord::ConnectionAdapters::MakaraAbstractAdapter

      class << self
        def visitor_for(*args)
          ActiveRecord::ConnectionAdapters::PostgisAdapter.visitor_for(*args)
        end
      end

      # def _appropriate_pool(method_name, args)
      #   return @master_pool unless Thread.current[:distribute_reads]
      #   super
      # end

      protected

      def active_record_connection_for(config)
        ::ActiveRecord::Base.postgis_connection(config)
      end

    end
  end
end
