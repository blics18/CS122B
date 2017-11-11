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


<%
 	response.setContentType("text/html");

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
    
    String userSearch = request.getParameter("search");
    if(!userSearch.equals("")){
	    String[] keyWords = userSearch.split(" "); 
	    String query = "";
	    if (keyWords.length >= 2){
		    for (int i=0; i < keyWords.length-1; i++){
		    	query = query + "+*" + keyWords[i] + "* ";
		    }
	    }
	    query = query + keyWords[keyWords.length-1] + "*";
	    //ResultSet ajaxQuery = select.executeQuery("Select m.title from movies m WHERE MATCH (`title`) AGAINST ('" + query + "' IN BOOLEAN MODE);");
	    String selectSQL = "Select m.title from movies m WHERE MATCH (`title`) AGAINST (? IN BOOLEAN MODE);";
       	PreparedStatement preparedStatement = connection.prepareStatement(selectSQL);
       	preparedStatement.setString(1, query);
       	ResultSet ajaxQuery = preparedStatement.executeQuery();
	    while(ajaxQuery.next()){
	        String movieTitle = ajaxQuery.getString("title");
	        out.println("<a href=\"getSearch.jsp?search=" + movieTitle + "&page=1&sortby=&numItems=6\">" + movieTitle + "</a><br>");
	    }	
    }

                          
    
  %>