<%@page import="cc.nhf.*" %>
<%
    // Get instances of our collection classes
    AreaManager areas = AreaManager.getInstance();
    ShiftManager shiftManager = ShiftManager.getInstance();
    NeedManager needManager = NeedManager.getInstance();
    ReservationManager reservationManager = ReservationManager.getInstance();
%>
<html>
<head>
    <title>Still Need</title>
    <%@include file="menu.jsp" %>
    <link rel="stylesheet" type="text/css" href="css/nhf.css"/>
    <link rel="stylesheet" type="text/css" href="css/print.css" media="print"/>
</head>
<body>
<h1>Still Need</h1>
<table>
    <tr>
        <th>&nbsp;</th>
        <% for (Shift shift : shiftManager.getShifts()) { %>
        <th><%=shift.getName() %>
        </th>
        <% } %>
    </tr>
    <% for (Area area : areas.getAreas()) { %>
    <tr>
        <td><%=area.getName().replace(" ", "&nbsp;") %>
        </td>
        <% for (Shift shift : shiftManager.getShifts()) {
            String color = "white";
            int need = needManager.getCount(area.getId(), shift.getId());
            int have = reservationManager.getCountByAreaAndShift(area.getId(), shift.getId());
            if (have * 2 < need) {
                color = "red";
            } else if (have * 4 < need * 3) {
                color = "orange";
            }
        %>
        <td style="text-align:center;color:<%=color%>"><%=need - have%>&nbsp;/&nbsp;<%=need%></td>
        <% } %>
    </tr>
    <% } %>
</table>
<br/>
</body>
</html>
