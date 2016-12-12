class Gnosus::Client::Revenue

  def initialize(node)
    @node = node
  end

  def year
    @node.css('detail/year').text
  end

  def quarter
    @node.css('detail/qrt').text
  end

  def value
    @node.css('detail/fi_1510').text.to_f
  end

  def currency
    @node.css('detail/crcy_cd__kcode').text
  end

  def to_struct
    hash = {
      year:     year,
      quarter:  quarter,
      value:    value,
      currency: currency
    }
    Struct.new(*hash.keys).new(*hash.values)
  end

end
