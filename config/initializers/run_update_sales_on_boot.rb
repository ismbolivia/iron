# config/initializers/run_update_sales_on_boot.rb

# Solo ejecutar en el proceso principal del servidor Rails
if defined?(Rails::Server) && !ENV['RAILS_ASSET_ID'] # Evita que se ejecute durante la precompilación de assets

  Thread.new do
    Rails.application.config.after_initialize do
      require 'rake'
      Rails.application.load_tasks
      Rails.logger.info "Iniciando la tarea de actualización de estados de ventas en segundo plano..."
      begin
        # Ejecuta la tarea Rake que creamos
        # `Rake::Task['tasks:update_sale_statuses'].invoke` ejecuta la tarea.
        # `reenable` es necesario si la tarea ya se ha invocado en el mismo proceso (útil en entornos de desarrollo).
        # Rake::Task['tasks:update_sale_statuses'].reenable
        # Rake::Task['tasks:update_sale_statuses'].invoke
        Rails.logger.info "Tarea de actualización de estados de ventas saltada (comentada temporalmente)."
      rescue => e
        Rails.logger.error "Error al ejecutar la tarea de actualización de estados de ventas: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end
end
