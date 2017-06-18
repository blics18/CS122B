package project3;

import java.util.ArrayList;
import java.util.HashMap;

public class movies {
	private String title;
	private Integer year;
	private String director;
	private ArrayList<String> titleList;
	private ArrayList<Integer> yearList;
	private HashMap<String, ArrayList<String>> genreList;
	
	public movies(){
		titleList = new ArrayList<String>();
		yearList = new ArrayList<Integer>();
		genreList = new HashMap<String, ArrayList<String>>();
	}
	public void setTitle(String title){
		this.title= title;
	}
	
	public void setYear(int year){
		this.year= year;
	}
	
	public void setDirector(String director){
		this.director = director;
	}
	
	public void setTitleList(String title){
		this.titleList.add(title);
	}
	
	public void setYearList(Integer year){
		this.yearList.add(year);
	}
	
	public void setGenreMap(String title, ArrayList<String> genreArray){
		this.genreList.put(title, genreArray);
	}
	
	public String getTitle(){
		return title;
	}
	
	public int getYear(){
		return year;
	}
	
	public String getDirector(){
		return director;
	}
	
	public ArrayList<String> getTitleList(){
		return titleList;
	}
	
	public ArrayList<Integer> getYearList(){
		return yearList;
	}
	
	public HashMap<String, ArrayList<String>> getGenreMap(){
		return genreList;
	}
	
}
