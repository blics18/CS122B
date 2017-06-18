package project3;

public class stars {
	private String firstName;
	private String lastName;
	private String dob;
	private String photoURL;
	
	
	public void setFirstName (String firstName){
		this.firstName= firstName;
	}
	
	public void setLastName (String lastName){
		this.lastName = lastName;
	}
	
	public void setDOB (String DOB){
		this.dob = DOB;
	}
	
	public void setPhotoURL(String photoURL){
		this.photoURL = photoURL;
	}
	
	public String getFirstName(){
		return firstName;
	}
	
	public String getLastName(){
		return lastName;
	}
	
	public String getDOB(){
		return dob;
	}
	public String getPhotoURL(){
		return photoURL;
	}
}
