# # Fall 2018 :: CSE 438 Lab 4 - Movie Search App
It is a movie-searching app, which allows users to find information about movies. Data will be pulled from The Movie Database’s (TMDb) API (http://www.themoviedb.org).

# # Build Environment
  - Xcode 9.4
  - Swift 4
  - iPhone 8

# # Features
  - Users can search for movies, and up to 20 movies are shown as a result.
  - Users can select a movie to view more details.
  - Users can add movies to and delete movies from the Favorites.
  - Users can use the search filter (language option and adult search option).
  - Users can see the trailer of the movies that are on the Favorites.

# # Design Choices
  - For UICollectionView cell image, I used w154 size, and for detailed view image, I used w500 size. When images are not possible to fetch, it will be empty.
  - An additional class is used to set shared variables between UITabBar views.
  - Once API call is done, fetched images are cached.
  - Trailers are shown using WKWebView. 

# # References
  - Free tab bar images are from https://icons8.com/ios
  - The movie data are from https://www.themoviedb.org
  - Wrapper for SQLite from https://github.com/ccgus/fmdb

# # Demo
> The following demo shows the basic functionality of this app.
>   
> ![](4_1.gif)  
>
> The following demo shows how the detailed view of the movie is shown and how users can add movies to the Favorites.  
>   
> ![](4_2.gif)
>  
> The following demo shows how users can delete the movies from the Favorites and how users can watch a trailer in the app.  
>   
> ![](4_3.gif)  
>  
> The following demo shows how the search result changes based on the search filter.  
>   
> ![](4_3.gif)  
