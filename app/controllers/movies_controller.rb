class MoviesController < ApplicationController
#logger.debug '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ End' + @ratings.to_s

############ show
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

############ index
  def index
    @all_ratings = Movie.all_ratings
    @ratings = params[:ratings]
    @sort_by = params[:sort_by]

#    if flash.empty?
#      flash[:init] = 'true'
#      flash.keep(:init)
#      ratings = Hash[@all_ratings.map {|rating| [rating, 1]}]
#    else
#      flash.keep(:init)
#    end

    if session[:init].nil?
      session[:init] = 'true'
      @ratings = Hash[@all_ratings.map {|rating| [rating, 1]}]
    end

    if @sort_by and @ratings.nil? and session[:ratings] 
      session[:sort_by] = @sort_by      
      flash.keep
      redirect_to movies_path :sort_by => @sort_by, :ratings => session[:ratings] 
    elsif !@ratings
      flash.keep
      redirect_to movies_path :sort_by => session[:sort_by], :ratings => session[:ratings]
    else 
      session[:ratings] = @ratings
      session[:sort_by] = @sort_by 
    end 

    if @sort_by and @ratings
      @movies = Movie.where(:rating => @ratings.keys).find(:all, :order => @sort_by)
    elsif @sort_by
       @movies = Movie.find(:all, :order => @sort_by)
    elsif @ratings
       @movies = Movie.where(:rating => @ratings.keys)
    else
      @movies = Movie.all
    end

    !@ratings ? @ratings = Hash.new : ""
  end

############ new 
  def new
    # default: render 'new' template
  end

############ Create
  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

# edit
  def edit
    @movie = Movie.find params[:id]
  end

# update
  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

# destroy
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
