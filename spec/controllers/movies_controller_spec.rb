require "spec_helper"

describe MoviesController do
  describe "My test" do
    it "should verify url existance" do
      movie1 = Movie.create(:title=>"Movie1", :director=>"Director1")      
      get :similar, {:id=>movie1.id}
      response.should be_success
    end
    it "should call to Movie class method" do
      movie1 = Movie.create(:title=>"Movie1", :director=>"Director1")      
      Movie.should_receive(:get_similar_movies).with(movie1.director)
      get :similar, {:id=>movie1.id}
    end
    it "should find movies with same director" do
      movie1 = Movie.create(:title=>"Movie1", :director=>"Director1")
      movie2 = Movie.create(:title=>"Movie2", :director=>"Director1")
      movie3 = Movie.create(:title=>"Movie3")
      found_movies = Movie.get_similar_movies(movie1.director)
      assert found_movies.length == 2, "Movies amount mismatch. Must to be 2, but it is #{ found_movies.length }"
      assert [movie1.id, movie2.id].include?(found_movies[0].id)
      assert [movie1.id, movie2.id].include?(found_movies[1].id)
    end
    it "should redirect if movie has now director" do
      movie1 = Movie.create(:title=>"Movie1")
      get :similar, {:id=>movie1.id}
      response.should redirect_to(movies_path())
    end
  end
end