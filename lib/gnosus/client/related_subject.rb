class Gnosus::Client::RelatedSubject

  def initialize(node)
    @node = node
  end

  def name
    @node.css('detail/to_id__i-1').text
  end

  def ic
    @node.css('detail/to_id__i4').text
  end

  def active?
    @node.css('inac_ind').text == "00"
  end

  def level
    @node.css('detail/lvl').text.to_i
  end

  def insolvence?
    negative_event?('insolvence')
  end

  def insolvence_active?
    negative_event_active?('insolvence')
  end

  def liquidation?
    negative_event?('likvidace')
  end

  def liquidation_active?
    negative_event_active?('likvidace')
  end

  def bankruptcy?
    negative_event?('upadky')
  end

  def bankruptcy_active?
    negative_event_active?('upadky')
  end

  def expiration?
    negative_event?('zaniky')
  end

  def expiration_active?
    negative_event_active?('zaniky')
  end

  def distraint?
    @node.css('detail/exekuce').text.present? || @node.css('detail/zapsane_exekuce').text.present?
  end

  def to_struct
    hash = {}
    [
      :name,
      :ic,
      :active?,
      :level,
      :insolvence?,
      :insolvence_active?,
      :liquidation?,
      :liquidation_active?,
      :bankruptcy?,
      :bankruptcy_active?,
      :expiration?,
      :expiration_active?,
      :distraint?
    ].each do |name|
      hash[name] = send(name)
    end
    Struct.new(*hash.keys).new(*hash.values)
  end

  private

  # active or historical
  def negative_event?(name)
    ne = get_negative_event_for(name)
    ne[0] || ne[1]
  end

  # only active
  def negative_event_active?(name)
    get_negative_event_for(name)[0]
  end

  def get_negative_event_for(name)
    txt = @node.css("detail/#{name}").text
    if txt.present?
      active, historical = txt.split('-')
      [active.to_i > 0, historical.to_i > 0]
    else
      [false, false]
    end
  end

end
