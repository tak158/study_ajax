class CartsController < ApplicationController
  before_action :authenticate
  before_action :set_cart, only: [:show, :edit, :update, :destroy]

  def index
    @carts = Cart.list(current_customer.id)
    @total = Cart.total(current_customer.id)
  end

  def edit
  end

  def create
    @cart = Cart.new(cart_params)
    @cart.customer_id = current_customer.id

    if @cart.save
      redirect_to carts_url
    else
      render action: "new"
    end
  end

  def update
    if @cart.update_attributes(cart_params)
      redirect_to carts_url
     else
      render action: "edit"
    end
  end

  def destroy
     @cart.destroy
    redirect_to carts_url
  end

  def order
    Cart.checkout(current_customer.id)
    redirect_to thanks_carts_path
  end

  def create_and
    if session[:cart_entry]
      cart_params = session[:cart_entry]
      cart_params.permit!
      cart_params[:customer_id] = current_customer.id

      cart = Cart.new(cart_params)
      cart.save
      session[:cart_entry] = nil
    end
    redirect_to carts_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cart
      @cart = Cart.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cart_params
      params.require(:cart).permit(:book_id, :customer_id, :quantity)
    end

    def authenticate
      session[:cart_entry] = params[:cart]  if !customer_signed_in? && params[:cart]
      authenticate_customer!
    end
end
