require 'open-uri'

class Gnosus::Downloader

  API_WID = '102354789910'
  API_WIC = '64948242'
  API_URL_TEMPLATE = "https://magnusweb.bisnode.cz/udss/main/kiwi?wid=#{API_WID}&wic=#{API_WIC}&wia=xml_tree&ent_id=i%{ic}&s__country=%{country}&s__tag=test"
  PROXY = 'http://stg.enrian.com:4444'
  TIMEOUT = 30

  def initialize(ic, locale)
    @ic = ic
    @locale = locale.to_s
    @country = {"cs" => "CZ", "sk" => "SR"}[@locale.downcase] # CZ or SR
    @api_url = format(API_URL_TEMPLATE, ic: @ic, country: @country)
  end

  def valid?
    validate_xml
  rescue Gnosus::LookupError
    false
  end

  def xpath(query)
    validate_xml && xml_doc.xpath(query)
  end

  def xml
    @xml ||= download_xml
  end

  protected

  def download_xml
    cache = InterfaceCache.gnosus.where(ic: @ic).first_or_initialize
    unless cache.source
      cache.source ||= Timeout.timeout(TIMEOUT) { open(@api_url, proxy: PROXY).read }
      cache.save!
    end
    cache.source
  rescue OpenURI::HTTPError => exc
    raise Gnosus::LookupError, "Remote failure: " + exc.message
  rescue Timeout::Error => exc
    raise Gnosus::LookupError, "Request timed out!"
  end

  def validate_xml
    unless @valid_xml
      node = xml_doc.xpath("//node[field_name='0.STB0A001']")[0]
      unless node && @ic == node.css("detail/value_txt").text
        raise Gnosus::LookupError, "Failed Gnosus lookup for '#{@ic}'"
      end
    end
    @valid_xml = true
  end

  private

  def xml_doc
    @xml_doc ||= Nokogiri::XML.parse(xml)
  end

end
