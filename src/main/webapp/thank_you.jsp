<%@ page import="cc.nhf.*" %>
<%
    VolunteerManager volunteerManager = VolunteerManager.getInstance();
    Volunteer volunteer = volunteerManager.getVolunteer(Integer.parseInt(request.getParameter("volunteerId")));
    if (volunteer != null)
        session.setAttribute("volunteerId", volunteer.getId());
%>
<html>
<head>
    <title>Thank You Page</title>
    <script>
        window.location.href = "/index.jsp";
    </script>
</head>
<body>
<p>Should be heading back to the main page</p>
</body>
</html>
