class Hash
  def fetch_deep(path)
    key, lasting_path = path.split('.', 2)
    value = self[key.to_sym] || self[key.to_s]
    return value unless lasting_path
    value.fetch_deep(lasting_path) if value
  end

  def reshape(shape_hash)
    h = shape_hash.clone
    h.update(h) { |_, v| v.is_a?(String) ? fetch_deep(v) : reshape(v) }
  end
end

class Array
  def reshape(shape_hash)
    map! { |element| element.reshape(shape_hash) }
  end

  def fetch_deep(path)
    key, lasting_path = path.split('.', 2)
    element = self[key.to_i]
    element.fetch_deep(lasting_path) if element
  end
end
