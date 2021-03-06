class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    field = params[:sort] || "title"
    @css_class_release = field == "release_date" ? "hilite" : nil
    @css_class_title = field == "title" ? "hilite" : nil
    @movies = Movie.order(field)
    if params[:ratings]
      @movies = Movie.where(params[:ratings].present? ? {:rating => (params[:ratings].keys)} :{}).order(params[:sort])
    end
    @ratings_selected = []
    @ratings_avilable = Movie.ratings_avilable
    @ratings_set = params[:ratings]
    if !params[:ratings].nil?
      params[:ratings].each_key do |key|
        @ratings_selected << key
      end
    else
      @ratings_selected = @ratings_avilable
    end
    if !@ratings_set
      @ratings_set = Hash.new
    end
    
    # Store details in session for sorting after filtering
    if params[:sort]
      session[:sort] = params[:sort]
      @sort_by = params[:sort]
    elsif session[:sort]
      redirect = true
      @sort_by = session[:sort]
    else
      @sort_by = nil
    end
    
    if params[:ratings].nil? and params[:commit] == "Refresh"
      session[:ratings] = nil
      @ratings = nil
    elsif params[:ratings]
      session[:ratings] = params[:ratings]
      @ratings = params[:ratings]
    elsif session[:ratings]
      redirect = true
      @ratings = session[:ratings]
    else
      @ratings = nil
    end
    if redirect
      redirect_to movies_path :sort =>@sort_by, :ratings=>@ratings
      flash.keep
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
