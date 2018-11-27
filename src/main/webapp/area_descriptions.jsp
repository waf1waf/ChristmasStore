<%@page import="cc.nhf.*" %>
<%@page import="java.util.ArrayList" %>
<%
    AreaManager areas = AreaManager.getInstance();
    ArrayList<Area> areaList = areas.getAreas();
%>
<html>
<head>
    <title>Christmas Store Area</title>
    <link rel="stylesheet" type="text/css" href="css/nhf.css"/>
    <link rel="stylesheet" type="text/css" href="css/print.css" media="print"/>
</head>
<body>
<h1><img src="img/area_descriptions.png"/></h1>
<dl>
    <% for (Area area : areaList) { %>
    <dt><%=area.getName() %>
    </dt>
    <dd><%=area.getDescription() %><br/><em>You must be at least <%=area.getMinimumAge() %> years old to serve in this
        area without an adult working with you.</em></dd>
    <% } %>
</dl>
<a href="index.jsp">
    <button name="Return to Sign-up Page">Return to Christmas Store Sign-up Page</button>
</a>
</body>
</html>
