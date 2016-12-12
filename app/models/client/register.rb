class Client::Register

  GET_ID_URL = 'http://www.registeruz.sk/cruz-public/api/uctovne-jednotky'
  GET_DETAIL_URL = 'http://www.registeruz.sk/cruz-public/api/uctovna-jednotka'

  def initialize(ic)
    @ic = ic
  end

  def name
    parsed_response['nazovUJ']
  end

  def city
    parsed_response['mesto']
  end

  def data_source
    parsed_response['zdrojDat']
  end

  def consolidated
    parsed_response['konsolidovana']
  end

  def last_updated
    parsed_response['datumPoslednejUpravy']
  end

  def record_id
    parsed_response["id"]
  end

  private

  def parsed_response
    cache = InterfaceCache.register.where(ic: @ic).first_or_initialize

    if cache.new_record?
      cache.source = fresh_source
      cache.save!
    end
    cache.source ? parse(cache.source).with_indifferent_access : {}
  end

  def fresh_source
    # TODO: there should be a different class that does the download job
    params = { "zmenene-od" => "1990-01-01", "ico" => @ic }
    response = RestClient.get(GET_ID_URL, params: params)
    id = JSON.parse(response.body)['id'].first rescue nil

    RestClient.get(GET_DETAIL_URL, params: { "id" => id }).body rescue nil
  end

  def parse(data)
    JSON.parse(data) if data
  end
end
