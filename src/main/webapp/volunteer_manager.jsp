<%@ page import="cc.nhf.OrganizationManager" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="cc.nhf.*" %>
<%@ page import="java.util.Objects" %>
<%
    VolunteerManager volunteerManager = VolunteerManager.getInstance();
    String firstName = "";
    String lastName = "";
    String phoneNumber = "";
    String emailAddress = "";
    String add_or_update = "Add";
    int organizationId = 0;
    String otherOrganization = "";
    int adults = 0;
    int children = 0;
    int youngest = 18;
    int id = 0;
    Logger logger = Logger.getLogger("volunteer_manager.jsp");
    OrganizationManager organizationManager = OrganizationManager.getInstance();
    ArrayList<Organization> organizationList = organizationManager.getOrganizations();
    Collections.sort(organizationList);
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Edit") && request.getParameter("id") != null && !request.getParameter("id").equals("")) {
        id = Integer.parseInt(request.getParameter("id"));
        Volunteer volunteer = volunteerManager.getVolunteer(id);
        firstName = volunteer.getFirstName();
        lastName = volunteer.getLastName();
        emailAddress = volunteer.getEmailAddress();
        phoneNumber = volunteer.getPhoneNumber();
        organizationId = volunteer.getOrganizationId();
        otherOrganization = volunteer.getOtherOrganization();
        adults = volunteer.getAdults();
        children = volunteer.getChildren();
        youngest = volunteer.getYoungest();
        add_or_update = "Update";
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Update")) {
        String oidString = request.getParameter("organizationId");
        if (oidString == null || oidString.equals("")) {
            oidString = "1";
        }
        phoneNumber = request.getParameter("phoneNumber") == null ? "" : request.getParameter("phoneNumber");
        phoneNumber = phoneNumber.replaceAll("[^0-9]", "");
        if (phoneNumber.length() == 7) {
            phoneNumber = "919" + phoneNumber;
        }
        if (phoneNumber.length() == 10) {
            phoneNumber = "(" + phoneNumber.substring(0, 3) + ") " + phoneNumber.substring(3, 6) + "-" + phoneNumber.substring(6);
        }
        final int id1 = Integer.parseInt(request.getParameter("id"));
        try {
            adults = Integer.valueOf(request.getParameter("adults"));
        } catch (Exception e) {
            adults = 0;
        }
        try {
            children = Integer.valueOf(request.getParameter("children"));
        } catch (Exception e) {
            children = 0;
        }
        try {
            youngest = Integer.valueOf(request.getParameter("youngest"));
        } catch (Exception e) {
            youngest = -1;
        }
        volunteerManager.updateVolunteer(id1,
                request.getParameter("firstName").trim(),
                request.getParameter("lastName").trim(),
                request.getParameter("emailAddress").trim(),
                phoneNumber.trim(),
                Integer.parseInt(oidString),
                request.getParameter("otherOrganization").trim(),
                adults,
                children,
                youngest);
        ReservationManager reservationManager = ReservationManager.getInstance();
        // Update the counts in the reservation records
        for (Reservation reservation : reservationManager.getReservationsByVolunteer(id1)) {
            int count = volunteerManager.getVolunteer(id1).getPeople();
            reservation.setCount(count);
            reservationManager.updateReservationCount(reservation, count);
        }
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Add")) {
        String oidString = request.getParameter("organizationId");
        if (oidString == null || oidString.equals("")) {
            oidString = "1";
        }
        volunteerManager.addVolunteer(request.getParameter("firstName"),
                request.getParameter("lastName"),
                request.getParameter("emailAddress"),
                request.getParameter("phoneNumber"),
                Integer.parseInt(oidString),
                request.getParameter("otherOrganization"), adults, children, youngest);
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Reservations")) {
        id = Integer.parseInt(request.getParameter("id"));
        application.getRequestDispatcher("/reservation_manager.jsp?volunteerId=" + id).forward(request, response);
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Delete")) {
        volunteerManager.deleteVolunteer(Integer.parseInt(request.getParameter("id")));
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Promote")) {
        // If we promote an organization, we want to find all users with that name and change their otherOrganization
        // to the organization and clear the otherOrganization field
        Volunteer p = volunteerManager.getVolunteer(Integer.parseInt(request.getParameter("id")));
        String otherOrganizationName = p.getOtherOrganization();
        Organization organization;
        if (otherOrganizationName != null && !otherOrganizationName.trim().equals("")) {
            organization = organizationManager.findOrganizationByName(otherOrganizationName);
            if (organization == null && !otherOrganizationName.trim().equals("")) {
                organizationManager.addOrganization(otherOrganizationName);
            }
        }
        organization = organizationManager.findOrganizationByName(otherOrganizationName);
        for (Volunteer volunteer : volunteerManager.getVolunteers()) {
            if (Objects.requireNonNull(otherOrganizationName).equalsIgnoreCase(volunteer.getOtherOrganization())) {
                volunteerManager.updateVolunteer(volunteer.getId(), volunteer.getFirstName(), volunteer.getLastName(), volunteer.getEmailAddress(), volunteer.getPhoneNumber(), organization.getId(), "", volunteer.getAdults(), volunteer.getChildren(), volunteer.getYoungest());
            }
        }
    }
    ArrayList<Volunteer> volunteerList = volunteerManager.getVolunteers();
