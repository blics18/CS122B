package project3;

import java.util.ArrayList;

public class casts {

	private String title;
	private ArrayList<String> starsList;
	
	public casts(){
		starsList = new ArrayList<String>();
	}
	
	public String getTitle(){
		return title;
	}
	public void setTitle(String title){
		this.title = title;
	}
	
	public ArrayList<String> getStars(){
		return starsList;
	}
	
	public void setStars(String star){
		this.starsList.add(star);
	}
}
