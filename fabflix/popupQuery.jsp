<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*,
java.lang.*"
%>


<%
 	response.setContentType("text/html");

    Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser", "mypassword");
    Statement select = connection.createStatement();
    PreparedStatement preparedStatement;

    String userSearch = request.getParameter("movieID");
   
	    
    //ResultSet ajaxQuery = select.executeQuery("Select movies.banner_url, movies.year, stars.first_name, stars.last_name from ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.id=" + userSearch);

    String selectSQL = "Select movies.banner_url, movies.year, stars.first_name, stars.last_name from ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.id=?";

    preparedStatement = connection.prepareStatement(selectSQL);
    preparedStatement.setString(1, userSearch);
    ResultSet ajaxQuery = preparedStatement.executeQuery();


    HashSet<String> namesSet = new HashSet<String>();
    String movieBanner = "";
    int movieYear = 0;
    while(ajaxQuery.next()){
        movieBanner = ajaxQuery.getString("banner_url");
        movieYear = ajaxQuery.getInt("year");
        String starName = ajaxQuery.getString("first_name") + " " + ajaxQuery.getString("last_name");
        namesSet.add(starName);
    }	
    out.println("<img src=\"" + movieBanner + "\" style=\"width:250px;height:250px;padding:10px;\">");
    out.println("<h5>Year: " + movieYear + "</h5>");
    out.print("<h5> Stars: ");
    for (String name: namesSet){
    	out.print( name + " ");
	}
	out.println("</h5>");
	out.println("<font size = \"3\"><a href=\"shoppingCart.jsp?movieid=" + userSearch + "&value=1\"> Add to Cart </a></font>");
	out.println("<a onclick=\"windowClose(" + userSearch + ")\" style=\"float:right\">Close</a>");
	
    

                          
    
%>