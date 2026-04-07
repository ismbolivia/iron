class AccountTransfer < ApplicationRecord
  belongs_to :from_account, class_name: "Account", optional: true
  belongs_to :to_account, class_name: "Account", optional: true
  belongs_to :from_box, class_name: "Box", optional: true
  belongs_to :to_box, class_name: "Box", optional: true
  belongs_to :user, optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :validate_origin_and_destination
  validate :validate_different_nodes
  validate :validate_sufficient_funds, on: :create

  after_create :create_box_details

  private

  def validate_origin_and_destination
    if from_account_id.blank? && from_box_id.blank?
      errors.add(:base, "Debe especificar una Cuenta o Caja de origen")
    end
    if to_account_id.blank? && to_box_id.blank?
      errors.add(:base, "Debe especificar una Cuenta o Caja de destino")
    end
  end

  def validate_different_nodes
    if from_account_id.present? && from_account_id == to_account_id
      errors.add(:to_account_id, "No se puede transferir a la misma cuenta de origen")
    end
    if from_box_id.present? && from_box_id == to_box_id
      errors.add(:to_box_id, "No se puede transferir a la misma caja de origen")
    end
  end

  def validate_sufficient_funds
    return unless amount.present?

    saldo_actual = 0.0
    if from_account_id.present?
      saldo_actual = from_account.total.to_f
    elsif from_box_id.present?
      saldo_actual = from_box.saldo.to_f
    end

    if amount.to_f.round(2) > saldo_actual.round(2)
      errors.add(:amount, "Fondos insuficientes. Saldo actual: $ #{'%.2f' % saldo_actual}")
    end
  end

  def create_box_details
    if from_box_id.present?
      BoxDetail.create!(
        box_id: from_box_id,
        amount: amount,
        state: :output,
        reason: "Rendición de Cobros a #{to_account_id ? 'Cuenta' : 'Caja'}"
      )
    end
    if to_box_id.present?
      BoxDetail.create!(
        box_id: to_box_id,
        amount: amount,
        state: :input,
        reason: "Rendición Recibida de #{from_account_id ? 'Cuenta' : 'Caja'}"
      )
    end
  end
end
