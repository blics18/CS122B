<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*,
 java.lang.*, 
 javax.naming.InitialContext,
 javax.naming.Context,
 javax.sql.DataSource"
%>


<HEAD>
  <TITLE>Search</TITLE>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="../css/mainpage.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</HEAD>


<script language="javascript" type="text/javascript">
function searchQuery(){
    var ajaxRequest;  // The variable that makes Ajax possible!

    try{
        // Opera 8.0+, Firefox, Safari
        ajaxRequest = new XMLHttpRequest();
    } catch (e){
        // Internet Explorer Browsers
        try{
            ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try{
                ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e){
                // Something went wrong
                alert("Your browser broke!");
                return false;
            }
        }
    }
    // Create a function that will receive data sent from the server
    ajaxRequest.onreadystatechange = function(){
        if(ajaxRequest.readyState == 4){
            // var div = document.getElementById("myDropdown");
            // var content = document.createTextNode(ajaxRequest.responseText);
            // div.appendChild(content);
            var val = ajaxRequest.responseText;
            document.getElementById("myDropdown").innerHTML=val;
            // document.searchForm.appendChild = ajaxRequest.responseText;
        }
    }
    var val = document.searchForm.search.value;    
    var url = "searchQuery.jsp?search=" + val;
    ajaxRequest.open("GET", url, true);
    // ajaxRequest.open("GET", "/fabflix/servlet/SearchQuery", true);
    ajaxRequest.send();
}

