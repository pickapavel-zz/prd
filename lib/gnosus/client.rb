class Gnosus::Client

  attr_reader :ic, :country

  delegate :valid?, to: :data

  def initialize(ic, locale)
    @ic = ic.to_s
    @locale = locale.to_s
    @country1 = {"cs" => "CZ", "sk" => "SK"}[@locale.downcase] # CZ or SK
    @country2 = {"cs" => "CZ", "sk" => "SR"}[@locale.downcase] # CZ or SR
  end

  def dic
    @dic ||= data.xpath("//node[field_name='0.STB0A002']/detail/value_txt")[0].try(:text)
  end

  # Název subjektu (F7)
  def name
    @name ||= data.xpath("//node[field_name='0.STA0A0A001']/detail/value_txt")[0].try(:text).presence || data.xpath("//body/tree/head/entity_info/text").try(:text)
  end

  def surname
  end

  def title
    @title ||= data.xpath("//node[field_name='0.STA0A0A001']/detail/value_txt")[0].try(:text).presence
  end

  def condition
  end

  def core_business
    @core_business ||= data.xpath("//node[field_name='0.KEA0AC06#{@country1}00']/detail/value_cd")[0].try(:text)
  end

  def registration_date
  end

  def segment
  end

  def hard_ko_criteria
  end

  def soft_ko_criteria
  end

  def address
    @address ||= begin
      street = data.xpath("//node[field_name='0.ADA001']/detail/street_txt")[0].try(:text)
      city = data.xpath("//node[field_name='0.ADA001']/detail/city_txt")[0].try(:text)
      [ street, city ].join(", ")
    end
  end

  def street
    data.xpath("//node[field_name='0.ADA001']/detail/street_txt")[0].try(:text)
  end

  def city
    data.xpath("//node[field_name='0.ADA001']/detail/city_txt")[0].try(:text)
  end

  def country
    data.xpath("//node[field_name='0.ADA001']/detail/state_txt")[0].try(:text)
  end

  def zip
    data.xpath("//node[field_name='0.ADA001']/detail/pc_txt")[0].try(:text)
  end

  # Webové stránky (F53)
  def url
    @url ||= data.xpath("//node[field_name='0.STC0A005']/detail/value_txt")[0].try(:text)
  end

  # Předmět podnikání (F57) - Kód
  def subject_code
    @subject_code ||= data.xpath("//node[field_name='0.KEA0AC06#{@country1}00']/detail/value_cd__kshort")[0].try(:text)
  end

  # Předmět podnikání (F58) - Popis
  def subject
    @subject ||= data.xpath("//node[field_name='0.KEA0AC06#{@country1}00']/detail/value_cd")[0].try(:text)
  end

  def core_business
    @core_business ||= data.xpath("//node[field_name='0.KEA0AC06#{@country1}00']/detail/value_cd")[0].try(:text)
  end

  # IČO (F10)
  def ic
    @ic ||= data.xpath("//node[field_name ='0.STB0A001']/detail/value_txt")[0].try(:text)
  end

  # Typ klienta (F13)
  def client_type
    @type ||= data.xpath("//entity_info/type_cd")[0].try(:text)
  end

  # Právní forma (F56)
  def legal_form
    legal_code = data.xpath("//node[field_name ='0.KEA002']/detail/value_cd__kcode")[0].try(:text).presence || data.xpath("//node[field_name ='0.KEA0S2']/detail/value_cd__kcode")[0].try(:text)
    @form ||= (@locale == "cs" ? "KEA002XO#{legal_code}" : "KEA0S2XO#{legal_code}")
  end

  # NegEquity
  def negative_equity
    data.xpath("//node[field_name='0.MIA0D001']").each do |node|
      next unless node.css('detail/type_cd').text == "Záporné vlastní jmění"
      date = last_financial_statement_start_date
      return true if parse_date(node.css('detail/end_dt').text).year == date.year && date.year >= Date.today.year - 2
    end
    false
  end

  # Změna sídla (F51)
  def address_changed_last_six_months
    if node = data.xpath("//node[field_name='0.ADA001']")[0]
      strt_dt = parse_date(node.css('detail/strt_dt').text)
      return false if strt_dt.nil?
      return false unless strt_dt > six_months_ago && strt_dt > establishing_tolerance
    end
    node.present?
  end

  # Address 2Y
  def address_changed_last_two_years
    if node = data.xpath("//node[field_name='0.ADA001']")[0]
      strt_dt = parse_date(node.css('detail/strt_dt').text)
      return false if strt_dt.nil?
      return false unless strt_dt > two_years_ago && strt_dt > establishing_tolerance
    end
    node.present?
  end

  # Změna hlavního předmětu podnikání (F54)
  def business_subject_changed_last_year
    if node = data.xpath("//node[field_name='0.KEA0AC06#{@country1}00']")[0]
      strt_dt = parse_date(node.css('detail/strt_dt').text)
      return false if strt_dt.nil?
      return false unless strt_dt > year_ago && strt_dt > establishing_tolerance
    end
    node.present?
  end

  # Business Activity 2Y
  def business_subject_changed_last_two_years
    if node = data.xpath("//node[field_name='0.KEA0AC06#{@country1}00']")[0]
      strt_dt = parse_date(node.css('detail/strt_dt').text)
      return false if strt_dt.nil?
      return false unless strt_dt > two_years_ago && strt_dt > establishing_tolerance
    end
    node.present?
  end

  # Name
  def name_changed_last_two_years
    if node = data.xpath("//node[field_name='0.STA0A0A001']")[0]
      strt_dt = parse_date(node.css('detail/strt_dt').text)
      return false if strt_dt.nil?
      return false unless strt_dt > two_years_ago && strt_dt > establishing_tolerance
    end
    node.present?
  end

  # Debts to "Sociálna nebo zdravotná poisťovňa"
  def debt_at_insurance_company
    data.xpath("//node[field_name='0.MIA0D001']").each do |node|
      next if node.css('detail/type_cd').text != "Pohledávka"
      next if node.css('inac_ind').text != '00'

      text = node.css('detail/prnt_id__i0').text.downcase
      return true if text.include?('poisťovňa') || text.include?('pojišťovna')
    end
    false
  end

  # Žádné závazky po splatnosti (F87)
  def no_active_debt
    data.xpath("//node[field_name='0.MIA0D001']").each do |node|
      next if node.css('detail/type_cd').text != "Pohledávka"
      return false if node.css('inac_ind').text == '00'
    end
    true
  end

  # Žádné závazky po splatnosti (F87) - reversed
  def active_debt
    data.xpath("//node[field_name='0.MIA0D001']").each do |node|
      next if node.css('detail/type_cd').text != "Pohledávka"
      return true if node.css('inac_ind').text == '00'
    end
    false
  end

  def owners_change_rate_last_six_months
    relevant_owners = {}
    data.xpath("//node[field_name='1.REAA03']").each do |node|
      end_dt = parse_date(node.css('detail/end_dt').text)
      if end_dt && end_dt > six_months_ago
        name = node.css('detail/prnt_id').text.strip
        relevant_owners[name] ||= { max: 0 }
        share = node.css('detail/value_pct').text.blank? ? 0 : node.css('detail/value_pct').text.to_i
        relevant_owners[name][:max] = [share, relevant_owners[name][:max]].max
      end
    end
    sum = 0
    relevant_owners.each do |name, owner|
      owner[:actual] = owner_actual_share(name)
      sum += owner[:max] - owner[:actual] if owner[:max] > owner[:actual]
    end
    sum = sum.to_f / 100
    sum > 1 ? 1.0 : sum > 0.5
  end

  # Vlast (Ownership) 2Y
  def owners_change_rate_last_two_years
    relevant_owners = {}
    data.xpath("//node[field_name='1.REAA03']").each do |node|
      end_dt = parse_date(node.css('detail/end_dt').text)
      if end_dt && end_dt > two_years_ago
        name = node.css('detail/prnt_id').text.strip
        relevant_owners[name] ||= { max: 0 }
        share = node.css('detail/value_pct').text.blank? ? 0 : node.css('detail/value_pct').text.to_i
        relevant_owners[name][:max] = [share, relevant_owners[name][:max]].max
      end
    end
    sum = 0
    relevant_owners.each do |name, owner|
      owner[:actual] = owner_actual_share(name)
      sum += owner[:max] - owner[:actual] if owner[:max] > owner[:actual]
    end
    sum = sum.to_f / 100
    sum > 1 ? 1.0 : sum > 0.5 # Not 100% sure about value of condition
  end

  def corporates_change_rate_last_six_months
    active = {}
    historical = []
    data.xpath("//node[field_name='0.REAA01']").each do |node|
      if node.css('inac_ind').text == '00'
        active[node.css('detail/chld_id').text.strip] = parse_date(node.css('detail/strt_dt').text)
      elsif node.css('detail/end_dt').text.present? && parse_date(node.css('detail/end_dt').text) > six_months_ago
        historical << node.css('detail/chld_id').text.strip
      end
    end
    # filter names which are present in both collections
    active.reject! { |name, _| historical.delete(name) }
    if historical.size > 0
      return true
    elsif active.size > 0
      active.each { |_, strt_dt| return true if strt_dt.present? && strt_dt > six_months_ago }
    end
    false
  end

  # Statutary 2Yex
  def corporates_change_rate_last_two_years
    active = {}
    historical = []
    data.xpath("//node[field_name='0.REAA01']").each do |node|
      if node.css('inac_ind').text == '00'
        active[node.css('detail/chld_id').text.strip] = parse_date(node.css('detail/strt_dt').text)
      elsif node.css('detail/end_dt').text.present? && parse_date(node.css('detail/end_dt').text) > two_years_ago
        historical << node.css('detail/chld_id').text.strip
      end
    end
    # filter names which are present in both collections
    active.reject! { |name, _| historical.delete(name) }
    if historical.size > 0
      return true
    elsif active.size > 0
      active.each { |_, strt_dt| return true if strt_dt.present? && strt_dt > two_years_ago }
    end
    false
  end

  # Změna vlastníků nebo statutárů (F52) - Statutary
  def change_rate_last_six_months
    owners_change_rate_last_six_months || corporates_change_rate_last_six_months
  end

  # Likvidace u ESS (F45)
  def liquidation_last_two_years
    liquidation_last_two_years_client || liquidation_last_two_years_ess_member
  end

  # Exekuce u ESS (F46)
  def execution_last_two_years
    execution_last_two_years_client || execution_last_two_years_ess_member
  end

  # Insolvence u ESS (F47)
  def insolvence_last_two_years
    insolvence_last_two_years_client || insolvence_last_two_years_ess_member
  end

  # Klient bez aktuálního neg. stavu (F44)
  def negative_state
    active_execution || active_liquidation || active_insolvence
  end

  # Klient s historickou exekucí (F49)
  def execution_last_year
    data.xpath("//node[field_name='0.MIA0D001']").each do |node|
      next unless ['Exekuce', 'Zapsaná exekuce'].include?(node.css('detail/type_cd').text)
      end_dt = parse_date(node.css('detail/end_dt').text)
      return true if end_dt.nil? || end_dt > year_ago
    end
    false
  end

  # DPH
  def bad_tax_payer
    data.xpath("//node[field_name='0.MIA0D001']").each do |node|
      next unless ['Nespolehlivost v DPH'].include?(node.css('detail/type_cd').text)
      return true if node.css('inac_ind').text == '00'
    end
    false
  end

  # Vlastníci a jejich podíl
  def relevant_owners
    owners = {}
    data.xpath("//node[field_name='1.REAA03']").each do |node|
      if node.css('detail/end_dt').text.blank?
        name = node.css('detail/prnt_id').text.strip
        toe_id = node.css('toe_id').text
        owners[name] = {}
        owners[name]['share'] = owner_actual_share(name)
        owners[name]['birth_date'] = birth_date(toe_id)
      end
    end
    owners.sort_by { |_k, v| v['share'] }.reverse
  end

  # Vlastníci s min. 67% podílem
  def relevant_owners_with_majority_share
    majority_owners = []
    relevant_owners.inject(0) do |sum, owner|
      if sum.to_i < 66
        sum += owner.last['share'].to_i
        majority_owners << {  name: owner.first,
                              share: owner.last['share'],
                              birth_date: owner.last['birth_date'] }
      end
      sum
    end
    majority_owners
  end

  # Počet vlastníků s min. 67% podílem (F814)
  def owners_count_with_majority_share
    count = 0
    owners_with_share.sort.reverse.inject(0) do |sum, owner_share|
      if sum.to_i < 66
        sum += owner_share
        count += 1
      end
      sum
    end
    count
  end

  def corporates
    data.xpath("//node[field_name='0.REAA01']").select do |node|
      node.css('detail/end_dt').text.blank?
    end
  end

  def corporates_count
    corporates.size
  end

  def relevant_corporates
    corporates = []
    data.xpath("//node[field_name='0.REAA01']").select do |node|
      if node.css('detail/end_dt').text.blank?
        corporates << node.css('detail/chld_id').text.strip
      end
    end
    corporates
  end

  def relevant_corporates_without_share
    corporates = []
    data.xpath("//node[field_name='0.REAA01']").select do |node|
      if node.css('detail/end_dt').text.blank?
        name = node.css('detail/chld_id').text.strip
        corporates << name if owner_actual_share(name).zero?
      end
    end
    corporates
  end

  def relevant_corporates_without_share_count
    relevant_corporates_without_share.size
  end

  def revenue_t
    revenues[0].try(:value)
  end

  def revenue_t_1
    revenues[1].try(:value)
  end

  # ics of related subjects
  def related_subject_ics
    related_subjects.map(&:ic)
  end

  # names of related subjects
  def related_subject_names
    related_subjects.map(&:name)
  end

  # Should've contain all methods for ESS členové (F48)
  def related_subjects
    @related_subjects ||= data.xpath("//node[field_name='0.MIA0ESUB02']").sort_by{|node| node.css('detail/to_id__i-1').text}.map { |node| RelatedSubject.new(node) }
  end

  def revenues
    @revenues ||= data.xpath("//node[field_name='0.FV0601']").map { |node| Gnosus::Client::Revenue.new(node) }
  end

  def revenue_categories
    @revenue_categories ||= data.xpath("//node[field_name='0.KEA01C']").map { |node| Gnosus::Client::RevenueCategory.new(node) }
  end

  def revenue_capitals
    @revenue_capitals ||= data.xpath("//node[field_name='0.FV0601']").map { |node| Gnosus::Client::RevenueCapital.new(node) }
  end

  def last_financial_statement_start_date
    if node = data.xpath("//node[field_name='0.FV0601']")[0]
      return Date.parse(node.css('detail/strt_dt').text)
    end
  end

  def last_but_one_financial_statement_start_date
    if node = data.xpath("//node[field_name='0.FV0601']")[1]
      return Date.parse(node.css('detail/strt_dt').text)
    end
  end

  def consecutive_financial_statements
    last = last_financial_statement_start_date
    following = last_but_one_financial_statement_start_date
    return false if last.blank? || following.blank?
    (last.year.to_i - 1).to_s == following.year.to_s
  end

  # Datum vzniku (F86)
  def established_on
    if node = data.xpath("//node[field_name='0.DAA0A001']")[0]
      Date.parse(node.css('detail/value_dt').text)
    end
  end

  # KO criterium R113
  def before_eleven_months_of_this_year
    year = Date.today.year
    established_on > 11.months.ago.to_date
  end

  def expires_on
    if node = data.xpath("//node[field_name='0.DAA0A002']")[0]
      Date.parse(node.css('detail/value_dt').text)
    end
  end

  def is_expired
    expires_on.present?
  end

  def to_struct
    hash = {}
    [
      :dic,
      :name,
      :address,
      :url,
      :subject,
      :subject_code,
      :ic,
      :client_type,
      :legal_form,
      :negative_equity,
      :negative_state,
      :address_changed_last_six_months,
      :address_changed_last_two_years,
      :business_subject_changed_last_year,
      :business_subject_changed_last_two_years,
      :name_changed_last_two_years,
      :debt_at_insurance_company,
      :owners_change_rate_last_six_months,
      :owners_change_rate_last_two_years,
      :corporates_change_rate_last_six_months,
      :corporates_change_rate_last_two_years,
      :change_rate_last_six_months,
      :no_active_debt,
      :active_debt,
      :insolvence_last_two_years,
      :liquidation_last_two_years,
      :execution_last_year,
      :execution_last_two_years,
      :revenue_t_1,
      :revenue_t,
      :bad_tax_payer,
      :owners_count_with_majority_share,
      :corporates_count,
      :last_financial_statement_start_date,
      :last_but_one_financial_statement_start_date,
      :established_on,
      :before_eleven_months_of_this_year,
      :expires_on,
      :is_expired,
      :relevant_corporates,
      :relevant_corporates_without_share,
      :relevant_corporates_without_share_count,
      :relevant_owners_with_majority_share
    ].each do |name|
      hash[name] = send(name)
    end
    [
      :related_subjects,
      :revenues,
      :revenue_categories,
      :revenue_capitals,
    ].each do |name|
      hash[name] = send(name).map(&:to_struct)
    end
    Struct.new(*hash.keys).new(*hash.values)
  end

  def xml
    data.xml
  end

  def json
    Hash.from_xml(data.xml).as_json
  end

  private

  def data
    @downloader ||= begin
      raise Gnosus::InvalidArguments, "Invalid IC: #{@ic}" if @ic !~ /\A\d{6,10}\z/
      raise Gnosus::InvalidArguments, "Invalid locale: #{@locale} (must be in [cs, sk])" unless %w(cs sk).include?(@locale.to_s)

      Gnosus::Downloader.new(@ic, @locale)
    end
  end

  def two_years_ago
    @two_years_ago ||= Date.today - 2.years
  end

  def year_ago
    @year_ago ||= Date.today - 1.year
  end

  def six_months_ago
    @six_months_ago ||= Date.today - 6.months
  end

  def parse_date(date_string)
    return nil if date_string.blank?
    date_string += '0101' if date_string.size == 4
    date_string += '01' if date_string.size == 6
    Date.parse(date_string)
  end

  def owners_with_share
    data.xpath("//node[field_name='1.REAA03']").map do |node|
      node.css('detail/value_pct').text.to_i if node.css('detail/end_dt').text.blank? && node.css('detail/value_pct').text.to_i > 0
    end.compact
  end

  def active_insolvence
    data.xpath("//node[field_name='0.MIA0D001']").any? do |node|
      next unless ['Platební neschopnost', 'Úpadek', 'Zánik'].include?(node.css('detail/type_cd').text)
      node.css('inac_ind').text == "00"
    end
  end

  def active_liquidation
    data.xpath("//node[field_name='0.MIA0D001']").any? do |node|
      next unless ['Likvidace'].include?(node.css('detail/type_cd').text)
      node.css('inac_ind').text == "00"
    end
  end

  def active_execution
    data.xpath("//node[field_name='0.MIA0D001']").any? do |node|
      next unless ['Exekuce', 'Zapsaná exekuce'].include?(node.css('detail/type_cd').text)
      node.css('inac_ind').text == "00"
    end
  end

  # 2YIns

  def insolvence_last_two_years_client
    data.xpath("//node[field_name='0.MIA0D001']").each do |node|
      next unless ['Platební neschopnost', 'Úpadek', 'Likvidace'].include?(node.css('detail/type_cd').text)
      end_dt = parse_date(node.css('end_dt').text)
      return true if end_dt.nil? || end_dt > two_years_ago
    end
    false
  end

  # 2YLikv

  def liquidation_last_two_years_client
    data.xpath("//node[field_name='0.MIA0D001']").each do |node|
      next unless 'Likvidace' == node.css('type_cd').text
      end_dt = parse_date(node.css('end_dt').text)
      return true if end_dt.nil? || end_dt > two_years_ago
    end
    false
  end

  # 2YEx

  def execution_last_two_years_client
    data.xpath("//node[field_name='0.MIA0D001']").each do |node|
      next unless ['Exekuce', 'Zapsaná exekuce'].include?(node.css('detail/type_cd').text)
      end_dt = parse_date(node.css('detail/end_dt').text)
      return true if end_dt.nil? || end_dt > two_years_ago
    end
    false
  end

  # 2YIns ESS

  def insolvence_last_two_years_ess_member
    data.xpath("//node[field_name='0.MIA0ESUB02']").each do |node|
      return true unless node.css('detail/insolvence').text.blank?
    end
    false
  end

  # 2YLikv ESS

  def liquidation_last_two_years_ess_member
    data.xpath("//node[field_name='0.MIA0ESUB02']").each do |node|
      return true unless node.css('detail/likvidace').text.blank?
    end
    false
  end

  # 2YEx ESS

  def execution_last_two_years_ess_member
    data.xpath("//node[field_name='0.MIA0ESUB02']").each do |node|
      return true unless node.css('detail/exekuce').text.blank?
      return true unless node.css('detail/zapsane_exekuce').text.blank?
    end
    false
  end

  def establishing_tolerance
    if node = data.xpath("//node[field_name='0.DAA0A001']")[0]
      return Date.parse(node.css('detail/value_dt').text) + 1.month
    end
    Date.today
  end

  def owner_actual_share(name)
    data.xpath("//node[field_name='1.REAA03']").each do |node|
      if node.css('detail/end_dt').text.blank? && node.css('detail/prnt_id').text.strip == name
        return node.css('detail/value_pct').text.to_i
      end
    end
    0
  end

  def birth_date(toe_id)
    data.xpath("//node[field_name='0.MIA0ESUB02']").each do |node|
      if node.css('to_id__i4').text.strip == toe_id
        return node.css('value_dt').text
      end
    end
    ''
  end
end
