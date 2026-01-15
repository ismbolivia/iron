namespace :tasks do
  desc "Update payment status for all non-finalized sales"
  task update_sale_statuses: :environment do
    puts "Starting daily update of sale statuses..."

    # Define los estados que no necesitan actualización diaria
    final_statuses = [
      Sale::PAYMENT_STATUSES[:paid],
      Sale::PAYMENT_STATUSES[:annulled],
      Sale::PAYMENT_STATUSES[:draft],
      Sale::PAYMENT_STATUSES[:canceled]
    ]

    # Filtra las ventas que no están en un estado final
    sales_to_update = Sale.where.not(payment_status_cache: final_statuses)

    puts "Found #{sales_to_update.count} sales to update."

    sales_to_update.find_each do |sale|
      begin
        sale.update_status_priority!
        print "."
      rescue => e
        puts "\nError updating sale #{sale.id}: #{e.message}"
      end
    end

    puts "\nDaily update of sale statuses finished successfully."
  end
end

