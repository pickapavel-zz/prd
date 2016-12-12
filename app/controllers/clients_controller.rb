class ClientsController < ApplicationController

  before_action :load_client, except: [:index, :new, :create, :pup, :test_response]

  def index
    @clients = Client.joins(:collaborations).where("collaborations.collaborator_id = ?", current_user.id)
  end

  def new
    @client = Client.new
  end

  # finds an existing client with given ID or creates new Client
  def create
    @client = Client.where(client_ic).first
    if @client
      @client.update_attributes(client_params)
      @client.collaborators = (@client.collaborators + [current_user]).uniq
      redirect_to @client
    else
      @client = current_user.clients.build(client_ic)
      save_client(@client)
    end
  end

  # for demo purpose, if client's segment is "corporation", it returns error
  def show
    if @client.corporation?
      flash[:error] = t('clients.show.corporation')
    end
  end

  def update
    save_client(@client)
  end

  # add Economically related group
  def add_partner
    @partner = Client.where(ic: partner_ic).first || current_user.clients.build(ic: partner_ic)
    if @partner.save
      @client.partners = (@client.partners + [@partner]).uniq
      flash[:notice] = t("clients.add_partner.partner_added")
    else
      flash[:error] = t("clients.add_partner.partner_not_added")
    end
    redirect_to @client
  end

  # remove Economically related group
  def remove_partner
    @partnership = @client.partnerships.where(partner_id: params[:partner_id])
    if @partnership.destroy_all
      flash[:notice] = t("clients.remove_partner.partner_removed")
    else
      flash[:error] = t("clients.remove_partner.partner_not_removed")
    end
    redirect_to @client
  end

  def add_collaborator
    @user = User.find_by_email(params[:client][:user_email])
    if @user
      @client.collaborators = (@client.collaborators + [@user]).uniq
      @message = t("clients.add_collaborator.collaborator_added")
    else
      @message = t("clients.add_collaborator.collaborator_not_found")
    end
  end

  # only for test purpose to view complete Gnosus json response
  def test_response
    render json: Gnosus::Client.new("31709401", "sk").json
  end

  def pup
    @client = Client.first
  end

  private
  def client_ic
    params.require(:client).permit(:ic)
  end

  def partner_ic
    params.require(:client)[:partner_ic]
  end

  def client_params
    params.require(:client)[:segment_type] = 'small' if params.require(:client)[:ic] == "31709401"
    params.require(:client)[:segment_type] = 'corporation' if params.require(:client)[:ic] == "35926856"
    params.require(:client).permit(:name, :street, :city, :country, :zip, :surname, :legal_form, :title,
                                   :condition, :core_business, :registration_date, :record_id,
                                   :segment, :hard_ko_criteria, :soft_ko_criteria, :data_source,
                                   :consolidated, :last_updated, :non_customer, :segment_type)
  end

  def load_client
    @client = Client.find(params[:id])
  end

  # assign attributes and save client
  def save_client(client)
    client.attributes = client_params
    if client.save
      @client.collaborators = (@client.collaborators + [current_user]).uniq
      flash[:notice] = t("updated")
      redirect_to client
    else
      render :new
    end
  end

end
