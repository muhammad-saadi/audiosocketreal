class ConsumerLicenseService
  def self.consumer_licenser(current_consumer, track)
    sub_type = current_consumer.subscription_type
    license = track.licenses.find_by(subscription: sub_type)
    consumer_license_html = license.license_html
    dynamic_license_hash(current_consumer, track).each do |k, v|
      consumer_license_html.gsub!(k, v)
    end

    consumer_license = current_consumer.consumer_licenses.new(consumer_price: Track::TEMP_PRICE, consumer: current_consumer, license: license, consumer_license_html: consumer_license_html, track_id: track.id)

    pdf = WickedPdf.new.pdf_from_string(consumer_license.consumer_license_html)
    consumer_license.license_pdf.attach(io: StringIO.new(pdf), filename: "license.pdf", content_type: "application/pdf")
    
    consumer_license
  end

  private

  def self.dynamic_license_hash(consumer, track)
    {
      "{replace_with_business_name}" => consumer.full_name.to_s,
      "{replace_with_licensee_name}" => consumer.full_name.to_s,
      "{replace_with_licensee_email}" => consumer.email.to_s,
      "{replace_with_basket_item_id}" => track.id.to_s,
      #"{replace_with_entity_type}" => "nil",
      #"{replace_with_project_name}" => "nil",
      "{replace_with_licensed_item}" => track.title.to_s,
      "{replace_with_date}" => Date.today.to_s,
      #"{replace_with_license_term}" => "nil",
      #"{replace_with_license_territory}" => "nil" ,
      "{replace_with_license_price}" => Track::TEMP_PRICE.to_s
    }
  end
end
