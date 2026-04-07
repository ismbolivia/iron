module SalesHelper
  def status_color_class(status)
    case status
    when Sale::PAYMENT_STATUSES[:paid]
      "btn-success"
    when Sale::PAYMENT_STATUSES[:quoted]
      "btn-dark-pink"
    when Sale::PAYMENT_STATUSES[:draft]
      "btn-dark-gray"
    when Sale::PAYMENT_STATUSES[:canceled]
      "btn-success"
    when Sale::PAYMENT_STATUSES[:to_annul]
      "btn-dark-red"
    when Sale::PAYMENT_STATUSES[:expired_pending_payment]
      "btn-custom-purple"
    when Sale::PAYMENT_STATUSES[:expired_partially_paid]
      "btn-danger"
    when Sale::PAYMENT_STATUSES[:partially_paid]
      "btn-warning"
    when Sale::PAYMENT_STATUSES[:pending_payment]
      "btn-info"
    when Sale::PAYMENT_STATUSES[:annulled]
      "btn-dark-purple"
    when Sale::PAYMENT_STATUSES[:observed]
      "btn-danger"
    else # Para cualquier otro estado
      "btn-default"
    end
  end

  def status_badge_html(status)
    badge_class_map = {
      "btn-success" => "label-success",
      "btn-dark-pink" => "label-dark-pink",
      "btn-dark-gray" => "label-dark-gray",
      "btn-dark-orange" => "label-dark-orange",
      "btn-dark-red" => "label-dark-red",
      "btn-dark-purple" => "label-dark-purple",
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
    status_normalized = status.to_s.parameterize.underscore
    "status-row-#{status_normalized}"
  end
end
