require 'httparty'
class OrdersController < ApplicationController
  include HTTParty
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    #data = HTTParty.get("http://localhost:3000/customers.json")
    #p data.parsed_response[0]['email']
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    order = Order.find_by(id: params[:id])
       if order.nil?
           render json: { error: "Order not found. #{ params[:id]}"}, status: 404
       else
           render json: order, status: 200
       end
  end

  # GET /orders/new
  def new
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    res = HTTParty.get("http://localhost:8081/customers/#{order_params['customerId']}.json")
    codeCustomer = res.code
    dataCustomer = res.parsed_response
    res = HTTParty.get("http://localhost:8082/items/#{order_params['itemId']}.json")
    codeItem = res.code
    dataItem = res.parsed_response
    if codeCustomer == 404 || codeItem == 404
      if codeCustomer == 404 and codeItem == 404
        render json: {error: "Customer and Item do not exist"}, status: 400
        return
      end
      if codeCustomer == 404 and codeItem != 404
        render json: {error: "Customer does not exist"}, status: 400
        return
      end
      if codeCustomer != 404 and codeItem == 404
        render json: {error: "Item does not exist"}, status: 400
        return
      end
    else
      @order = Order.new(order_params)

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:id, :itemId, :description, :customerId, :price, :award)
    end
end
