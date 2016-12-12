class Gnosus::Client::RevenueCategory

  def initialize(node)
    @node = node
  end

  def year
    @node.css('detail/strt_dt').text
  end

  def name
    @node.css('detail/value_cd').text
  end

  def to_struct
    hash = {
      year:  year,
      name:  name,
    }
    Struct.new(*hash.keys).new(*hash.values)
  end

end
