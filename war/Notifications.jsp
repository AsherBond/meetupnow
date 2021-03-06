<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="javax.jdo.PersistenceManager" %>
<%@ page import="javax.jdo.Query" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.List" %>
<%@ page import="meetupnow.MeetupUser" %>
<%@ page import="meetupnow.PMF" %>
<%@ page import="meetupnow.NewsItem" %>
<%@ page import="org.scribe.oauth.*" %>
<%@ page import="org.scribe.http.*" %>
<%@ page import="java.util.StringTokenizer" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.TimeZone" %>
<%@ page import="java.text.DateFormat" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	<title>Meetup Now</title>
	<link rel="stylesheet" href="css/reset.css" type="text/css" />
	<link rel="stylesheet" href="css/meetupnow.css" type="text/css" />
	
	<%@ include file="jsp/cookie.jsp" %>
	<%@ include file="jsp/declares.jsp" %>
</head>
<body id="meetupNowBody">
	
<%@ include file="jsp/header.jsp" %>
<%

Calendar cal = Calendar.getInstance();
DateFormat df = DateFormat.getInstance();
df.setTimeZone(TimeZone.getTimeZone("GMT-4"));

List<NewsItem> newsFeed = new ArrayList<NewsItem>();
Query newsQuery = pm.newQuery(NewsItem.class);
newsQuery.declareParameters("long startdate");
newsQuery.setFilter("timeCreated > startdate");
newsQuery.setOrdering("timeCreated descending");
			try {
				newsFeed = (List<NewsItem>) newsQuery.execute(0);
				
%>
<div id="mn_page">
	<div id="mn_pageBody">
		<div id="mn_context">
			<div id="mn_document">
				<div id="mn_box">
					<div class="d_box">
						<div class="d_boxBody">
							<div class="d_boxHead">
								
							</div>
							<div class="d_boxSection">
								<div id="d_boxContent">
									<div id="mn_geoListContext">
										<div id="mn_geoListHeader">
NEWS FEED
										</div><!-- mn_geoListHeader -->
<%
	for (int i = 0; i < newsFeed.size(); i++) {
		cal.setTimeInMillis(newsFeed.get(i).getTimeCreated());
		if (newsFeed.get(i).getType().equals("comment")) {
%>
<span class="mn_geoListItem">
<span class="mn_geoListItem_title"><i><%=newsFeed.get(i).getName()%></i> commented on event
<a href="<%=newsFeed.get(i).getLink()%>">
<b>
<%
			if (newsFeed.get(i).getEvConName() == null) {
				StringTokenizer st = new StringTokenizer(newsFeed.get(i).getLink(),"?");
				st.nextToken();
%>

<%=st.nextToken()%>

<%	
			}
			else {
%>

<%=newsFeed.get(i).getEvConName()%>

<%
			}
%>
</b>
</a>
:</span><br>
<b><%=newsFeed.get(i).getMessage() %></b> <i> @ <%=df.format(cal.getTime())%></i>

</span>
<%
		}
		else if (newsFeed.get(i).getType().equals("event_create")) {
%>
<span class="mn_geoListItem">
<span class="mn_geoListItem_title"><i><%=newsFeed.get(i).getName()%></i> created a new event in topic
<%=newsFeed.get(i).getContainerName()%>:</span><br>
<a href="<%=newsFeed.get(i).getLink()%>">
<b>
<%=newsFeed.get(i).getEvConName()%>
</b>
</a>
: <%=newsFeed.get(i).getMessage() %> <i> @ <%=df.format(cal.getTime())%></i>

</span>

<%
		}
		else if (newsFeed.get(i).getType().equals("event_rsvp")) {
%>
<span class="mn_geoListItem">
<span class="mn_geoListItem_title"><i><%=newsFeed.get(i).getName()%></i> is hitting up 
<a href="<%=newsFeed.get(i).getLink()%>">
<b>
<%
			if (newsFeed.get(i).getEvConName().equals("")) {
%>
an event
<%
			} else {
%>
<%=newsFeed.get(i).getEvConName()%>
<%
			}
%>

</b>
</a> in topic
<%=newsFeed.get(i).getContainerName()%>:</span><br>
<i> @ <%=df.format(cal.getTime())%></i>

</span>

<%
		}
		else {
%>
<%=newsFeed.get(i).getMessage() %> <br>
<%
		}
		
	}
%>


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
	</div><!-- mn_pageBody -->
</div><!-- mn_page -->
<%
			} finally {
				query.closeAll();
			}
%>

<%@ include file="jsp/footer.jsp" %>
</body>
</html>
