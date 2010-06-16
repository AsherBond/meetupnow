<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="javax.jdo.Query" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.List" %>
<%@ page import="meetupnow.MeetupUser" %>
<%@ page import="meetupnow.PMF" %>
<%@ page import="org.scribe.oauth.*" %>
<%@ page import="org.scribe.http.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title>Meetup Now</title>
	<link rel="stylesheet" href="css/reset.css" type="text/css" />
	<link rel="stylesheet" href="css/meetupnow.css" type="text/css" />
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
	<script type="text/javascript">
	  function initialize() {
	    var myLatlng = new google.maps.LatLng(-34.397, 150.644);
	    var myOptions = {
	      zoom: 8,
	      center: myLatlng,
	      mapTypeId: google.maps.MapTypeId.ROADMAP
	    }
	    var map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
	  }
	</script>
</head>
<body id="meetupNowBody" onload="initialize()">
	
<div id="mew_header">
	<div id="mew_headerBody">
		<div id="mew_logo">
			<a href="http://www.meetup.com/everywhere">
				<img src="images/meetup_ew.png" alt="Meetup" style="width: auto !important; height: auto !important">
			</a>
		</div><!-- mew_logo -->
		<div id="mew_userNav">
<%
		String key = "empty";
    		Cookie[] cookies = request.getCookies();
    		if (cookies != null) {
      			for (int i = 0; i < cookies.length; i++) {
        			if (cookies[i].getName().equals("meetup_access")) {
          				key = cookies[i].getValue();
        			}
      			}
    		}
		if (key.equals("empty")) {
%>
<a href="/oauth">Log In</a>
<%
		} else {
			//FIND USER			

			Properties prop = new Properties();
			prop.setProperty("consumer.key","12345");
			prop.setProperty("consumer.secret","67890");
			Scribe scribe = new Scribe(prop);
			PersistenceManager pm = PMF.get().getPersistenceManager();
			Query query = pm.newQuery(MeetupUser.class);
			query.setFilter("accToken == accTokenParam");
			query.declareParameters("String accTokenParam");
			try {
				List<MeetupUser> users = (List<MeetupUser>) query.execute(key);
					
%>
<p><%=users.get(0).getName()%>
<a href ="/logout?callback=">LOGOUT</a></p>
<%
			} finally {
				query.closeAll();
			}
		}
%>
</div>
	</div><!-- mew_headerBody -->
</div><!-- mew_header -->

<div id="mn_page">
	<div id="mn_pageBody">
		<div id="mn_context">
			<div id="mn_document">
				<div id="mn_box">
					<div class="d_box">
						<div class="d_boxBody">
							<div class="d_boxHead">
								<img src="images/mn_banner.png" alt="Meetup Now">
							</div>
							<div class="d_boxSection">
								<div id="d_boxContent">
										<div class="map_context">
											<!-- <span class="map_title title">Happening NOW near you...</span> -->
											<div id="map_canvasContainer">
												<div id="map_canvas">
										
												</div><!-- map_canvas -->
											</div><!-- map_canvasContainer -->
										</div><!-- map_context -->
										<div id="mn_description">
											<span class="subtitle">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua?</span>
											<span class="subtitle">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua?</span>
											<span class="title">Lorem ipsum!</span>
										</div><!-- mn_description -->
										<div id="mn_geoListContext">
											<div id="mn_geoListHeader">
												<span>Today in Sports<span>
											</div><!-- mn_geoListHeader -->
											<a href="#"><span class="mn_geoListItem">Flag Football</span></a>
											<div id="mn_geoListFooter">
										
											</div><!-- mn_geoListFooter -->
										</div><!-- mn_geoListContext -->
								</div><!-- d_boxContent -->
							</div><!-- d_boxSection -->
						</div><!-- d_boxBody -->
					</div><!-- d_box -->
				</div><!-- mn_box -->
			</div><!-- mn_document -->
		</div><!-- mn_context -->
		<a href="/MeetupNow">Meetup Now</a>
	</div><!-- mn_pageBody -->
</div><!-- mn_page -->
	<a href="/MeetupNow">Meetup Now</a><br>
	<a href="/MUNTest.jsp">API test call</a><br>
	<a href="/CreateEvent.jsp">Create Event</a>
</body>
</html>