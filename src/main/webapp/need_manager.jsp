<%@ page import="cc.nhf.*" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.StringTokenizer" %>
<%
	// Get instances of our collection classes
	AreaManager areas = AreaManager.getInstance();
	ShiftManager shiftManager = ShiftManager.getInstance();
	NeedManager needManager = NeedManager.getInstance();
	
	// If update is performed, loop through the parameters and update the database
	if (request.getParameter("submit") != null && request.getParameter("submit").equals("Update")) {
		Enumeration<?> en = request.getParameterNames();
		while (en.hasMoreElements()) {
			String paramName = (String) en.nextElement();
			if (paramName.startsWith("a_")) {
				StringTokenizer st = new StringTokenizer(paramName,"_");
				st.nextToken();
				Area area = areas.getAreaById(Integer.parseInt(st.nextToken()));
				Shift shift = shiftManager.getShift(Integer.parseInt(st.nextToken()));
				int count = 0;
				try {
					count = Integer.parseInt(request.getParameter(paramName));
				} catch (Exception ignore) {
				}
				Need need = needManager.getNeed(area.getId(), shift.getId());
				if (need == null) {
					needManager.addNeed(area.getId(), shift.getId(), count);
				} else {
					if (count != needManager.getNeed(area.getId(), shift.getId()).getCount()) {
						needManager.setCount(area.getId(), shift.getId(), count);
					}
				}
			}
		}
 	}
 %>
<html>
	<head>
		<title>Need By Area</title>
		<%@include file="menu.jsp" %>
		<link rel="stylesheet" type="text/css" href="css/nhf.css"/>
		<link rel="stylesheet" type="text/css" href="css/print.css" media="print"/>
	</head>
	<body>
<form name="myForm" action="need_manager.jsp">
<h1>Need By Area</h1>
<table>
<tr>
<th>&nbsp;</th>
<%	for (Shift shift : shiftManager.getShifts()) { %>
<th><%=shift.getName() %></th>
<%	} %>
</tr>
<%	for (Area area : areas.getAreas()) { %>
<tr>
	<td><%=area.getName().replace(" ","&nbsp;") %></td>
<%		for (Shift shift : shiftManager.getShifts()) { %>
	<td style="text-align:center"><label>
		<input type="text" size="2" name="a_<%=area.getId() %>_<%=shift.getId() %>"
			   value="<%=needManager.getCount(area.getId(), shift.getId()) %>"/>
	</label></td>
<%		} %>
</tr>
<%	} %>
</table>
<br/>
<input type="submit" name="submit" value="Update"/>
<br/>
</form>
</body>
</html>
