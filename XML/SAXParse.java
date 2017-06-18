package project3;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.sql.*; 

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

import org.xml.sax.helpers.DefaultHandler;

public class SAXParse extends DefaultHandler {
	ArrayList<movies> myMovies;
	
	private String tempVal;
	
	//to maintain context
	private movies tempMovies;
	
	private boolean titleFound;//checking for duplicate titles
	private ArrayList<String> genreList;
	private static HashSet<String> genreSet;
	
	
	public SAXParse(){
		myMovies = new ArrayList<movies>();
		titleFound= false;
		genreList = new ArrayList<String>();
		genreSet= new HashSet<String>();
	}
	
	public void runExample() {
		parseDocument();
//		printData();
	}

	private void parseDocument() {
		
		//get a factory
		SAXParserFactory spf = SAXParserFactory.newInstance();
		try {
		
			//get a new instance of parser
			SAXParser sp = spf.newSAXParser();
			
			//parse the file and also register this class for call backs
			sp.parse("C:/Users/BL/Documents/CS122B/project3/src/project3/mains243.xml", this);
			
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch (IOException ie) {
			ie.printStackTrace();
		}
	}

	/**
	 * Iterate through the list and print
	 * the contents
	 */
//	private void printData(){
//		
//		System.out.println("No of Movies '" + myMovies.size() + "'.");
//		
////		Iterator it = myMovies.iterator();
////		while(it.hasNext()) {
////			System.out.println(it.next().getDirector());
////		}
//		for (movies m: myMovies){
//			System.out.println(m.getDirector());
//			
//		}
//	}
	

	//Event Handlers
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		//reset
		tempVal = "";
		if(qName.equalsIgnoreCase("directorfilms")) {
			//create a new instance of employee
			tempMovies = new movies();
			//tempEmp.setType(attributes.getValue("type"));
		}
	}
	

	public void characters(char[] ch, int start, int length) throws SAXException {
		tempVal = new String(ch,start,length);
	}
	
	public void endElement(String uri, String localName, String qName) throws SAXException {
		try{
			if(qName.equalsIgnoreCase("directorfilms")) {
				//add it to the list
				myMovies.add(tempMovies);
				
			}else if (qName.equalsIgnoreCase("dirname") || qName.equalsIgnoreCase("dirn")) {
				tempMovies.setDirector(tempVal);
			}else if (qName.equalsIgnoreCase("t") && titleFound == false) {
				titleFound = true;
				tempMovies.setTitle(tempVal);
				tempMovies.setTitleList(tempVal);
				
			}else if (qName.equalsIgnoreCase("year")) {
				tempMovies.setYearList(Integer.parseInt(tempVal));
				titleFound = false;
			}else if (qName.equalsIgnoreCase("cat")){
//				System.out.println("HERE");
//				if (tempMovies.getTitle().equalsIgnoreCase("Death Race 2000")){
				
				if (tempMovies.getGenreMap().containsKey(tempMovies.getTitle())){
					ArrayList<String> newArray = tempMovies.getGenreMap().get(tempMovies.getTitle());
					newArray.add(tempVal.trim().toLowerCase());
					genreSet.add(tempVal.trim().toLowerCase());
					tempMovies.setGenreMap(tempMovies.getTitle(), newArray);
				}
				else{
					genreList = new ArrayList<String>();
					if (!tempVal.equals("")){
						genreList.add(tempVal.trim().toLowerCase());
						genreSet.add(tempVal.trim().toLowerCase());
					}
					if (genreList.size() != 0){
						tempMovies.setGenreMap(tempMovies.getTitle(), genreList);
					}
				}
//					System.out.println("Title: " + tempMovies.getTitle());
//					System.out.println(tempVal);
//				}
				
			}
		}
		catch(NumberFormatException e){
			System.out.println("NumberFormatException: cannot parse string to int");
			tempMovies.setYearList(0);
			titleFound = false;
		}
			
		}
	
	
	public static void main(String[] args) throws Exception{
		SAXParse spe = new SAXParse();
		spe.runExample();
		 String loginUser = "mytestuser";
	     String loginPasswd = "mypassword";
	     String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
	     
	     //Class.forName("org.gjt.mm.mysql.Driver");
         Class.forName("com.mysql.jdbc.Driver").newInstance();
         Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
         // Declare our statement
         Statement statement = dbcon.createStatement();
		 
		 ResultSet rs = statement.executeQuery("Select g.name from genres g");
		 while (rs.next()){
			 
			 if (genreSet.contains(rs.getString("name"))){
				 genreSet.remove(rs.getString("name"));
			 }
		 }

		 PreparedStatement psInsertRecord;
		 String sqlInsertRecord;
		 
		 sqlInsertRecord="insert into genres (name) values(?)";
        try {
            dbcon.setAutoCommit(false);

            psInsertRecord=dbcon.prepareStatement(sqlInsertRecord);
            
            for (String genre: genreSet){
            	psInsertRecord.setString(1, genre);
   			 	psInsertRecord.addBatch();
   		 	}

              psInsertRecord.executeBatch();
              dbcon.commit();
        }catch (SQLException e) {
        	e.printStackTrace();
        }
        
        sqlInsertRecord="insert into movies (title, year, director, banner_url, trailer_url) values(?, ?, ?, ?, ?)";
        try{
        	dbcon.setAutoCommit(false);
        	psInsertRecord=dbcon.prepareStatement(sqlInsertRecord);
   		 	for (movies m : spe.myMovies){
   		 		for(int i = 0; i < m.getTitleList().size(); ++i){
   		 			psInsertRecord.setString(1, m.getTitleList().get(i));
   		 			psInsertRecord.setInt(2, m.getYearList().get(i));
   		 			psInsertRecord.setString(3, m.getDirector());
   		 			psInsertRecord.setString(4, "");
   		 			psInsertRecord.setString(5, "");
   		 			psInsertRecord.addBatch();
   		 		}
   		 	}
   		 psInsertRecord.executeBatch();
         dbcon.commit();
	 }catch (SQLException e) {
     	e.printStackTrace();
     }

	 for (movies m: spe.myMovies){
		 for (String title: m.getGenreMap().keySet()){
			 
			 rs = statement.executeQuery("Select m.id from movies m where m.title=\"" + title + "\"");
			 ArrayList<Integer> movieIDs = new ArrayList<Integer>();
			 while(rs.next()){
				 movieIDs.add(rs.getInt("id"));
			 }
			 ArrayList<Integer> genreIDs = new ArrayList<Integer>();
			 for (String genre: m.getGenreMap().get(title))
				 rs = statement.executeQuery("Select g.id from genres g where g.name=\"" + genre + "\"");
			 	 while(rs.next()){
			 		 genreIDs.add(rs.getInt("id"));
			 	 }
			 	
			 sqlInsertRecord="insert into genres_in_movies (genre_id, movie_id) values(?, ?)";
		    try{
	        	dbcon.setAutoCommit(false);
	        	psInsertRecord=dbcon.prepareStatement(sqlInsertRecord);
	   		 	for (Integer movieID: movieIDs){
	   		 		for(Integer genreID: genreIDs){
	   		 			psInsertRecord.setInt(1, genreID);
	   		 			psInsertRecord.setInt(2, movieID);
	   		 			psInsertRecord.addBatch();
	   		 			
	   		 		}
	   		 	}
		   		 psInsertRecord.executeBatch();
		         dbcon.commit();
			 }catch (SQLException e) {
		     	e.printStackTrace();
		     }
				
			 
		 }
	}
        
    }
    
}
       
