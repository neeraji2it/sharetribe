class OrdersController < ApplicationController
    
    def index
        @listing = Listing.find(params[:listing_id])
		    @orders= Order.all
	end


def express
  response = EXPRESS_GATEWAY.setup_purchase(current_cart.build_order.price_in_cents,
    :ip                => request.remote_ip,
    :return_url        => new_order_url,
    :cancel_return_url => products_url
  )
  redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
end

def new
  @listing = Listing.find(params[:listing_id])
  @order = Order.new(:express_token => params[:token])
end



def create
  @listing = Listing.find(params[:listing_id])
  @order= Order.new(order_params.merge(:listing_id => @listing.id))
    #@orders.listing_id = @listing.id
 #@order.ip_address = request.remote_ip
  if @order.save && @order.purchase
      UserMailer.welcome_email(@order).deliver!
      render :action => "success"
  else
    render :action => 'new'
  end
end

	def update
		@order= Order.find(params[:id])
        if @order.update(order_params)
        	redurect_to root_path
        else
        	render"edit"
        end
    end

  def edit
    	@order= Order.find(params[:id])
  end


    def show
    	@order= Order.find(params[:id])
    end

    def destroy
    	@order= Order.find(params[:id])
    	@order.destroy
    	redirect_to root_path
    end

    def order_params
    	params.require(:order).permit!
    end

  def purchase
  response = process_purchase
  transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
  cart.update_attribute(:purchased_at, Time.now) if response.success?
  response.success?
end

def express_token=(token)
  write_attribute(:express_token, token)
  if new_record? && !token.blank?
    details = EXPRESS_GATEWAY.details_for(token)
    self.express_payer_id = details.payer_id
    self.firstname = details.params["firstname"]
    self.lastname = details.params["lastname"]
  end
end

private

def process_purchase
  if express_token.blank?
    STANDARD_GATEWAY.purchase(price_in_cents, credit_card, standard_purchase_options)
  else
    EXPRESS_GATEWAY.purchase(price_in_cents, express_purchase_options)
  end
end

def standard_purchase_options
  {
    :ip => ip_address,
    :billing_address => {
      :name     => "Ryan Bates",
      :address1 => "123 Main St.",
      :city     => "New York",
      :state    => "NY",
      :country  => "US",
      :zip      => "10001"
    }
  }
end

def express_purchase_options
  {
    :ip => ip_address,
    :token => express_token,
    :payer_id => express_payer_id
  }
end

def validate_card
  if express_token.blank? && !credit_card.valid?
    credit_card.errors.full_messages.each do |message|
      errors.add_to_base message
    end
  end
end

end
