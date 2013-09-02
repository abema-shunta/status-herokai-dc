class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]
  
  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
  end

  def compare
    require 'rubygems'
    require 'nokogiri'
    require 'open-uri'
    @article = Article.find_by(:url => params[:url] )
    _doc = Nokogiri::HTML(open("https://devcenter.heroku.com/articles/#{params[:url]}"))
    @doc = _doc.css(".padder").first.to_s
    _wiki = Nokogiri::HTML(open("https://github.com/herokaijp/devcenter/wiki/#{params[:url]}"))
    if _wiki.css("#head h1").first.content == "Home"
      @wiki = nil
    else
      @wiki = _wiki.css("#wiki-content").first.to_s
    end
    respond_to do |format|
      format.js
    end
  end

  # # GET /articles/1
  # # GET /articles/1.json
  # def show
  # end
  # 
  # # GET /articles/new
  # def new
  #   @article = Article.new
  # end
  # 
  # # GET /articles/1/edit
  # def edit
  # end
  # 
  # # POST /articles
  # # POST /articles.json
  # def create
  #   @article = Article.new(article_params)
  # 
  #   respond_to do |format|
  #     if @article.save
  #       format.html { redirect_to @article, notice: 'Article was successfully created.' }
  #       format.json { render action: 'show', status: :created, location: @article }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @article.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PATCH/PUT /articles/1
  # # PATCH/PUT /articles/1.json
  # def update
  #   respond_to do |format|
  #     if @article.update(article_params)
  #       format.html { redirect_to @article, notice: 'Article was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @article.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # DELETE /articles/1
  # # DELETE /articles/1.json
  # def destroy
  #   @article.destroy
  #   respond_to do |format|
  #     format.html { redirect_to articles_url }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:name, :url, :written_at, :translated_at, :category, :tag)
    end
end
