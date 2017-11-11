<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*"
%>

<HEAD>
  <TITLE>Checkout</TITLE>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="../css/mainpage.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</HEAD>




<body style="background-color:#FDF5E6">
<div class="row">
    <div class="col-md-4">
        <button type="button" onclick="location.href='MainPage.jsp'">Home </button>
    </div>
    <div class="col-md-4">
        <H1 ALIGN="CENTER">Checkout</H1>
    </div>
    <div class="col-md-4">
        <FORM ACTION="/fabflix/shoppingCart.jsp">  
            <button style="float:right" type="button" onclick="location.href='shoppingCart.jsp'">My Cart</button> 
        </FORM>
    </div>
</div>


<FORM action="/fabflix/confirmation.jsp" style="padding-left: 20px" method="POST">
    <div style="padding-bottom: 20px">
        First Name: <input  type="text" name="firstname"> <br>
    </div>

    <div style="padding-bottom: 20px">
        Last Name: <input type="text" name="lastname"><br>
    </div>

    <div style="padding-bottom: 20px">
        Credit Card Number: <input type="text" name="creditcard"><br>
    </div>

    <div style="padding-bottom: 20px">
        Expiration Date: <input type="text" name="year" placeholder="YYYY"> - <input type="text" name="month" placeholder="MM"> - <input type="text" name="day" placeholder="DD"> <br>
    </div>
           
    <input type="submit" value="Submit">


</FORM>


</BODY>