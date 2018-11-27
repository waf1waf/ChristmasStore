<%@page import="cc.nhf.*" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/report.css" media="all"/>
</head>
<body>
<%
    NeedManager needManager = NeedManager.getInstance();
    ReservationManager reservationManager = ReservationManager.getInstance();
    AreaManager areaManager = AreaManager.getInstance();
    ShiftManager shiftManager = ShiftManager.getInstance();
    OrganizationManager organizationManager = OrganizationManager.getInstance();
    boolean firstPage = true;
    int rows = 0;
    for (Area area : areaManager.getAreas()) {
        if (!firstPage) {
            rows = 0;
%>
<p style="page-break-before:always"></p>
<%
    }
    firstPage = false;
    for (Shift shift : shiftManager.getShifts()) {
        if (rows + 4 + reservationManager.getReservationsByAreaAndShift(area, shift).size() > 34) {
            rows = 0;
%>
<p style="page-break-before:always"></p>
<%
    }
    if (needManager.getCount(area.getId(), shift.getId()) > 0) {
        rows += 4;
%>
<table>
    <col width="200"/>
    <col width="250"/>
    <col width="150"/>
    <col width="50"/>
    <tr>
        <th style="background-color:darkgreen;color:white;text-align:left;" colspan="2"><%=area.getName() %>
            (Need: <%=needManager.getCount(area.getId(), shift.getId()) %>)
        </th>
        <th style="background-color:darkgreen;color:white;text-align:right;" colspan="2"><%=shift.getName() %>
        </th>
    </tr>
    <tr>
        <th>Name</th>
        <th>Organization</th>
        <th>Adults</th>
        <th>Children</th>
    </tr>
    <%
        for (Reservation reservation : reservationManager.getReservationsByAreaAndShift(area, shift)) {
            ++rows;
            String organizationName = "";
            int organizationId = reservation.getVolunteer().getOrganizationId();
            if (organizationId > 0 && organizationId < 99999) {
                organizationName = organizationManager.getOrganization(reservation.getVolunteer().getOrganizationId()).getName();
            }
    %>
    <tr>
        <td><%=reservation.getVolunteer().getFirstName() %>&nbsp;<%=reservation.getVolunteer().getLastName() %>
        </td>
        <td><%=organizationName%>
        </td>
        <td style="text-align: right"><%=reservation.getVolunteer().getAdults() %>
        </td>
        <td style="text-align: right;"><%=reservation.getVolunteer().getChildren() %>
        </td>
    </tr>
    <%
        }
    %>
    <%
        for (int i = 0; i < needManager.stillNeed(area.getId(), shift.getId()); ++i) {
            ++rows;
    %>
    <tr>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
    </tr>
    <%
        }
    %>
    <tr>
        <th colspan="3" style="text-align:right">Volunteers</th>
        <th style="text-align:right;"><%=reservationManager.getCountByAreaAndShift(area, shift) %>
        </th>
    </tr>
    <tr>
        <th colspan="3" style="text-align:right">Still Need</th>
        <th style="text-align:right;"><%=needManager.stillNeed(area.getId(), shift.getId()) %>
        </th>
    </tr>
</table>
<br/>
<%
            }
        }
    }
%>
</body>
</html>