function windowOpen(movieID){
     var ajaxRequest;  // The variable that makes Ajax possible!

    try{
        // Opera 8.0+, Firefox, Safari
        ajaxRequest = new XMLHttpRequest();
    } catch (e){
        // Internet Explorer Browsers
        try{
            ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (e) {
            try{
                ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e){
                // Something went wrong
                alert("Your browser broke!");
                return false;
            }
        }
    }
    // Create a function that will receive data sent from the server
    ajaxRequest.onreadystatechange = function(){
        if(ajaxRequest.readyState == 4){
            var val = ajaxRequest.responseText;
            document.getElementById("popup" + movieID).innerHTML=val;
            document.getElementById('popup' + movieID).style.display = 'block';
            document.getElementById("detail" + movieID).style.display='none';
        }
    }
    var val = movieID;    
    var url = "popupQuery.jsp?movieID=" + val;
    ajaxRequest.open("GET", url, true);
    ajaxRequest.send();
    // var popup = window.open(url, "_blank", "width=600,height=600");     
}

function windowClose(movieID) {
    document.getElementById("popup" + movieID).style.display = 'none';
    document.getElementById("detail" + movieID).style.display='block';
}


</script>

<body style="background-color:#FDF5E6">
<div class="row">

<div class="col-md-4">
        <button type="button" onclick="location.href='MainPage.jsp'">Home </button>
    </div>
    <div class="col-md-4">
        <H1 ALIGN="CENTER">Search Result</H1>
    </div>
    <div class="col-md-4">
        <FORM ACTION="/fabflix/shoppingCart.jsp">  
            <button style="float:right" type="button" onclick="location.href='shoppingCart.jsp'">My Cart</button> 
        </FORM>
    </div>
</div>

<div class="row">
    <div class="col-md-2">
        <!-- <div id="myDropdown" class="dropdown-content"> -->
        <FORM ACTION="/fabflix/getSearch.jsp"
          METHOD="GET" style="padding-left: 10px" name="searchForm">
            <input type="text" name="search" placeholder="Search..." onkeyup="searchQuery()">
            <input type="hidden" name="page" value=1>
            <input type="hidden" name="sortby">
            <input type="hidden" name="numItems" value=6>
            <span id="myDropdown" class="dropdown-content"></span>
        </FORM>
        <!-- </div> -->

        <h3 style="padding-left: 20px">Genres</h3>
       
    <ul>
<%
    /*Class.forName("com.mysql.jdbc.Driver").newInstance();
    Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser", "mypassword");
    Statement select = connection.createStatement();
    */
    Context initCtx = new InitialContext();
    if (initCtx == null)
        out.println("initCtx is NULL");
    
    Context envCtx = (Context) initCtx.lookup("java:comp/env");
   
    if (envCtx == null)
        out.println("envCtx is NULL");
    
    // Look up our data source
    DataSource ds = (DataSource) envCtx.lookup("jdbc/MovieDB");
    
    if (ds == null)
        out.println("ds is null.");
 
    Connection connection = ds.getConnection();
    if (connection == null)
        out.println("connection is null.");
    PreparedStatement preparedStatement;

    // Genres
    //ResultSet genreQuery = select.executeQuery("Select name, id from genres order by name asc");
    String selectGenres = "Select name, id from genres order by name asc";
    preparedStatement = connection.prepareStatement(selectGenres);
    ResultSet genreQuery = preparedStatement.executeQuery();

    while(genreQuery.next()){
        String genreName = genreQuery.getString("name");
        int genreID = genreQuery.getInt("id");
        out.println("<li><a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=&numItems=6\">" + genreName + "</a></li>");
    }

    out.println("</ul>");

%>
        
    </div>
    <!-- search bar -->

    <div class="col-md-1">
        <h6> Sort By: </h6> 
    </div>
<%
    String userSearch = request.getParameter("search");
    out.println("<div class=\"col-md-1\">");
        out.println("<a href=\"getSearch.jsp?search=" + userSearch + "&page=1&sortby=titleasc&numItems=6\"> <h6>Title <span class=\"glyphicon glyphicon-arrow-up\"></span></h6></a>");
   out.println("</div>");
    out.println("<div class=\"col-md-1\">");
        out.println("<a href=\"getSearch.jsp?search=" + userSearch + "&page=1&sortby=titledesc&numItems=6\"<h6>Title <span class=\"glyphicon glyphicon-arrow-down\"></span></h6>");
    out.println("</div>");
    out.println("<div class=\"col-md-1\">");
        out.println("<a href=\"getSearch.jsp?search=" + userSearch + "&page=1&sortby=yearasc&numItems=6\"<h6>Year<span class=\"glyphicon glyphicon-arrow-up\"></span></h6>");
    out.println("</div>");
    out.println("<div class=\"col-md-1\">");
        out.println("<a href=\"getSearch.jsp?search=" + userSearch + "&page=1&sortby=yeardesc&numItems=6\"<h6>Year<span class=\"glyphicon glyphicon-arrow-down\"></span></h6>");
    out.println("</div>");
%>

<div class="col-md-2">
       <H6> Results Per Page: </H6>
</div>
    <div class="col-md-1">
<%
        out.print("<a href=\"getSearch.jsp?search=" + userSearch+ "&page=1&sortby=&numItems=10\"> 10  </a>");
        out.print("</div>");
        out.print("<div class=\"col-md-1\">");
        out.print("<a href=\"getSearch.jsp?search=" + userSearch+ "&page=1&sortby=&numItems=20\"> 20  </a>");
        out.print("</div>");
        out.print("<div class=\"col-md-1\">");
        out.print("<a href=\"getSearch.jsp?search=" + userSearch+ "&page=1&sortby=&numItems=50\"> 50  </a>");
        out.print("</div>");

%>
<!-- </div> -->



<%
    int numItems = Integer.parseInt(request.getParameter("numItems"));
    String sortby = request.getParameter("sortby");
    String[] starName = userSearch.split(" ");
    int pageid = Integer.parseInt(request.getParameter("page"));
    int total = numItems;
    ResultSet searchQuery;
    String selectSQL;
    
    if (pageid !=1){
        pageid = pageid-1;
        pageid = pageid*total+1;
    }

    int totalCount = 0;

    if (starName.length >= 2) {
        //ResultSet countQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%')");
       selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ?";
       preparedStatement = connection.prepareStatement(selectSQL);
       preparedStatement.setString(1, "%" + userSearch + "%");
       ResultSet countQuery = preparedStatement.executeQuery();

        while (countQuery.next()){
            totalCount++;
        }

        if (sortby.equals("titleasc")){
            //searchQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%' OR movies.director LIKE '%" + userSearch + "%' OR movies.year LIKE '%" + userSearch + "%' OR stars.first_name LIKE '%" + userSearch + "%' OR stars.last_name LIKE '%" + userSearch + "%' OR (stars.first_name LIKE '%" + starName[0] + "%' AND stars.last_name LIKE '%"+ starName[1]+ "%') order by movies.title asc limit " + (pageid-1) + ", " + total);
            selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ? OR movies.director LIKE ? OR movies.year LIKE ? OR stars.first_name LIKE ? OR stars.last_name LIKE ? OR (stars.first_name LIKE ? AND stars.last_name LIKE ?) order by movies.title asc limit ?, ?";
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, "%" + userSearch + "%");
            preparedStatement.setString(2, "%" + userSearch + "%");
            preparedStatement.setString(3, "%" + userSearch + "%");
            preparedStatement.setString(4, "%" + userSearch + "%");
            preparedStatement.setString(5, "%" + userSearch + "%");
            preparedStatement.setString(6, "%" + starName[0] + "%");
            preparedStatement.setString(7, "%" + starName[1] + "%");
            preparedStatement.setInt(8, (pageid-1));
            preparedStatement.setInt(9, total);
            searchQuery = preparedStatement.executeQuery();
        }
        else if(sortby.equals("titledesc")){
            //searchQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%' OR movies.director LIKE '%" + userSearch + "%' OR movies.year LIKE '%" + userSearch + "%' OR stars.first_name LIKE '%" + userSearch + "%' OR stars.last_name LIKE '%" + userSearch + "%' OR (stars.first_name LIKE '%" + starName[0] + "%' AND stars.last_name LIKE '%"+ starName[1]+ "%') order by movies.title desc limit " + (pageid-1) + ", " + total);
            selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ? OR movies.director LIKE ? OR movies.year LIKE ? OR stars.first_name LIKE ? OR stars.last_name LIKE ? OR (stars.first_name LIKE ? AND stars.last_name LIKE ?) order by movies.title desc limit ?, ?";
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, "%" + userSearch + "%");
            preparedStatement.setString(2, "%" + userSearch + "%");
            preparedStatement.setString(3, "%" + userSearch + "%");
            preparedStatement.setString(4, "%" + userSearch + "%");
            preparedStatement.setString(5, "%" + userSearch + "%");
            preparedStatement.setString(6, "%" + starName[0] + "%");
            preparedStatement.setString(7, "%" + starName[1] + "%");
            preparedStatement.setInt(8, (pageid-1));
            preparedStatement.setInt(9, total);
            searchQuery = preparedStatement.executeQuery();
        }
        else if (sortby.equals("yearasc")){
            //searchQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%' OR movies.director LIKE '%" + userSearch + "%' OR movies.year LIKE '%" + userSearch + "%' OR stars.first_name LIKE '%" + userSearch + "%' OR stars.last_name LIKE '%" + userSearch + "%' OR (stars.first_name LIKE '%" + starName[0] + "%' AND stars.last_name LIKE '%"+ starName[1]+ "%') order by movies.year asc limit " + (pageid-1) + ", " + total);
            selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ? OR movies.director LIKE ? OR movies.year LIKE ? OR stars.first_name LIKE ? OR stars.last_name LIKE ? OR (stars.first_name LIKE ? AND stars.last_name LIKE ?) order by movies.year asc limit ?, ?";
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, "%" + userSearch + "%");
            preparedStatement.setString(2, "%" + userSearch + "%");
            preparedStatement.setString(3, "%" + userSearch + "%");
            preparedStatement.setString(4, "%" + userSearch + "%");
            preparedStatement.setString(5, "%" + userSearch + "%");
            preparedStatement.setString(6, "%" + starName[0] + "%");
            preparedStatement.setString(7, "%" + starName[1] + "%");
            preparedStatement.setInt(8, (pageid-1));
            preparedStatement.setInt(9, total);
            searchQuery = preparedStatement.executeQuery();
        }
        else if (sortby.equals("yeardesc")){
            //searchQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%' OR movies.director LIKE '%" + userSearch + "%' OR movies.year LIKE '%" + userSearch + "%' OR stars.first_name LIKE '%" + userSearch + "%' OR stars.last_name LIKE '%" + userSearch + "%' OR (stars.first_name LIKE '%" + starName[0] + "%' AND stars.last_name LIKE '%"+ starName[1]+ "%') order by movies.year desc limit " + (pageid-1) + ", " + total);
            selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ? OR movies.director LIKE ? OR movies.year LIKE ? OR stars.first_name LIKE ? OR stars.last_name LIKE ? OR (stars.first_name LIKE ? AND stars.last_name LIKE ?) order by movies.year desc limit ?, ?";
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, "%" + userSearch + "%");
            preparedStatement.setString(2, "%" + userSearch + "%");
            preparedStatement.setString(3, "%" + userSearch + "%");
            preparedStatement.setString(4, "%" + userSearch + "%");
            preparedStatement.setString(5, "%" + userSearch + "%");
            preparedStatement.setString(6, "%" + starName[0] + "%");
            preparedStatement.setString(7, "%" + starName[1] + "%");
            preparedStatement.setInt(8, (pageid-1));
            preparedStatement.setInt(9, total);
            searchQuery = preparedStatement.executeQuery();
        }
        else{
            //searchQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%' limit " + (pageid-1) + ", " + total);
            selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ? limit ?, ?";
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, "%" + userSearch + "%");
            preparedStatement.setInt(2, (pageid-1));
            preparedStatement.setInt(3, total);
            searchQuery = preparedStatement.executeQuery();
        }
    }
    
    else {
        //ResultSet countQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%'");
        selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ?";
        preparedStatement = connection.prepareStatement(selectSQL);
        preparedStatement.setString(1, "%" + userSearch + "%");
        ResultSet countQuery = preparedStatement.executeQuery();
       
        while (countQuery.next()){
            totalCount++;
        }
        if (sortby.equals("titleasc")){
            //searchQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%' OR movies.director LIKE '%" + userSearch + "%' OR movies.year LIKE '%" + userSearch + "%' OR stars.first_name LIKE '%" + userSearch + "%' OR stars.last_name LIKE '%" + userSearch + "%' order by movies.title asc limit " + (pageid-1) + ", " + total);
            selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ? OR movies.director LIKE ? OR movies.year LIKE ? OR stars.first_name LIKE ? OR stars.last_name LIKE ? order by movies.title asc limit ?, ?";
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, "%" + userSearch + "%");
            preparedStatement.setString(2, "%" + userSearch + "%");
            preparedStatement.setString(3, "%" + userSearch + "%");
            preparedStatement.setString(4, "%" + userSearch + "%");
            preparedStatement.setString(5, "%" + userSearch + "%");
            preparedStatement.setInt(6, (pageid-1));
            preparedStatement.setInt(7, total);
            searchQuery = preparedStatement.executeQuery();

        }
        else if (sortby.equals("titledesc")){
            //searchQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%' OR movies.director LIKE '%" + userSearch + "%' OR movies.year LIKE '%" + userSearch + "%' OR stars.first_name LIKE '%" + userSearch + "%' OR stars.last_name LIKE '%" + userSearch + "%' order by movies.title desc limit " + (pageid-1) + ", " + total);
            selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ? OR movies.director LIKE ? OR movies.year LIKE ? OR stars.first_name LIKE ? OR stars.last_name LIKE ? order by movies.title desc limit ?, ?";
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, "%" + userSearch + "%");
            preparedStatement.setString(2, "%" + userSearch + "%");
            preparedStatement.setString(3, "%" + userSearch + "%");
            preparedStatement.setString(4, "%" + userSearch + "%");
            preparedStatement.setString(5, "%" + userSearch + "%");
            preparedStatement.setInt(6, (pageid-1));
            preparedStatement.setInt(7, total);
            searchQuery = preparedStatement.executeQuery();

        }
        else if (sortby.equals("yearasc")){
            //searchQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%' OR movies.director LIKE '%" + userSearch + "%' OR movies.year LIKE '%" + userSearch + "%' OR stars.first_name LIKE '%" + userSearch + "%' OR stars.last_name LIKE '%" + userSearch + "%' order by movies.year asc limit " + (pageid-1) + ", " + total);
            selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ? OR movies.director LIKE ? OR movies.year LIKE ? OR stars.first_name LIKE ? OR stars.last_name LIKE ? order by movies.year asc limit ?, ?";
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, "%" + userSearch + "%");
            preparedStatement.setString(2, "%" + userSearch + "%");
            preparedStatement.setString(3, "%" + userSearch + "%");
            preparedStatement.setString(4, "%" + userSearch + "%");
            preparedStatement.setString(5, "%" + userSearch + "%");
            preparedStatement.setInt(6, (pageid-1));
            preparedStatement.setInt(7, total);
            searchQuery = preparedStatement.executeQuery();

        }
        else if (sortby.equals("yeardesc")){
            //searchQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%' OR movies.director LIKE '%" + userSearch + "%' OR movies.year LIKE '%" + userSearch + "%' OR stars.first_name LIKE '%" + userSearch + "%' OR stars.last_name LIKE '%" + userSearch + "%' order by movies.year desc limit " + (pageid-1) + ", " + total);
            selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ? OR movies.director LIKE ? OR movies.year LIKE ? OR stars.first_name LIKE ? OR stars.last_name LIKE ? order by movies.year desc limit ?, ?";
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, "%" + userSearch + "%");
            preparedStatement.setString(2, "%" + userSearch + "%");
            preparedStatement.setString(3, "%" + userSearch + "%");
            preparedStatement.setString(4, "%" + userSearch + "%");
            preparedStatement.setString(5, "%" + userSearch + "%");
            preparedStatement.setInt(6, (pageid-1));
            preparedStatement.setInt(7, total);
            searchQuery = preparedStatement.executeQuery();

        }
        else{
            //searchQuery = select.executeQuery("SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE '%" + userSearch + "%' limit " + (pageid-1) + ", " + total);
            selectSQL = "SELECT distinct movies.id, movies.title, movies.year, movies.director, movies.banner_url FROM ((movies JOIN stars_in_movies on movies.id = stars_in_movies.movie_id) join stars on stars_in_movies.star_id = stars.id) WHERE movies.title LIKE ? limit ?, ?";
            preparedStatement = connection.prepareStatement(selectSQL);
            preparedStatement.setString(1, "%" + userSearch + "%");
            preparedStatement.setInt(2, (pageid-1));
            preparedStatement.setInt(3, total);
            searchQuery = preparedStatement.executeQuery();

        }

    }
 
    ArrayList<Integer> sortMap = new ArrayList<Integer>();
    HashMap<Integer, HashMap<String, String>> results = new HashMap<Integer, HashMap<String, String>>();

    Boolean emptyTable = true;
    while(searchQuery.next()){
        emptyTable = false;
        Integer movieID = searchQuery.getInt("id");
        String movieTitle = searchQuery.getString("title");
        String year = Integer.toString(searchQuery.getInt("year"));
        String director = searchQuery.getString("director");
        String banner_url = searchQuery.getString("banner_url");

        HashMap<String, String> innerResults = new HashMap<String, String>();
        innerResults.put("title", movieTitle);
        innerResults.put("director", director);
        innerResults.put("year", year);
        innerResults.put("banner_url", banner_url);

        results.put(movieID, innerResults);
        sortMap.add(movieID);
    }

    HashMap<Integer, HashMap<Integer, String>> starResults = new HashMap<Integer, HashMap<Integer, String>>();
    for(Integer id: results.keySet()){
        //ResultSet starQuery = select.executeQuery("Select stars.id, stars.first_name, stars.last_name from stars, stars_in_movies where stars_in_movies.movie_id=" + id + " AND stars_in_movies.star_id=stars.id");
        String selectStars = "Select stars.id, stars.first_name, stars.last_name from stars, stars_in_movies where stars_in_movies.movie_id=? AND stars_in_movies.star_id=stars.id";
        preparedStatement = connection.prepareStatement(selectStars);
        preparedStatement.setInt(1, id);
        ResultSet starQuery = preparedStatement.executeQuery();

        HashMap<Integer, String> namesList = new HashMap<Integer, String>();
        while(starQuery.next()){
            Integer starsID = starQuery.getInt("id");
            String first_name = starQuery.getString("first_name");
            String last_name = starQuery.getString("last_name");
            String name = first_name + " " + last_name;
            namesList.put(starsID, name);
        }
        starResults.put(id, namesList);
    }

    HashMap<Integer, ArrayList<String>> genreResults = new HashMap<Integer, ArrayList<String>>();
    for(Integer id: results.keySet()){
        //ResultSet genreNamesQuery = select.executeQuery("Select genres.name from genres, genres_in_movies where genres_in_movies.movie_id=" + id + " AND genres_in_movies.genre_id=genres.id");
        String selectGenreNames = "Select genres.name from genres, genres_in_movies where genres_in_movies.movie_id=? AND genres_in_movies.genre_id=genres.id";
        preparedStatement = connection.prepareStatement(selectGenreNames);
        preparedStatement.setInt(1, id);
        ResultSet genreNamesQuery = preparedStatement.executeQuery();

        ArrayList<String> genresList = new ArrayList<String>();
        while(genreNamesQuery.next()){
            String genre_name = genreNamesQuery.getString("name");

            genresList.add(genre_name);
        }
        genreResults.put(id, genresList);
    }
    out.println("<div class=\"col-md-9\">");
    for(Integer id : sortMap){
        out.println("<div class=\"row\">");
        out.println("<div class=\"col-md-3\">");
        out.println("<img src=\"" + results.get(id).get("banner_url") + "\" style=\"width:250px;height:250px;padding:10px;\">");
        out.println("</div>");
        out.println("<div class=\"col-md-6\">");
        
        out.println("<h5> Title: <a onmouseover=\"windowOpen(" + id + ")\" href=\"getMovies.jsp?movieid=" + id + "\">" + results.get(id).get("title") + "</a></h5>");
        out.println("<div id=\"popup" + id + "\" style=\"display: none; background-color: black; color: white;\"></div>");
        out.println("<div id=\"detail" + id + "\"");
        out.println("<h5> Year: " + results.get(id).get("year") + "</h5>");
        out.println("<h5> Director: " + results.get(id).get("director") + "</h5>");
        out.println("<h5> Movie ID: " + id + "</h5>");
        out.print("<h5> Stars: ");
        for(Integer starID : starResults.get(id).keySet()){
            out.print("<a href=\"getStars.jsp?starid=" + starID + "\">"+ starResults.get(id).get(starID) + "</a> ");
        }
        out.println("</h5>");
        out.print("<h5> Genres: ");
        for(String genreName : genreResults.get(id)){
            out.print(genreName + " ");
        }
        out.println("</h5>");
        out.println("<font size = \"3\"><a href=\"shoppingCart.jsp?movieid=" + id + "&value=1\"> Add to Cart </a></font>");
        out.println("</div>");
        out.println("</div>");
        out.println("</div>");
    }

    out.println("</div>");
    
    if (emptyTable){
        out.println("<div class=\"col-md-8\">");
        out.println("<center>");
        out.println("<h5>No Results Found</h5>");
        out.println("</center>");
        out.println("</div>");
    }

