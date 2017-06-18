package project3;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.sql.*; 

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

import org.xml.sax.helpers.DefaultHandler;
import org.xml.sax.helpers.DefaultHandler;

public class SAXParserCasts extends DefaultHandler{
	ArrayList<casts> myCasts;
	
	private String tempVal;
	
	//to maintain context
	private casts tempCasts;
	
	public SAXParserCasts(){
		myCasts = new ArrayList<casts>();
	}

	public void runExample() {
		parseDocument();
	}
	
	private void parseDocument() {
		
		//get a factory
		SAXParserFactory spf = SAXParserFactory.newInstance();
		try {
		
			//get a new instance of parser
			SAXParser sp = spf.newSAXParser();
			
			//parse the file and also register this class for call backs
			sp.parse("C:/Users/BL/Documents/CS122B/project3/src/project3/casts124.xml", this);
			
		}catch(SAXException se) {
			se.printStackTrace();
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch (IOException ie) {
			ie.printStackTrace();
		}
	}
	

	
	//Event Handlers
	public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
		//reset
		tempVal = "";
		if(qName.equalsIgnoreCase("filmc")) {
			//create a new instance of employee
			tempCasts = new casts();
			//tempEmp.setType(attributes.getValue("type"));
		}
	}
	
	public void characters(char[] ch, int start, int length) throws SAXException {
		tempVal = new String(ch,start,length);
	}
	
	public void endElement(String uri, String localName, String qName) throws SAXException {
		try{
			if(qName.equalsIgnoreCase("filmc")) {
				//add it to the list
				myCasts.add(tempCasts);
				
			}else if (qName.equalsIgnoreCase("t")) {
				String pattern = "[a-zA-Z\\d]+";

				Pattern regex = Pattern.compile(pattern);
	
				Matcher m = regex.matcher(tempVal);
				if (!tempVal.equals("") && m.find()){
					
					tempCasts.setTitle(tempVal);
				}
								
			}else if (qName.equalsIgnoreCase("a")) {
				String pattern = "[a-zA-Z]+";

				Pattern regex = Pattern.compile(pattern);
	
				Matcher m = regex.matcher(tempVal);

				if (!tempVal.equals("") && m.find()){
					tempCasts.setStars(tempVal);
				}
			}
			
		}
		catch(NumberFormatException e){
			e.printStackTrace();
		}
			
	}

	public static void main(String[] args) throws Exception{
		SAXParserCasts spe = new SAXParserCasts();
		spe.runExample();
		
		 String loginUser = "mytestuser";
	     String loginPasswd = "mypassword";
	     String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
	     
	     //Class.forName("org.gjt.mm.mysql.Driver");
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
        // Declare our statement
        Statement statement = dbcon.createStatement();
        ResultSet rs;
        PreparedStatement psInsertRecord;
		String sqlInsertRecord;
        for (casts c: spe.myCasts){
        	for (String star: c.getStars()){
        		String[] starName = star.split(" ");
        		if (starName.length > 1){
        			starName[0].replace("\"", "");
        			starName[1].replace("\"", "");
        			if (starName[1].contains("\"")){
        				starName[1] = "the";
        			}
        			if (starName[1].contains("\\")){
        				starName[1] = "Fonda";
        			}
	        		starName[0].replace("\\", "");
	        		starName[1].replace("\\", "");
	        		c.getTitle().replace("\"", "");
	        		System.out.println(starName[1]);
		//        		c.getTitle().replace("\\", "");
		        		
		        		c.getTitle().replace("the\"", "the");
		        		 rs = statement.executeQuery("Select m.id as movieID, s.id as starID from movies m, stars s"
		        			+ " where m.title=\"" + c.getTitle() + "\" and s.first_name=\"" + starName[0] + "\" and s.last_name=\""
		        			+ starName[1] + "\""); 
        			
        		}
        		else{
        			starName[0].replace("\\", "");
            		c.getTitle().replace("\"", "");
        			rs = statement.executeQuery("Select m.id as movieID, s.id as starID from movies m, stars s"
                			+ " where m.title=\"" + c.getTitle() + "\" and s.first_name= '' and s.last_name=\""
                			+ starName[0] + "\"");
        		}
        		 
        		sqlInsertRecord = "INSERT INTO stars_in_movies (star_id, movie_id) values(?, ?)";
        		try {
        	           dbcon.setAutoCommit(false);

        	           psInsertRecord = dbcon.prepareStatement(sqlInsertRecord);
        	           
        	           while (rs.next()){
        	        	   psInsertRecord.setString(1, rs.getString("starID"));
        	        	   psInsertRecord.setString(2, rs.getString("movieID"));
        	        	   psInsertRecord.addBatch();
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
