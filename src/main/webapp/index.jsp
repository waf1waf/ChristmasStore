<%@ page import="cc.nhf.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.apache.log4j.Logger" %>
<html>
<head>
    <title>Christmas Store Sign-up Page</title>
    <link rel="icon" type="image/png" href="img/christmas_tree.png">
    <link rel="stylesheet" type="text/css" href="css/nhf.css"/>
    <link rel="stylesheet" type="text/css" href="css/nhf.css" media="print"/>
    <script type="text/javascript">
        <%
        ShiftManager shiftManager = ShiftManager.getInstance();
        AreaManager areas = AreaManager.getInstance();
        int volunteerId = -1;
        VolunteerManager volunteerManager = VolunteerManager.getInstance();
        Volunteer volunteer = null;
        if (null != session.getAttribute("volunteerId")) {
            volunteerId = (Integer) session.getAttribute("volunteerId");
            volunteer = volunteerManager.getVolunteer(volunteerId);
        }
        if (-1 == volunteerId && null != request.getParameter("volunteerId")) {
            volunteerId = Integer.parseInt(request.getParameter("volunteerId"));
            volunteer = volunteerManager.getVolunteer(volunteerId);
        }
        String firstName = null == volunteer ? "" : volunteer.getFirstName();
        String lastName = null == volunteer ? "" : volunteer.getLastName();
        String otherOrganization = null == volunteer ? "" : volunteer.getOtherOrganization();
        String adults = null == volunteer ? "0" : "" + volunteer.getAdults();
        String children = null == volunteer ? "0" : "" + volunteer.getChildren();
        String youngest = null == volunteer ? "0" : "" + volunteer.getYoungest();
        String oidString = null == volunteer ? "-1" : "" + volunteer.getOrganizationId();
        String phoneNumber = null == volunteer ? "" : volunteer.getPhoneNumber();
        String emailAddress = null == volunteer ? "" : volunteer.getEmailAddress();
        int organizationId = null == volunteer ? -1 : volunteer.getOrganizationId();
        NeedManager needManager = NeedManager.getInstance();
        ReservationManager reservationManager = ReservationManager.getInstance();
        ArrayList<Reservation> reservationList;
        if (-1 == volunteerId) {
            firstName = null == request.getParameter("firstName") ? "" : request.getParameter("firstName");
            lastName = null == request.getParameter("lastName") ? "" : request.getParameter("lastName");
            if (request.getParameter("organizationId") != null) {
                oidString = request.getParameter("organizationId");
            }
            if (oidString == null || oidString.isEmpty()) {
                oidString = "-1";
            }
            organizationId = Integer.parseInt(oidString);
            phoneNumber = request.getParameter("phoneNumber") == null ? "" : request.getParameter("phoneNumber");
            phoneNumber = phoneNumber.trim();
            phoneNumber = phoneNumber.replaceAll("[^0-9]", "");
            if (phoneNumber.length() == 7) {
                phoneNumber = "919" + phoneNumber;
            }
            if (phoneNumber.length() == 10) {
                phoneNumber = "(" + phoneNumber.substring(0,3) + ") " + phoneNumber.substring(3,6) + "-" + phoneNumber.substring(6);
            }
            emailAddress = request.getParameter("emailAddress") == null ? "" : request.getParameter("emailAddress");
            emailAddress = emailAddress.trim();
        }
        String shiftString = request.getParameter("shiftString") == null ? "" : request.getParameter("shiftString");
        String areaString = request.getParameter("areaString") == null ? "" : request.getParameter("areaString");
        if (request.getParameter("adults") != null) {
            adults = request.getParameter("adults");
        }
        if (request.getParameter("children") != null) {
            children = request.getParameter("children");
        }
        if (request.getParameter("youngest") != null) {
            youngest = request.getParameter("youngest");
        }
        String area = request.getParameter("area");
        String shift = request.getParameter("shift");
        int nYoungest = youngest == null ? -1 : Integer.valueOf(youngest);
        int nAdults = adults == null ? 0 : Integer.valueOf(adults);
        int nChildren = children == null ? 0 : Integer.valueOf(children);
        int areaID = area == null ? -1 : Integer.valueOf(area);
        int shiftID = shift == null ? -1 : Integer.valueOf(shift);
        int teamSize = nAdults + nChildren;

        String submit = request.getParameter("submit") != null ? request.getParameter("submit") : "";
        if (submit.equals("I Am Done")) {
            response.sendRedirect("/done.jsp");
        } else if (submit.equals("Delete")) {
            reservationManager.deleteReservation(Integer.parseInt(request.getParameter("reservationId")));
        } else if (submit.equals("New Team")) {
            session.setAttribute("NewTeam","true");
            response.sendRedirect("/done.jsp");
        } else if (submit.startsWith("CLICK")) {
            if (volunteer == null) {
                volunteerManager.addVolunteer(firstName, lastName, emailAddress, phoneNumber, organizationId, otherOrganization, nAdults, nChildren, nYoungest);
                volunteer = volunteerManager.getVolunteer(emailAddress, firstName, lastName, nAdults, nChildren, nYoungest);
                volunteerId = volunteer.getId();
                session.setAttribute("volunteerId", volunteerId);
            }
            Logger logger = Logger.getLogger("index.jsp");
            int workingAreaID = volunteer.isWorkingShift(shiftID);
            if (workingAreaID != -1) {
        %>
        alert("You are already signed up for that shift in the <%=areas.getAreaById(workingAreaID).getName() %> area.");
        clearResults();
        <%
            } else {
                reservationManager.addReservation(volunteer.getId(), areaID, shiftID, teamSize);
                application.getRequestDispatcher("/thank_you.jsp").forward(request, response);
            }
        } else if (volunteerId != -1 && shiftID != -1 && areaID != -1) {
            reservationManager.addReservation(volunteerId, areaID, shiftID, teamSize);
            application.getRequestDispatcher("/thank_you.jsp").forward(request, response);
        }
        %>
        let formSubmitted = false;

        function clearResults() {
            document.getElementById('results').style.visibility = 'hidden';
            let areaButton = document.getElementById("area_button");
            let shiftButton = document.getElementById("shift_button");
            if (document.myForm.adults.selectedIndex === 0 && document.myForm.children.selectedIndex === 0) {
                areaButton.disabled = true;
                shiftButton.disabled = true;
            } else {
                areaButton.disabled = false;
                shiftButton.disabled = false;
            }
            if (document.myForm.children.selectedIndex !== 0) {
                document.myForm.youngest.disabled = false;
                if (document.myForm.youngest.value === -1) {
                    areaButton.disabled = true;
                    shiftButton.disabled = true;
                } else {
                    areaButton.disabled = false;
                    shiftButton.disabled = false;
                }
            } else {
                document.myForm.youngest.disabled = true;
            }
            document.myForm.area.value = "-1";
            document.myForm.shift.value = "-1";
        }

        function updateOtherOrganization() {
            let option_user_selection = document.myForm.organizationId.options[document.myForm.organizationId.selectedIndex].text;
            if (option_user_selection === "-OTHER-") {
                document.myForm.otherOrganization.disabled = false;
                document.myForm.otherOrganization.focus();
                document.getElementById('otherOrganizationLabel').setAttribute("class", "required");
            } else {
                document.myForm.otherOrganization.value = "";
                document.myForm.otherOrganization.disabled = true;
                document.getElementById('otherOrganizationLabel').setAttribute("class", "not_required");
            }
        }

        function validateEmail(email) {
            email = email.trim();
            let re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return re.test(email);
        }

        function validatePhoneNumber(phone) {
            phone = phone.trim();
            phone = phone.replace(/[^\d]/g, '');
            return (phone.length === 7 || phone.length === 10);
        }

        function validateForm() {
            <%	if (shiftID != -1 && areaID != -1) { %>
            if (formSubmitted) {
                alert("Form submitted.");
            }
            if (document.myForm.firstName.value === "") {
                alert("Please fill in your first name.");
                document.myForm.firstName.focus();
                return false;
            }
            if (document.myForm.lastName.value === "") {
                alert("Please fill in the your last name.");
                document.myForm.lastName.focus();
                return false;
            }
            if (document.myForm.emailAddress.value === "") {
                alert("Please fill in your email address.");
                document.myForm.emailAddress.focus();
                return false;
            }
            if (document.myForm.organizationId.options.selectedIndex === 0) {
                alert("Please select an organization or specify -NONE- or specify -OTHER- and enter the name of your organization");
                document.myForm.organizationId.focus();
                return false;
            }
            let e = document.getElementById("organizationId");
            let organizationName = e.options[e.selectedIndex].value;
            if (organizationName === "99999" && document.myForm.otherOrganization.value.trim() === "") {
                alert("Please enter the name of your organization");
                document.myForm.otherOrganization.focus();
                return false;
            }
            if (!validateEmail(document.myForm.emailAddress.value)) {
                alert("Invalid email address.");
                return false;
            }
            if (document.myForm.phoneNumber.value) {
                if (!validatePhoneNumber(document.myForm.phoneNumber.value)) {
                    alert("Invalid phone number");
                    return false;
                }
            }
            formSubmitted = true;
            <% } %>
            return true;
        }
    </script>