%>
</div>

<div class="row">
    
    <div style="padding-bottom:50px">
        <center>
        <%
            if(!emptyTable){
                if (totalCount/total == 0) {
                    out.print("<u><b><a href=\"getSearch.jsp?search=" + userSearch + "&page=" + 1 + "&sortby="+sortby+"&numItems=" + total+ "\">" + 1 + "</a></b></u> ");
                }
                else {
                    if(Integer.parseInt(request.getParameter("page")) == 1){
                        int nextPage = Integer.parseInt(request.getParameter("page")) + 1;
                        for (int i=0; i < Math.ceil((double)totalCount/total); i++){
                            int pageCounter = i+1;
                            
                           
                            out.print("<u><b><a href=\"getSearch.jsp?search=" + userSearch + "&page=" + pageCounter + "&sortby="+sortby+"&numItems=" + total+ "\">" + pageCounter + "</a></b></u> ");
                           
                        }
                        out.println("<u><b><a href=\"getSearch.jsp?search=" + userSearch + "&page=" + nextPage + "&sortby="+sortby+"&numItems=" + total+ "\"> Next </a></b></u>");

                    }
                    else if(Integer.parseInt(request.getParameter("page")) == Math.ceil((double)totalCount/total)) {
                        int prevPage = Integer.parseInt(request.getParameter("page")) - 1; 
                        out.println("<u><b><a href=\"getSearch.jsp?search=" + userSearch + "&page=" + prevPage + "&sortby="+sortby+"&numItems=" + total+ "\"> Prev </a></b></u>");
                        for (int i=0; i < Math.ceil((double)totalCount/total); i++){
                            int pageCounter = i+1;
                            
                            out.print("<u><b><a href=\"getSearch.jsp?search=" + userSearch + "&page=" + pageCounter + "&sortby="+sortby+"&numItems=" + total+ "\">" + pageCounter + "</a></b></u> ");
                        }
                    }
                    else{
                        int prevPage = Integer.parseInt(request.getParameter("page")) - 1; 
                        int nextPage = Integer.parseInt(request.getParameter("page")) + 1;
                        out.println("<u><b><a href=\"getSearch.jsp?search=" + userSearch + "&page=" + prevPage + "&sortby="+sortby+"&numItems=" + total+ "\"> Prev </a></b></u>");

                       for (int i=0; i < Math.ceil((double)totalCount/total); i++){
                            int pageCounter = i+1; 

                            out.print("<u><b><a href=\"getSearch.jsp?search=" + userSearch + "&page=" + pageCounter + "&sortby="+sortby+"&numItems=" + total+ "\">" + pageCounter + "</a></b></u> ");
                        }
                        out.println("<u><b><a href=\"getSearch.jsp?search=" + userSearch + "&page=" + nextPage + "&sortby="+sortby+"&numItems=" + total+ "\"> Next </a></b></u>");

                    }
                }
            }
        %>
        </center>
    </div>
</div>

<div class="row" style="padding-top: 70px">
    <div class="col-md-2">
    </div>
    <div class="col-md-9" style="padding-bottom:50px">
        <center>
            <h4 style="margin-top:-50px">Browse by Title</h4>
            <%
            String alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

            for(int letter = 0; letter < alphabet.length(); ++letter){
                out.println("<u><b><a href=\"getTitles.jsp?char=" + alphabet.charAt(letter) + "&page=1&sortby=&numItems=6\">" + alphabet.charAt(letter) + "</a></b></u>");
        }

            for(int i= 0; i < 10; ++i){
                out.println("<u><b><a href=\"getTitles.jsp?char=" + i + "&page=1&sortby=&numItems=6\">" + i + "</a></b></u>");
            }
            %>
        </center>
    </div>
</div>



</body>
</html>
