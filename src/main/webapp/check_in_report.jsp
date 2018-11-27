<%@page import="java.util.*" %>
<%@page import="cc.nhf.*" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/report.css" media="all"/>
</head>
<body>
<%
    ReservationManager reservationManager = ReservationManager.getInstance();
    ShiftManager shiftManager = ShiftManager.getInstance();
    VolunteerManager volunteerManager = VolunteerManager.getInstance();
    OrganizationManager organizationManager = OrganizationManager.getInstance();
    for (Shift shift : shiftManager.getShifts()) {
%>
<p style="page-break-before:always"></p>
<table>
    <col width="200"/>
    <col width="50"/>
    <col width="200"/>
    <tr>
        <th style="background-color:darkgreen;color:white;text-align:left;" colspan="4"><%=shift.getName() %>
        </th>
    </tr>
    <tr>
        <th width="25%">Name</th>
        <th width="40%">Organization</th>
        <th width="10%">Count</th>
        <th width="25%">Area</th>
    </tr>
    <%
        for (Volunteer volunteer : volunteerManager.getVolunteers()) {
            ArrayList<Reservation> reservationList = reservationManager.getReservationsByVolunteer(volunteer.getId());
            for (Reservation reservation : reservationList) {
                if (reservation.getShift().getId() == shift.getId()) {
                    int organizationId = reservation.getVolunteer().getOrganizationId();
                    String organizationName = reservation.getVolunteer().getOtherOrganization();
                    if (organizationId > 0 && organizationId < 99999) {
                        Organization organization = organizationManager.getOrganization(organizationId);
                        if (organization != null) {
                            organizationName = organization.getName();
                        } else {
                            organizationName = "Invalid organization ID: " + organizationId;
                        }
                    }
    %>
    <tr>
        <td><%=reservation.getVolunteer().getLastName() %>,&nbsp;<%=reservation.getVolunteer().getFirstName() %>
        </td>
        <td><%=organizationName%></td>
        <td style="text-align:right;"><%=reservation.getCount() %>
        </td>
        <td><%=reservation.getArea().getName() %>
        </td>
    </tr>
    <%
                }
            }
        }
    %>
</table>
<br/>
<%
    }
%>
</body>
</html>
