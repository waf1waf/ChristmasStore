<%@page import="cc.nhf.*" %>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="css/report.css" media="all"/>
</head>
<body>
<%
    NeedManager needManager = NeedManager.getInstance();
    AreaManager areas = AreaManager.getInstance();
    ShiftManager shiftManager = ShiftManager.getInstance();
    boolean firstPage = true;
    int rows = 0;
    for (Shift shift : shiftManager.getShifts()) {
        if (!firstPage) {
            rows = 0;
%>
<p style="page-break-before:always"></p>
<%
    }
    firstPage = false;
    for (Area area : areas.getAreas()) {
        int nStillNeed = needManager.stillNeed(area.getId(), shift.getId());
        if ((rows + 2 + nStillNeed) > 30) {
            rows = 0;
%>
<p style="page-break-before:always"></p>
<%
    }
    if (nStillNeed > 0) {
        rows += 2;
%>
<table>
    <col width="200"/>
    <col width="200"/>
    <col width="200"/>
    <col width="50"/>
    <tr>
        <th style="background-color:darkgreen;color:white;text-align:left;" colspan="2"><%=area.getName() %>
            (Need: <%=nStillNeed%>)
        </th>
        <th style="background-color:darkgreen;color:white;text-align:right;" colspan="2"><%=shift.getName() %>
        </th>
    </tr>
    <tr>
        <th>Name</th>
        <th>Email</th>
        <th>Organization</th>
        <th>Count</th>
    </tr>
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
</table>
<br/>
<%
            }
        }
    }
%>
</body>
</html>
