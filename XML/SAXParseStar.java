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
import org.xml.sax.helpers.DefaultHandler;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SAXParseStar extends DefaultHandler  {
	ArrayList<stars> myStars;
	
	private String tempVal;
	
	//to maintain context
	private stars tempStars;
	
	public SAXParseStar(){
		myStars = new ArrayList<stars>();
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
			sp.parse("C:/Users/BL/Documents/CS122B/project3/src/project3/actors63.xml", this);
			
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
		if(qName.equalsIgnoreCase("actor")) {
			//create a new instance of employee
			tempStars = new stars();
			//tempEmp.setType(attributes.getValue("type"));
		}
	}
	
	public void characters(char[] ch, int start, int length) throws SAXException {
		tempVal = new String(ch,start,length);
	}
	
	public void endElement(String uri, String localName, String qName) throws SAXException {
		try{
			if(qName.equalsIgnoreCase("actor")) {
				//add it to the list
				myStars.add(tempStars);
				
			}else if (qName.equalsIgnoreCase("stagename")) {
				String[] actorName = tempVal.split(" ");

				if (actorName.length == 1){
					tempStars.setFirstName("");
					tempStars.setLastName(actorName[0]);
				}
				else {
					tempStars.setFirstName(actorName[0]);
					tempStars.setLastName(actorName[1]);
				}
								
			}else if (qName.equalsIgnoreCase("dob")) {
				String pattern = "[0-9]{4}";

				Pattern regex = Pattern.compile(pattern);
	
				Matcher m = regex.matcher(tempVal);

				
				if (tempVal.equals("")){
					tempStars.setDOB(null);
				}
				
				else if (!m.find() || tempVal.contains("~") || tempVal.contains("[") || tempVal.contains("]")) {
					System.out.println(tempStars.getFirstName() + " " + tempStars.getLastName() + " has an invalid DOB");
					System.out.println("We set " + tempStars.getFirstName() + " " + tempStars.getLastName() + " to be null\n");
					tempStars.setDOB(null);
					
				}
				else {
					tempStars.setDOB(tempVal + "/01/01");
				}
			}
				
//				if (tempVal.equals("") || tempVal.equals(" ")){
//					tempStars.setDOB(null);
//				}
////				else if (tempVal.contains("*") || tempVal.contains("n.a.") || tempVal.contains("dob") || tempVal.contains("bb") || tempVal.contains("~") || tempVal.contains("[") || tempVal.contains("]") ) {
//				else if ()
//					System.out.println(tempStars.getFirstName() + " " + tempStars.getLastName() + " has an invalid DOB");
//					System.out.println("We set " + tempStars.getFirstName() + " " + tempStars.getLastName() + " to be null\n");
//					tempStars.setDOB(null);
//				}
//				else {
//					tempStars.setDOB(tempVal + "/01/01");
//				}
//			}
		}
		catch(NumberFormatException e){
			tempStars.setFirstName(null);
			tempStars.setLastName(null);
		}
			
	}

	public static void main(String[] args) throws Exception{
		SAXParseStar spe = new SAXParseStar();
		spe.runExample();
		
		 String loginUser = "mytestuser";
	     String loginPasswd = "mypassword";
	     String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
	     
	     //Class.forName("org.gjt.mm.mysql.Driver");
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
        // Declare our statement
        Statement statement = dbcon.createStatement();
        		
        PreparedStatement psInsertRecord;
		String sqlInsertRecord;
		 
		sqlInsertRecord = "INSERT INTO STARS (first_name, last_name, dob, photo_url) values(?, ?, ?, ?)";
		try {
           dbcon.setAutoCommit(false);

           psInsertRecord = dbcon.prepareStatement(sqlInsertRecord);
           
           for (stars s : spe.myStars){
	 			psInsertRecord.setString(1, s.getFirstName());
	 			psInsertRecord.setString(2, s.getLastName());
	 			psInsertRecord.setString(3, s.getDOB());
	 			psInsertRecord.setString(4, "");
	 			psInsertRecord.addBatch();
      	   }

           psInsertRecord.executeBatch();
           dbcon.commit();
           
       } catch (SQLException e) {
       		e.printStackTrace();
       }
		
	}

}
