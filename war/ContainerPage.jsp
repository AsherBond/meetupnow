<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="javax.jdo.Query" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.List" %>
<%@ page import="meetupnow.MeetupUser" %>
<%@ page import="meetupnow.PMF" %>
<%@ page import="meetupnow.UserInfo" %>
<%@ page import="meetupnow.RegDev" %>
<%@ page import="java.io.IOException" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.scribe.oauth.*" %>
<%@ page import="org.scribe.http.*" %>
<%@ page import="org.json.*" %>
<%@ page import="javax.servlet.http.Cookie" %>
<%@ page import="meetupnow.OAuthServlet" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title>Meetup Now - Topic</title>
	<link rel="stylesheet" href="css/reset.css" type="text/css" />
	<link rel="stylesheet" href="css/meetupnow.css" type="text/css" />
	<link rel="stylesheet" type="text/css" media="all" href="css/grids.css">
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"></script>
	<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
	<script src="http://api.simile-widgets.org/timeline/2.3.1/timeline-api.js?bundle=true" type="text/javascript"></script>

	<script type="text/javascript" src="/js/container.js"></script>

		<%

		String c_id = "";
		String c_name = "";
		String MUID = "";
		%>
	
	<script type="text/javascript">

		
		function loadEvents(){
		<%@ include file="jsp/cookie.jsp" %>
		<%@ include file="jsp/declares.jsp" %>
		


		<%
		if (request.getQueryString() != null) {
			c_id = request.getQueryString();
		} else {
			c_id = "654";
		}
		RegDev sg = new RegDev();
		if (!key.equals("empty")) {
			try {
				users = (List<MeetupUser>) query.execute(key);
				if (users.iterator().hasNext()) {
					MUID = users.get(0).getID();
					Token accessToken = new Token(users.get(0).getAccToken(),users.get(0).getAccTokenSecret());
					API_URL = "http://api.meetup.com/ew/events/?status=upcoming&container_id="+c_id+"&page=20&fields=rsvp_count";
					APIrequest = new Request(Request.Verb.GET, API_URL);
					scribe.signRequest(APIrequest,accessToken);
					APIresponse = APIrequest.send();
					JSONObject json = new JSONObject();
					JSONArray results;
					try {
						json = new JSONObject(APIresponse.getBody());
						results = json.getJSONArray("results");
						c_name = results.getJSONObject(0).getJSONObject("container").getString("name");
						for (int i = 0; i < results.length(); i++) {
							if (users.get(0).isAttending(results.getJSONObject(i).getString("id"))) {
								results.getJSONObject(i).put("attending", "yes");
							} else {
								results.getJSONObject(i).put("attending", "no");
							}				
						}
					}
					catch (JSONException j){

					}
					%>var data = <%=json.toString()%><%
				}
			}
			finally {

			}
		}
		else {

			API_URL = "http://api.meetup.com/ew/events?status=upcoming&radius=25.0&order=time&page=20&fields=rsvp_count&container_id="+c_id;
			APIresponse = sg.submitURL(API_URL);
			JSONObject json = new JSONObject();
					JSONArray results;
					try {
						json = new JSONObject(APIresponse.getBody());
						results = json.getJSONArray("results");
						c_name = results.getJSONObject(0).getJSONObject("container").getString("name");
					} catch (JSONException j){

					}
			%>var data = <%=APIresponse.getBody().toString()%><%
	
		}
		%>

			use_everywhere(data);

		}

	</script>


</head>
<body onload="loadEvents()" onresize="onResize();">

<div id="wrap">
	<%@ include file="jsp/header.jsp" %>
	<div id="main">
		<div id="contentTop">
			<div id="contentTopBody">
				<div id="topicActions">
				<%
						Query userQuery = pm.newQuery(UserInfo.class);
						userQuery.setFilter("user_id == idParam");
						userQuery.declareParameters("String idParam");
						try {
							List<UserInfo> profiles = (List<UserInfo>) userQuery.execute(MUID);
							if (profiles.size() > 0) {
								String[] groups = profiles.get(0).getGroupArray();
								if (profiles.get(0).isMember(c_id)) {
				%>
				
				
					<a href="/UserPrefs.jsp" class="actionBtn notifyCancelBtn fltlft">Receiving Group Notifications</a>
				
				<%
								}
								else {
									if (!key.equals("empty")) {
				%>

				<a href="/setprefs?id=<%=users.get(0).getID()%>&action=add&callback=<%=request.getRequestURI()+"?"+request.getQueryString()%>&group=<%=c_id %>" class="actionBtn notifyStartBtn fltlft">Receive Group Notifications</a>
				<%		
									} else {
%>
				<a href="/UserPrefs.jsp" class="actionBtn notifyStartBtn fltlft">Receive Group Notifications</a>
<%
									}
								}
							}
						} finally {
							userQuery.closeAll();
						}

				%>
				
					<a href="/CreateEvent.jsp?<%=c_id%>" class="actionBtn notifyStartBtn fltrt"> Create An Event in this Topic</a>
				</div> <!-- end #topicActions -->
				<div id="map_canvasContentBottom">
					
					<div id="map_canvas">

					</div><!-- end #map_canvas -->
					
				</div> <!-- end #map_canvasContentBottom -->
				
				<div id="commentFeedContext">
					<div id="activityFeed">
						<span class="title">Events in <%=c_name%></span>
						<div id="activity">
						
						</div> <!-- end #activity -->
					</div> <!-- end #activityFeed -->
				</div> <!-- end #commentFeedContext -->
				
			</div> <!-- end contentTopBody -->
		</div> <!-- end #contentTop -->
	</div> <!-- end #main -->
</div> <!-- end #wrap -->

<%@ include file="jsp/footer.jsp" %>

</body>
</html>
