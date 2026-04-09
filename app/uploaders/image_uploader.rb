class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path('default_image.jpg')
  end

  # Procesamiento: Asegura transparencia y optimización WebP
  process :catalog_refine
  process resize_to_fit: [600, 600]

  version :thumb do
    process resize_to_fit: [90, 90]
  end
  version :midium do
    process resize_to_fit: [300, 300]
  end
  version :large do
    process resize_to_fit: [600, 600]
  end

  def catalog_refine
    manipulate! do |img|
      img.format("webp") do |c|
        c.background "none"
        c.alpha "on"
        c.quality "100"
        c.define "webp:lossless=true"
      end
      img
    end
  end

  # Utilidad opcional para recorte manual del servidor si fuera necesario
  def trim
    manipulate! do |img|
      img.format "webp"
      img.combine_options do |c|
        c.trim
        c.repage "+0+0"
        c.quality "100"
      end
      img
    end
  end

  def extension_allowlist
    %w(jpg jpeg gif png webp avif)
  end
end