%>
<html>
<head>
    <title>Volunteers Page</title>
    <%@include file="menu.jsp" %>
    <link rel="stylesheet" type="text/css" href="css/nhf.css"/>
    <link rel="stylesheet" type="text/css" href="css/print.css" media="print"/>
    <script type="text/javascript">
        function confirmDelete(name) {
            return confirm("Are you sure you want to delete " + name + "?");
        }
    </script>
</head>
<body onload="document.myForm.firstName.focus()">
<form method="post" name="myForm" action="volunteer_manager.jsp"
      onkeypress="if (13===event.keyCode) { document.myForm.submit.value='Add'; document.getElementById('submit').click(); return false; }">
    <h1>Volunteers</h1>
    <table>
        <tr>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Phone Number</th>
            <th>Email Address</th>
            <th>Organization</th>
            <th>Other Organization</th>
            <th>Adults</th>
            <th>Children</th>
            <th>Youngest</th>
            <th>Action</th>
        </tr>
        <tr>
            <td><label><input type="text" name="firstName" size="10" value="<%=firstName%>"/></label></td>
            <td><label><input type="text" name="lastName" size="10" value="<%=lastName%>"/></label></td>
            <td><label><input type="text" name="phoneNumber" size="6" value="<%=phoneNumber%>"/></label></td>
            <td><label><input type="text" name="emailAddress" size="10" value="<%=emailAddress%>"/></label></td>
            <td><label><select name="organizationId">
                <%
                    for (Organization organization : organizationList) {
                        if (add_or_update.equals("Update") && organization.getId() == organizationId) {
                %>
                <option value="<%=organization.getId()%>" selected><%=organization.getName()%>
                </option>
                <% } else { %>
                <option value="<%=organization.getId()%>"><%=organization.getName()%>
                </option>
                <%
                        }
                    }
                %>
                <option value="99999" id="99999">-OTHER-</option>
                <option value="0" id="0">-NONE-</option>
            </select></label></td>
            <td><label><input type="text" name="otherOrganization" size="20" value="<%=otherOrganization%>"/></label></td>
            <td><label><input type="text" name="adults" size="5" value="<%=adults %>"/></label></td>
            <td><label><input type="text" name="children" size="5" value="<%=children %>"/></label></td>
            <td><label><input type="text" name="youngest" size="5" value="<%=youngest %>"/></label></td>
            <td><input type="submit" name="submit" value="<%=add_or_update%>"/></td>
        </tr>
    </table>
    <br/>
    <table id="people_table" border="1">
        <tr>
            <th class="id">Id</th>
            <th class="lastName">Last&nbsp;Name</th>
            <th class="firstName">First&nbsp;Name</th>
            <th class="phoneNumber">Phone&nbsp;Number</th>
            <th class="emailAddress">Email&nbsp;Address</th>
            <th class="organizationId">Organization</th>
            <th class="otherOrganization">Other Organization</th>
            <th class="adults">Adults</th>
            <th class="children">Children</th>
            <th class="youngest">Youngest</th>
            <th class="reservations">Reservations</th>
            <th class="action">Action&nbsp;Buttons</th>
        </tr>
        <%
            for (Volunteer volunteer : volunteerList) {
                int orgId = volunteer.getOrganizationId();
                String organizationName = "";
                String otherOrganizationName = "";
                try {
                    switch (orgId) {
                        case 99999:
                            organizationName = "-OTHER-";
                            otherOrganizationName = volunteer.getOtherOrganization();
                            break;
                        case 0:
                            organizationName = "-NONE-";
                            otherOrganizationName = "";
                            break;
                        default:
                            organizationName = organizationManager.getOrganization(orgId).getName();
                            otherOrganizationName = "";
                            break;
                    }
                } catch (Exception e) {
                    logger.error(e.getLocalizedMessage());
                }
        %>
        <tr>
            <td class="id"><%=volunteer.getId() %>
            </td>
            <td class="lastName"><%=volunteer.getLastName() %>
            </td>
            <td class="firstName"><%=volunteer.getFirstName() %>
            </td>
            <td class="phoneNumber"><%=volunteer.getPhoneNumber() %>
            </td>
            <td class="emailAddress"><a
                    href="mailto:<%=volunteer.getEmailAddress() %>?Subject=Christmas%20Store"><%=volunteer.getEmailAddress() %>
            </a></td>
            <td class="organizationId"><%=organizationName %>
            </td>
            <td class="otherOrganization"><%=otherOrganizationName %>
            </td>
            <td class="adults"><%=volunteer.getAdults() %>
            </td>
            <td class="children"><%=volunteer.getChildren() %>
            </td>
            <td class="youngest"><%=volunteer.getYoungest() == -1 ? "" : volunteer.getYoungest() %>
            </td>
            <td class="reservations"><%=volunteer.getReservationCount()%></td>
            <td class="action">
                <input type="submit" name="submit" value="Edit"
                       onmousedown="document.myForm.id.value=<%=volunteer.getId() %>;"/>
                <input type="submit" name="submit" value="Delete"
                       onmousedown="document.myForm.id.value=<%=volunteer.getId() %>;"
                       onclick="return confirmDelete('<%=volunteer.getFirstName() %> <%=volunteer.getLastName() %>')"/>
                <input type="submit" name="submit" value="Reservations"
                       onmousedown="document.myForm.id.value=<%=volunteer.getId() %>;"/>
                <% if (otherOrganizationName.length() > 0) { %>
                <input type="submit" name="submit" value="Promote"
                       onmousedown="document.myForm.id.value=<%=volunteer.getId() %>;"/>
                <% } %>
                <!--a href="mailto:<%=volunteer.getEmailAddress() %>?Subject=Christmas%20Store&body=Thank%20you%20for%20volunteering%20to%20help%20with%20The%20Christmas%20Store!%10%10A%20reminder%20email%20will%20be%20sent%20approximately%20one%20week%20before%20your%20volunteer%20shift.%10%10Please%20check%20in%20at%20The%20Annex%2015%20minutes%20before%20your%20shift%20begins.%10%10If%20you%20will%20not%20be%20able%20to%20work%20your%20shift,%20please%20inform%20the%20NHF%20office%20at%20(919)%20303-5266%20or%20email%20christmasstore@nhf.cc%20as%20soon%20as%20possible."><input type="button" value="Send Thank You"/></a-->
            </td>
        </tr>
        <% } %>
    </table>
    <br/>
    <input type="hidden" name="id" value="<%=id%>"/>
</form>
</body>
</html>