</head>
<body>
<script type="text/javascript" language="JavaScript">ord = Math.random() * 10000000000000000;</script>
<div style="width:800px;margin-left:auto; margin-right:auto">
    <form method="post" name="myForm" action="index.jsp" onsubmit="return validateForm();">
        <h1 style="font-size: 200%"><img src="img/index.png"/></h1>

        <p><b>Click <a style="color:cyan" href="area_descriptions.jsp" target="_blank">here</a> for descriptions of all
            areas.</b>

        <p>

        <p><em>Each volunteer area has specific minimum age requirements for children volunteering without an adult.
            Children 12 years old or older can volunteer in any area with a parent or guardian alongside them in the
            same area at the same time.</em></p>
        <% if (volunteer == null) { %>
        <p>Please indicate the number of adults and children that wish to work together as a team, and specify the age
            of the youngest child.</p>
        <label>Number of adults:</label>
        <label>
            <select name="adults" onchange="clearResults()">
                <%
                    for (int i = 0; i < 21; ++i) { %>
                <option value="<%=i%>"
                        <%=i == nAdults ? " selected" : ""%>><%=i%>
                </option>
                <% } %>
            </select>
        </label>
        <br/>
        <label>Number of children:</label>
        <label>
            <select name="children" onchange="clearResults()">
                <%
                    for (int i = 0; i < 5; ++i) { %>
                <option value="<%=i%>"
                        <%=i == nChildren ? " selected" : ""%>><%=i%>
                </option>
                <% } %>
            </select>
        </label>
        <label>Age of youngest child:</label>
        <label>
            <select name="youngest" onchange="clearResults()"<%=nChildren == 0 ? " disabled" : ""%>>
                <option value="-1" id="-1">Select one...</option>
                <%
                    for (int i = 12; i < 18; ++i) { %>
                <option value="<%=i%>"
                        <%=nYoungest == i ? " selected" : ""%>><%=i%>
                </option>
                <% } %>
            </select>
        </label>
        <% } else {
            reservationList = reservationManager.getReservationsByVolunteer(volunteer.getId());
        %>
        Welcome <%=volunteer.getFirstName() %>, your team has <%=nAdults %> adults and <%=nChildren %> children.&nbsp;
        <input id="new_team" type="submit" name="submit" value="New Team"/><br/>
        <% if (volunteer.getReservationCount() > 0) { %>
        <br/>You have signed up for the following shift<%=reservationList.size() > 1 ? "s" : "" %>:<br/><br/>
        <input type="hidden" name="nAdults" value="<%=nAdults %>"/>
        <input type="hidden" name="nChildren" value="<%=nChildren %>"/>
        <%
            for (Reservation reservation : reservationList) {
                teamSize = reservation.getCount();

        %>
        <input type="submit" name="submit" value="Delete"
               onmousedown="document.myForm.reservationId.value=<%=reservation.getId() %>;">&nbsp;&nbsp;<%=reservation.getShift().getName() %>
        &nbsp;&nbsp;<%=reservation.getArea().getName() %><br/>
        <%      } %>
        <br/>
        <input id="done_button" type="submit" name="submit" value="I Am Done"<%=teamSize == 0 ? " disabled" : ""%>
               onmousedown="document.myForm.area.value=-1;document.myForm.shift.value=-1" style="font-size: 150%"/>
        <hr/>
        <p>If you would like to volunteer for an <span style="color: orange; ">additional</span> shift:</p>
        <%    } %>
        <% } %>
        <p>You can either choose an area to see available shifts for that area or choose a shift to see available areas
            for that shift. Start with whichever is more important to you.</p>
        <input id="area_button" type="submit" name="submit" value="Choose Area"<%=teamSize == 0 ? " disabled" : ""%>
               onmousedown="document.myForm.area.value=-1;document.myForm.shift.value=-1"/>
        <input id="shift_button" type="submit" name="submit" value="Choose Shift"<%=teamSize == 0 ? " disabled" : ""%>
               onmousedown="document.myForm.area.value=-1;document.myForm.shift.value=-1"/>

        <div id="results"><br/>
            <% if ((shiftID != -1) && (areaID != -1)) { %>
            <%
                shiftString = shiftManager.getShift(shiftID).getName();

                shiftString += "&nbsp;" + areas.getAreaById(areaID).getName();

                if (!shift.isEmpty()) {
            %>
            <span style="color:yellow">Signing up for shift: <%=shiftString%>.</span>
            <% }
                if (volunteer == null) {
            %>
            <br/><br/><label class="required">Required fields</label><br/><br/>
            <table style="margin-left:0">
                <tr>
                    <td style="text-align:right;"><label style="text-align:right;" class="required">First Name:</label>
                    </td>
                    <td><label>
                        <input type="text" name="firstName" value="<%=firstName%>"/>
                    </label></td>
                </tr>
                <tr>
                    <td style="text-align:right;"><label style="text-align:right;" class="required">Last Name:</label>
                    </td>
                    <td><label>
                        <input type="text" name="lastName" value="<%=lastName%>"/>
                    </label></td>
                </tr>
                <tr>
                    <td style="text-align:right;"><label style="text-align:right;" class="required">Email:</label></td>
                    <td><label>
                        <input size="40" type="text" name="emailAddress" value="<%=emailAddress%>"/>
                    </label></td>
                </tr>
                <tr>
                    <td style="text-align:right;"><label>Phone:</label></td>
                    <td><label>
                        <input size="15" type="text" name="phoneNumber" value="<%=phoneNumber%>"/>
                    </label></td>
                </tr>
                <tr>
                    <td style="text-align:right;"><label class="required">Organization:</label></td>
                    <td>
                        <label for="organizationId"></label><select name="organizationId" id="organizationId"
                                                                    onchange="updateOtherOrganization()">
                        <option value="-1" id="-1">Select one...</option>
                        <%
                            OrganizationManager organizationManager = OrganizationManager.getInstance();
                            ArrayList<Organization> organizationList = organizationManager.getOrganizations();
                            for (Organization organization : organizationList) { %>
                        <option id="<%=organization.getId()%>"
                                value="<%=organization.getId()%>"><%=organization.getName()%>
                        </option>
                        <% } %>
                        <option value="99999" id="99999">-OTHER-</option>
                        <option value="0" id="0">-NONE-</option>
                    </select>
                    </td>
                </tr>
                <tr>
                    <td style="text-align:right;"><label id="otherOrganizationLabel" class="not_required">Specify
                        Other</label></td>
                    <td><label>
                        <input size="40" type="text" name="otherOrganization" value="<%=otherOrganization%>" disabled/>
                    </label></td>
                </tr>
                <% } %>
                <tr>
                    <td colspan="2" style="text-align:center;"><input
                            style="background-color:red;color:white;font-weight:bold;font-size:200%" name="submit"
                            type="submit" value="CLICK HERE TO BOOK IT"/></td>
                </tr>
            </table>
            <% } %>

            <%
                if (submit.equals("Choose Area")) {
                    for (Area a : areas.getAreas()) {
                        if (needManager.maxStillNeedByArea(a.getId()) >= teamSize && (nAdults > 0 || nYoungest >= a.getMinimumAge())) {
            %>
            <input type="submit" name="submit" value="<%=a.getName() %>" title="<%=a.getDescription() %>"
                   onmousedown="document.myForm.area.value=<%=a.getId() %>;document.myForm.areaString.value='<%=a.getName() %>'"/><br/>
            <%
                        }
                    }
                }
                if (areaID == -1 && shiftID != -1) {
                    Shift s = shiftManager.getShift(shiftID);
                    for (Area a : areas.getAreas()) {
                        if (needManager.stillNeed(a.getId(), s.getId()) >= teamSize && (nAdults > 0 || nYoungest >= a.getMinimumAge())) {
            %>
            <input type="submit" name="submit" value="<%=a.getName() %>" title="<%=a.getDescription() %>"
                   onmousedown="document.myForm.area.value=<%=a.getId() %>;document.myForm.areaString.value='<%=a.getName() %>'"/><br/>
            <%
                        }
                    }
                }
                if (submit.equals("Choose Shift")) {
                    for (Shift s : shiftManager.getShifts()) {
                        if (needManager.maxStillNeedByShift(s.getId()) >= teamSize) {
                            if (volunteer == null || volunteer.isWorkingShift(s.getId()) == -1) {
            %>
            <input type="submit" name="submit" value="<%=s.getName()%>"
                   onmousedown="document.myForm.shift.value='<%=s.getId()%>';document.myForm.shiftString.value='<%=s.getName()%>'"/><br/>
            <%
                            }
                        }
                    }
                }
                if (areaID != -1 && shiftID == -1) {
                    Area a = areas.getAreaById(areaID);
                    for (Shift s : shiftManager.getShifts()) {
                        if (needManager.stillNeed(a.getId(), s.getId()) >= teamSize) {
                            if (volunteer == null || volunteer.isWorkingShift(s.getId()) == -1) {
            %>
            <input type="submit" name="submit" value="<%=s.getName()%>"
                   onmousedown="document.myForm.shift.value='<%=s.getId()%>';document.myForm.shiftString.value='<%=s.getName()%>'"/><br/>
            <%
                            }
                        }
                    }
                }
            %>
        </div>
        <input type="hidden" name="shift" value="<%=shiftID%>"/>
        <input type="hidden" name="area" value="<%=areaID%>"/>
        <input type="hidden" name="shiftString" value="<%=shiftString%>"/>
        <input type="hidden" name="areaString" value="<%=areaString%>"/>
        <input type="hidden" name="reservationId" value=""/>
        <input type="hidden" name="volunteerId" value="<%=volunteerId%>"/>
    </form>
</div>
</body>
</html>
