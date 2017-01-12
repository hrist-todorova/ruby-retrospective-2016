class Hash
  def fetch_deeper(curr, result)
    result = if result.is_a?(Array)
               result.fetch(curr.to_i)
             else
               result = result.fetch(curr.to_sym) { result.fetch(curr, nil) }
             end
  end

  def fetch_deep(path)
    current_hash = self
    path_keys_array = path.split('.')
    until path_keys_array.empty?
      current_key = path_keys_array.shift
      current_hash = fetch_deeper(current_key, current_hash)
      return nil if current_hash == nil
    end
    current_hash
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
end

