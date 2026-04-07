class PurchasesV2::ImportsController < ApplicationController
  before_action :set_import, only: [:show, :edit, :update, :destroy, :add_expense, :remove_expense, :update_prices, :add_purchase_order, :remove_purchase_order, :update_state, :confirm_reception]

  def index
    @imports = Importacion.all.order(created_at: :desc)
  end

  def show
    # Calcula costos prorrateados para la vista usando el servicio de backend
    @landed_costs = PurchasesV2::ImportingService.new(@import).calculate_landed_costs
    @expense = @import.gastos_importaciones.new
  end

  def new
    @import = Importacion.new
  end

  def create
    @import = Importacion.new(import_params)
    if @import.save
      redirect_to purchases_v2_import_path(@import), notice: 'Importación creada correctamente.'
    else
      render :new
    end
  end

  def create_from_purchase_order
    @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
    
    # Crear la importación con un nombre por defecto
    @import = Importacion.new(
      name: "IMP-#{@purchase_order.name}-#{Date.current.strftime('%d%m%y')}",
      state: 'borrador',
      container_type: 'Pendiente'
    )

    if @import.save
      @purchase_order.update!(importacion_id: @import.id, origen: 'importacion')
      redirect_to purchases_v2_import_path(@import), notice: "✅ Carpeta de Importación ##{@import.id} creada y vinculada correctamente."
    else
      redirect_to purchase_order_path(@purchase_order), alert: "Error al crear la importación: #{@import.errors.full_messages.to_sentence}"
    end
  end

  def update
    if @import.update(import_params)
      redirect_to purchases_v2_import_path(@import), notice: 'Importación actualizada.'
    else
      render :edit
    end
  end

  # Acción para agregar Gastos (Flete, Seguros, Aduana)
  def add_expense
    @expense = @import.gastos_importaciones.new(expense_params)
    @expense.etapa = @import.state # Vinculado 1:1 a la etapa lógica
    if @expense.save
      redirect_to purchases_v2_import_path(@import), notice: "Gasto registrado correctamente en fase #{@import.state.capitalize}."
    else
      redirect_to purchases_v2_import_path(@import), alert: 'Error al agregar el gasto: ' + @expense.errors.full_messages.to_sentence
    end
  end

  # Acción para eliminar un Gasto de la Importación
  def remove_expense
    @expense = @import.gastos_importaciones.find(params[:expense_id])
    if @expense.destroy
      redirect_to purchases_v2_import_path(@import), notice: 'Gasto eliminado correctamente.'
    else
      redirect_to purchases_v2_import_path(@import), alert: 'Error al eliminar el gasto.'
    end
  end

  # Acción para vincular una Orden de Compra de formato Local a esta Importación
  def add_purchase_order
    return redirect_to purchases_v2_import_path(@import), alert: '⚠️ Bloqueado: Solo puedes modificar las órdenes de esta carga mientras estés en Fase de Borrador/Planificación.' unless @import.borrador?

    @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
    if @purchase_order.update(importacion_id: @import.id, origen: 'importacion')
      redirect_to purchases_v2_import_path(@import), notice: 'Orden de Compra vinculada correctamente al contenedor.'
    else
      redirect_to purchases_v2_import_path(@import), alert: 'Error al vincular Orden de Compra.'
    end
  end

  # Acción para desvincular (eliminar vinculación) de una Orden de Compra
  def remove_purchase_order
    return redirect_to purchases_v2_import_path(@import), alert: '⚠️ Bloqueado: No se pueden remover órdenes porque el envío ya ha avanzado lógicamente.' unless @import.borrador?

    @purchase_order = PurchaseOrder.find(params[:purchase_order_id])
    if @purchase_order.update(importacion_id: nil, origen: 'desvinculada')
      redirect_to purchases_v2_import_path(@import), notice: 'Orden de Compra desvinculada del contenedor.'
    else
      redirect_to purchases_v2_import_path(@import), alert: 'Error al desvincular la Orden de Compra.'
    end
  end

  # 🚀 PASO FINAL: Actualiza la tabla de precios Price.price_purchase con el Costo Landed
  def update_prices
    landed_costs = PurchasesV2::ImportingService.new(@import).calculate_landed_costs

    begin
      Price.transaction do
        landed_costs.each do |cost|
          item_id = cost[:item_id]
          costo_landed = cost[:costo_landed].to_f

          next if costo_landed <= 0 # Evita dañar costos en 0 de forma de seguridad

          item = Item.find(item_id)
          prices = item.prices.activo # Filtra precios activos

          # Actualiza para cada precio activo del ítem
          prices.each do |price|
            # Actualiza Costo de Compra
            price.price_purchase = costo_landed

            # --- LÓGICA DE COSTO OPERATIVO (OPEX) ---
            costo_operativo = costo_landed
            if price.opex_margin.to_f > 0 && price.opex_margin.to_f <= 100
              costo_operativo = costo_landed * (1 + (price.opex_margin.to_f / 100))
            elsif price.opex_margin.to_f > 100
              costo_operativo = costo_landed + price.opex_margin.to_f
            end

            # --- LÓGICA DE PRECIO DE VENTA SELECCIONADA ---
            if @import.pricing_logic == 'markup'
              price.price_sale = (costo_operativo * (1 + (price.utility.to_f / 100))).round(4)
            else
              if price.utility.to_f < 100 && price.utility.to_f > 0
                factor_margen = 1 - (price.utility.to_f / 100)
                price.price_sale = (costo_operativo / factor_margen).round(4)
              else
                price.price_sale = (costo_operativo + price.utility.to_f).round(4)
              end
            end

            price.save!
          end
        end
      end
      redirect_to purchases_v2_import_path(@import), notice: '🎉 Lista de Precios de Venta actualizada con éxito basado en el Costo Landed.'
    rescue => e
      redirect_to purchases_v2_import_path(@import), alert: 'Error al actualizar precios: ' + e.message
    end
  end

  # Acción AJAX para actualizar Peso y Volumen de un Ítem desde el Dashboard
  def update_item_dims
    @item = Item.find(params[:item_id])
    if @item.update(weight_kg: params[:weight_kg].to_f, volume_m3: params[:volume_m3].to_f)
      if params[:line_id].present? && params[:costo_fob].present?
        line = PurchaseOrderLine.find_by(id: params[:line_id])
        line.update(price_unit: params[:costo_fob].to_f) if line
      end
      render json: { success: true }
    else
      render json: { success: false, errors: @item.errors.full_messages }
    end
  end

  # Acción AJAX para el Laboratorio de Precios
  def update_price_margins
    if params[:pricing_logic].present?
      @import.update(pricing_logic: params[:pricing_logic])
    end

    price = Price.find(params[:price_id]) if params[:price_id].present?
    
    if price&.update(
        utility: params[:utility].to_f, 
        opex_margin: params[:opex_margin].to_f,
        comp_1_price: params[:comp_1].to_f,
        comp_2_price: params[:comp_2].to_f,
        comp_3_price: params[:comp_3].to_f
      )
      render json: { success: true }
    elsif params[:pricing_logic].present?
      render json: { success: true } # Solo actualizamos lógica de la importación
    else
      render json: { success: false, errors: "Error al guardar el margen" }
    end
  end
  # Acción para cambiar de Estado la Importación (Fase Logística)
  def update_state
    nuevo_estado = params[:state]

    if @import.state == 'borrador' && nuevo_estado == 'transito' && @import.purchase_orders.empty?
      return redirect_to purchases_v2_import_path(@import), alert: '⛔ Bloqueado: No puedes avanzar esta carpeta logística a Tránsito sin haber vinculado productos / órdenes de compra.'
    end

    if @import.update(state: nuevo_estado)
      redirect_to purchases_v2_import_path(@import), notice: "Fase logística avanzada exitosamente a: #{nuevo_estado.upcase}."
    else
      redirect_to purchases_v2_import_path(@import), alert: 'Error al cambiar de fase logística.'
    end
  end

  # Acción para Aprobar Precios, Ingresar Stock y Sellar la Importación (Laboratorio)
  def confirm_reception
    if @import.state == 'recibido'
      # 1. Asegurar almacén
      warehouse_id = params[:warehouse_id].presence || Warehouse.where("name ILIKE ?", "%import%").first&.id || Warehouse.first&.id

      if warehouse_id.nil?
        return redirect_to purchases_v2_import_path(@import), alert: 'No hay ningún almacén disponible para ingresar el stock.'
      end

      # 2. Sellar precios en cadena atómica junto a inventarios
      begin
        ActiveRecord::Base.transaction do
          # Actualizar Base de Precios con los nuevos márgenes calibardos en el laboratorio
          landed_costs = PurchasesV2::ImportingService.new(@import).calculate_landed_costs
          landed_costs.each do |cost|
            costo_landed = cost[:costo_landed].to_f
            next if costo_landed <= 0
            
            Item.find(cost[:item_id]).prices.activo.each do |price|
              price.price_purchase = costo_landed

              costo_operativo = costo_landed
              if price.opex_margin.to_f > 0 && price.opex_margin.to_f <= 100
                costo_operativo = costo_landed * (1 + (price.opex_margin.to_f / 100))
              elsif price.opex_margin.to_f > 100
                costo_operativo = costo_landed + price.opex_margin.to_f
              end

              # --- LÓGICA DE PRECIO DE VENTA SELECCIONADA (Según Carpeta) ---
              if @import.pricing_logic == 'markup'
                price.price_sale = (costo_operativo * (1 + (price.utility.to_f / 100))).round(4)
              else
                if price.utility.to_f < 100 && price.utility.to_f > 0
                  factor_margen = 1 - (price.utility.to_f / 100)
                  price.price_sale = (costo_operativo / factor_margen).round(4)
                else
                  price.price_sale = (costo_operativo + price.utility.to_f).round(4)
                end
              end
              price.save!
            end
          end

          # Marcar Etapa Terminada (Ahora el stock se ingresará vía ReceptionsController)
          @import.update!(state: 'completado')
        end
        redirect_to purchases_v2_import_path(@import), notice: '🎉 ¡Cierre Financiero Exitoso! Los precios han sido recalibrados. Ahora procede con la Recepción Física de cada O.C. para ingresar el stock.'
      rescue => e
        redirect_to purchases_v2_import_path(@import), alert: 'Error en la liquidación: ' + e.message
      end
    else
      redirect_to purchases_v2_import_path(@import), alert: 'Debe estar en estado "Recibido" para cerrar Importación.'
    end
  end
  private

  def set_import
    @import = Importacion.find(params[:id])
  end

  def import_params
    params.require(:importacion).permit(:name, :container_type, :eta_date, :state, :notes)
  end

  def expense_params
    params.require(:gasto_importacion).permit(:description, :amount, :gasto_type, :prorrateo_method)
  end
end
