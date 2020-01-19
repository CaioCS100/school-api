module ErrorSerializer

  def ErrorSerializer.serialize(errors)
    return if errors.nil?

    json = {}
    new_hash = errors.to_hash(true).map do |key, value|
      value.map do |msg|
        { id: key, detail: msg }
      end
    end.flatten

    json[:errors] = new_hash
    json
  end
end
