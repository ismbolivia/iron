module SalesHelper
  def status_color_class(status)
    case status
    when Sale::PAYMENT_STATUSES[:paid]
      "btn-success"
    when Sale::PAYMENT_STATUSES[:expired_pending_payment]
      "btn-custom-purple"
    when Sale::PAYMENT_STATUSES[:expired_partially_paid]
      "btn-danger"
    when Sale::PAYMENT_STATUSES[:partially_paid]
      "btn-warning"
    when Sale::PAYMENT_STATUSES[:pending_payment]
      "btn-info"
    when Sale::PAYMENT_STATUSES[:annulled], Sale::PAYMENT_STATUSES[:draft], Sale::PAYMENT_STATUSES[:to_annul], Sale::PAYMENT_STATUSES[:canceled]
      "btn-default"
    else # Para cualquier otro estado
      "btn-default"
    end
  end

  def status_badge_html(status)
    # Bootstrap 3 usa clases 'label' para los badges y los colores se aplican con 'label-success', 'label-warning', etc.
    badge_class_map = {
      "btn-success" => "label-success",
      "btn-danger" => "label-danger",
      "btn-warning" => "label-warning",
      "btn-info" => "label-info",
      "btn-custom-purple" => "badge-purple",
      "btn-default" => "label-default"
    }
    button_class = status_color_class(status)
    badge_class = badge_class_map[button_class] || "label-default"

    content_tag(:span, status, class: "label #{badge_class}")
  end

  def status_row_class(status)
    status_normalized = status.parameterize.underscore
    "status-row-#{status_normalized}"
  end
end
