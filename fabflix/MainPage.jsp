<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*, 
 javax.naming.InitialContext,
 javax.naming.Context,
 javax.sql.DataSource"
%>

<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous" >

<HEAD>
  <TITLE>Fabflix Main</TITLE>
  <link href="../css/mainpage.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
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

</script>


<body style="background-color:#FDF5E6">
<div class="row">
    <div class="col-md-4">
        <button type="button" onclick="location.href='MainPage.jsp'">Home </button>
    </div>
    <div class="col-md-4">
        <H1 ALIGN="CENTER">Welcome to Fabflix!</H1>
    </div>
    <div class="col-md-4">
        <FORM ACTION="/fabflix/shoppingCart.jsp">  
            <button style="float:right" type="button" onclick="location.href='shoppingCart.jsp'">My Cart</button> 
        </FORM>
    </div>
</div>

<div class="row">
    <div class="col-md-2">
        <FORM ACTION="/fabflix/getSearch.jsp"
              METHOD="GET" style="padding-left: 10px" name="searchForm">

            <input type="text" name="search" placeholder="Search..." onkeyup="searchQuery()">
            <input type="hidden" name="page" value=1>
            <input type="hidden" name="sortby">
            <input type="hidden" name="numItems" value=6>
            <span id="myDropdown" class="dropdown-content"></span>

        </FORM>
    <!-- </div> -->
    <div class="col-md-10">
    </div>
<!-- </div> -->

<H3 style="padding-left: 20px">Genres</H3>

<!-- <div class="row"> -->

    <!-- <div class="col-md-2"> -->

<%
    // Class.forName("com.mysql.jdbc.Driver").newInstance();
    // Connection connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/moviedb", "mytestuser", "mypassword");
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

        Connection dbcon = ds.getConnection();
        if (dbcon == null)
            out.println("dbcon is null.");
   // Statement select = connection.createStatement();
    
    String selectSQL = "Select name, id from genres order by name asc";

    PreparedStatement preparedStatement = dbcon.prepareStatement(selectSQL);

    // Genres

    ResultSet genreQuery = preparedStatement.executeQuery();

    out.println("<ul>");

    while(genreQuery.next()){
        String genreName = genreQuery.getString("name");
        int genreID = genreQuery.getInt("id");
        out.println("<li><a href=\"getGenres.jsp?genreid=" + genreID + "&page=1&sortby=&numItems=6\">" + genreName + "</a></li>");
    }

    out.println("</ul>");

    out.println("</div>");

    // Movies List

    selectSQL = "Select * from movies order by rand() limit 6;";
    preparedStatement = dbcon.prepareStatement(selectSQL);
    ResultSet movieQuery = preparedStatement.executeQuery();

    
    while(movieQuery.next()){
        out.println("<div class=\"col-md-3\" style=\"padding-bottom:30px\">");
        
        out.println("<center>");
        String movieURL = movieQuery.getString("banner_url");
        String movieTitle = movieQuery.getString("title");
        int movieYear= movieQuery.getInt("year");
        String movieDirector = movieQuery.getString("director");
        String movieID = movieQuery.getString("id");
        out.println("<a href=\"getMovies.jsp?movieid=" + movieID + "\"><img src=\"" + movieURL + "\" style=\"width:250px;height:250px;padding:15px\"></a><br>");

        
        out.println("<font size = \"1\">" + movieTitle + "</font>");
        out.println("<font size = \"1\">" + "(" + movieYear + ")" + "</font>" );
        out.println("<br>");
        out.println("<font size = \"1\">" + "Directed by: " + movieDirector + "</font>");
        out.println("<font size = \"1\"><a href=\"shoppingCart.jsp?movieid=" + movieID+ "&value=1\"> Add to Cart </a></font>");
        out.println("</center>");
        out.println("</div>");
    }
    dbcon.close();

%>
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
