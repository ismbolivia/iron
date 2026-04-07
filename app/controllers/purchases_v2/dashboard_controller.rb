module PurchasesV2
  class DashboardController < ApplicationController
    include NumberGenerator
    # before_action :authenticate_user! # Descomentar si requieres auth

    def index
      # Este controlador sirve como punto de entrada de la Fase 1: Matriz de Inteligencia
      @months = params[:months].present? ? params[:months].to_f : 1.5
      @matrix_items = PurchasesV2::IntelligenceService.analyze_rotation(params[:supplier_id], @months, 50)

      respond_to do |format|
        format.html
        format.js
      end
    end

    def search_items
      query = params[:q]
      items = Item.where("name ILIKE ? OR code ILIKE ?", "%#{query}%", "%#{query}%").limit(10)
      render json: items.map { |i| { id: i.id, text: "#{i.code} - #{i.name}" } }
    end

    def add_item_row
      item_id = params[:item_id]
      supplier_id = params[:supplier_id]
      months = params[:months].present? ? params[:months].to_f : 1.5
      
      # Si hay un proveedor seleccionado, vinculamos el ítem
      if supplier_id.present? && item_id.present?
        ItemsSupplier.find_or_create_by(item_id: item_id, supplier_id: supplier_id, state: 1)
      end

      item_data = PurchasesV2::IntelligenceService.analyze_rotation(nil, months, 1, item_id).first
      
      if item_data
        @item = item_data
        @index = params[:index].to_i
        respond_to do |format|
          format.js
        end
      else
        render js: "toastr.error('No se encontró información para este ítem');"
      end
    end

    def generate_draft
      supplier_id = params[:supplier_id]
      items_data = params[:items] # Map de item_id -> qty
      costs_data = params[:costs] # Map de item_id -> cost
      
      if supplier_id.blank?
        return render json: { success: false, message: "Por favor, seleccione un proveedor para generar el borrador." }
      end

      if items_data.blank? || items_data.values.all? { |v| v.to_f <= 0 }
        return render json: { success: false, message: "No hay cantidades válidas para generar una orden." }
      end

      begin
        PurchaseOrder.transaction do
          payment_term = PaymentTerm.find_by(name: "draft") || PaymentTerm.first || PaymentTerm.create(name: "draft")
          number = generate_next_number(PurchaseOrder)

          # Buscar moneda por defecto o usar la primera
          currency = Currency.find_by(name: 'USD') || Currency.first

          @purchase_order = PurchaseOrder.new(
            supplier_id: supplier_id,
            state: :confirmed,
            create_uid: current_user.id,
            date_order: Date.current,
            payment_term: payment_term,
            number: number,
            currency_id: currency&.id,
            origen: params[:order_type] || 'local'
          )
          
          @purchase_order.name = @purchase_order.getPurchaseORderNumber
          @purchase_order.save!

          items_data.each do |item_id, qty|
            qty = qty.to_f
            next if qty <= 0

            # Priorizar el costo enviado desde la matriz (params[:costs])
            # Si no viene o es 0, usamos el último histórico como respaldo
            user_cost = costs_data&.dig(item_id).to_f
            
            if user_cost > 0
              final_cost = user_cost
            else
              final_cost = PurchaseOrderLine.where(item_id: item_id)
                                           .order(created_at: :desc)
                                           .limit(1)
                                           .pluck(:price_unit)
                                           .first || 0.0
            end

            @purchase_order.purchase_order_lines.create!(
              item_id: item_id,
              item_qty: qty,
              price_unit: final_cost,
              price_tax: 0.0,
              date_planned: Date.current + 7.days,
              state: :confirmado
            )
          end
          
          render json: { success: true, redirect_url: purchase_order_path(@purchase_order), message: "Borrador de orden de compra generado con éxito." }
        end
      rescue => e
        render json: { success: false, message: "Error al generar el borrador: #{e.message}" }
      end
    end
  end
end
