namespace :mantenimiento do
  desc "Mueve cobros cargados por error en cuentas de Bolivianos (Bs) a cuentas en Dólares ($)"
  task mover_cobros_a_dolares: :environment do
    count = 0

    # Busca pagos en cuentas con currency_id = 2 (Bolivianos)
    # y los migra a la cuenta del mismo vendedor de currency_id = 1 (Dólares)
    Payment.joins(:account).where(accounts: { currency_id: 2 }).each do |pay|
      from_account = pay.account
      to_account = Account.find_by(user_id: from_account.user_id, currency_id: 1)

      if to_account
        pay.update_columns(account_id: to_account.id)
        count += 1
        puts " -> Cobro ID #{pay.id} ($#{pay.rode}): Movido de #{from_account.name} a #{to_account.name}"
      else
        puts " ! Alerta: El vendedor de #{from_account.name} no tiene cuenta en Dólares configurada para mover el Cobro ID #{pay.id}"
      end
    end

    puts "\n✅ Éxito: Se corrigieron #{count} cobros en total."
  end

  desc "Migra cobros en efectivo antiguos desde Cuentas a Cajas de Ruta"
  task migrar_pagos_a_cajas: :environment do
    count = 0
    accounts = Account.where("name LIKE ?", '%Cobro%')

    accounts.each do |acc|
      user = acc.user
      next unless user

      # Crear o Buscar Caja de Ruta
      box = Box.find_or_create_by!(user_id: user.id, currency_id: acc.currency_id, name: "Caja de Ruta - #{user.name}") do |b|
        b.active = true
        b.description = "Efectivo recolectado en ruta"
      end

      # Buscar cobros en Efectivo (payment_type_id = 1)
      payments = acc.payments.where(payment_type_id: 1, box_id: nil)

      payments.each do |p|
         p.update_columns(box_id: box.id)
         
         # Crear BoxDetail con validación saltada para MAXIMA VELOCIDAD
         bd = BoxDetail.new(
             box_id: box.id,
             amount: p.rode,
             reason: "Migración: Cobro Recibo ##{p.get_num_payment}",
             state: "input",
             created_at: p.created_at
         )
         bd.save(validate: false)
         count += 1
      end
    end
    puts "✅ Éxito: Se migraron #{count} cobros en efectivo a Cajas de Ruta."
  end
end
