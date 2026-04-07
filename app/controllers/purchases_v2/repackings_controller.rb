module PurchasesV2
  class RepackingsController < ApplicationController
    before_action :authenticate_user! # Asegurar que solo usuarios logueados operen

    def index
      @repackings = Repacking.all.order(created_at: :desc).limit(50)
    end

    def new
      @items = Item.where(active: true).order(:name)
      @warehouses = Warehouse.where(active: true)
    end

    def create
      # Formateamos los parámetros para el servicio
      repack_params = {
        item_id: params[:item_id],
        stock_id: params[:stock_id],
        warehouse_id: params[:warehouse_id],
        auto_adjust_diff: params[:auto_adjust_diff],
        adjustment_reason: params[:adjustment_reason],
        entries: format_entries(params[:entries])
      }

      service = PurchasesV2::RepackagingService.new(repack_params, current_user)
      result = service.process!

      if result[:success]
        flash[:notice] = "✅ #{result[:message]}"
        render json: { success: true, redirect_url: purchases_v2_repackings_path }
      else
        render json: { success: false, message: result[:message] }
      end
    end

    def destroy
      @repacking = Repacking.find(params[:id])
      
      begin
        @repacking.undo!
        render json: { success: true, message: "Re-empaque anulado exitosamente. Las piezas han vuelto al lote original." }
      rescue => e
        render json: { success: false, message: e.message }
      end
    end

    private

    def format_entries(entries_params)
      # Convierte el hash de parámetros de la tabla en un array limpio
      return [] if entries_params.blank?
      
      entries_params.to_unsafe_h.map do |_, entry|
        entry = entry.with_indifferent_access
        {
          presentation_id: entry[:presentation_id].presence,
          qty: entry[:qty].to_f
        }
      end
    end
  end
end
