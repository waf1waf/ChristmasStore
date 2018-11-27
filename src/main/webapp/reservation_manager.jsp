<%@ page import="cc.nhf.Reservation" %>
<%@ page import="cc.nhf.ReservationManager" %>
<%@ page import="cc.nhf.Volunteer" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="cc.nhf.VolunteerManager" %>
<%@ page import="java.util.ArrayList" %>
<%
	Logger logger = Logger.getLogger(this.getClass());
	VolunteerManager volunteerManager = VolunteerManager.getInstance();
	int action_id = 0;
	String volunteerId = request.getParameter("volunteerId");
	Volunteer specificVolunteer = null;
	if (volunteerId != null && !volunteerId.isEmpty()) {
		try {
			specificVolunteer = volunteerManager.getVolunteer(Integer.parseInt(volunteerId));
		} catch(Exception e) {
			logger.error("\n**************************************\nException: " + e.getLocalizedMessage() + "\nvolunteerId = \"" + volunteerId + "\"\n**************************************");
		}
	}

	// Get the reservationManager object
	ReservationManager reservationManager = ReservationManager.getInstance();

	// Handle delete reservation request
	if (request.getParameter("submit") != null && request.getParameter("submit").equals("Delete")) {
		reservationManager.deleteReservation(Integer.parseInt(request.getParameter("action_id")));
	}
	
	// Get the current reservation list
	ArrayList<Reservation> reservationList = reservationManager.getReservations();
%>
<html>
	<head>
		<title>Reservations Page</title>
		<%@include file="menu.jsp" %>
		<link rel="stylesheet" type="text/css" href="css/nhf.css"/>
		<link rel="stylesheet" type="text/css" href="css/print.css" media="print"/>
		<script type="text/javascript">
			function confirmDelete() {
				return confirm("Are you sure you want to delete this reservation?");
			}
		</script>
	</head>
	<body> 
<%
	String volId = "";
	if (specificVolunteer != null) {
		volId = "?volunteerId="+specificVolunteer.getId();
	}
%>
		<form method="post" name="myForm" action="reservation_manager.jsp<%=volId%>">
			<h1>Reservations</h1>
			<table id="people_table" border="1">
				<tr>
					<th>Name</th>
					<th>Phone&nbsp;Number</th>
					<th>Email&nbsp;Address</th>
					<th>Count</th>
					<th>Area</th>
					<th>Shift</th>
					<th class="action">Action&nbsp;Buttons</th>
				</tr>
<% for (Reservation reservation : reservationList) { 
	Volunteer volunteer = reservation.getVolunteer();
	if (specificVolunteer == null || specificVolunteer.getId() == volunteer.getId()) {
%>
				<tr>
					<td><%=volunteer.getFirstName() %>&nbsp;<%=volunteer.getLastName() %></td>
					<td class="phoneNumber"><%=volunteer.getPhoneNumber() %></td>
					<td class="emailAddress"><a href="mailto:<%=volunteer.getEmailAddress() %>?Subject=Christmas%20Store"><%=volunteer.getEmailAddress() %></a></td>
					<td style="text-align:center;"><%=reservation.getCount() %></td>
					<td><%=reservation.getArea().getName() %></td>
					<td><%=reservation.getShift().getName().replace(" ","&nbsp;") %></td>
					<td class="action">
						<input type="submit" name="submit" value="Delete" onmousedown="document.myForm.action_id.value=<%=reservation.getId() %>;" onclick="return confirmDelete()"/>
					</td>
				</tr>
<% 
		} 
	} 
%>
			</table>
			<br/>
			<input type="hidden" name="action_id" value="<%=action_id%>"/>
			<input type="hidden" name="volunteerId" value="<%=volunteerId == null ? "" : volunteerId %>">
		</form>
	</body>
</html>
