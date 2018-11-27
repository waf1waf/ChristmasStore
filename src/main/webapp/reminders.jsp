<%@ page import="cc.nhf.*" %>
<%@ page import="org.apache.log4j.Logger" %>
<%
    Logger logger = Logger.getLogger("reminders.jsp");
    EmailManager emailManager = EmailManager.getInstance();
    Email email = emailManager.getEmail("reminder");

    int action_id = 0;
    String submit = request.getParameter("submit");
    if (submit != null && submit.equals("Save Letter Text")) {
        String subject = request.getParameter("subject");
        String letterBody = request.getParameter("letterBody");
        String bcc = email.getBcc();
        emailManager.updateEmail("reminder", subject, letterBody, bcc);
    } else if (submit != null && submit.equals("Send TEST EmailManager")) {
        Mail mail = new MailREST();
        int numberOfTestEmails = getNumberOfTestEmails(request, logger);
        int count = 0;
        VolunteerManager volunteerManager = VolunteerManager.getInstance();
        for (Volunteer volunteer: volunteerManager.getVolunteers()) {
            if (++count > numberOfTestEmails) return;
            composeAndSendEmail(request, mail, volunteer);
        }
    } else if (submit != null && submit.equals("Send REAL EmailManager")) {
        Mail mail = new MailREST();
        VolunteerManager volunteerManager = VolunteerManager.getInstance();
        for (Volunteer volunteer : volunteerManager.getVolunteers()) {
            composeAndSendEmail(request, mail, volunteer);
        }
    } else if (submit != null) {
        logger.warn("Invalid submit parameter " + submit);
    }
%>
<html>
<head>
    <title>Edit Reminder Letter Page</title>
    <%@include file="menu.jsp" %>
    <link rel="stylesheet" type="text/css" href="css/nhf.css"/>
    <link rel="stylesheet" type="text/css" href="css/print.css" media="print"/>
</head>
<body>
<form method="post" name="myForm" action="reminders.jsp"
      onkeypress="if (13===event.keyCode) { document.myForm.submit.value='Save'; document.getElementById('submit').click(); return false; }">
    <table style="width:500px ;margin-left: auto; margin-right: auto" id="reminders_table" border="1">
        <tr>
            <td colspan="3">
                Enter the text of the email.  Use {first_name} for the volunteer's first name, {last_name}
                for their last name and {reservationManager} where you want their reservationManager displayed.
            </td>
        </tr>
        <tr>
            <td>
                <label for="subject">Subject:</label>
            </td>
            <td colspan="2">
                <input type="text" id="subject" name="subject" style="width:100%" value="<%=email.getSubject()%>"/>
            </td>
        </tr>
        <tr>
            <td>
                <label for="letterBody">Letter Body:</label>
            </td>
            <td colspan="2">
                <textarea id="letterBody" name="letterBody" cols="120" rows="25"><%=email.getBody()%></textarea>
            </td>
        </tr>
        <tr>
            <td colspan="3" align="center">
                <input type="submit" name="submit" value="Save Letter Text"/>
                <input type="hidden" name="action_id" value="<%=action_id%>"/>
            </td>
        </tr>
        <tr>
            <td colspan="3">
                It is a good idea to test out the emailManager before actually sending out the emailManager to a couple of hundred
                people.  Put your own email address into the Test Email Address field and (optionally) specify a number
                of emailManager to generate.  If you don't specify a number of test emailManager, you will get one for each
                volunteer.  If you don't specify a test email address, you will be asked to confirm that you really want
                to send out the emailManager.
            </td>
        </tr>
        <tr>
            <td>
                <input type="submit" name="submit" value="Send TEST Emails"/>
                <input type="hidden" name="action_id" value="<%=action_id%>"/>
            </td>
            <td>
                <label for="testEmailAddress">Test Email Address:</label>
                <input type="text" id="testEmailAddress" name="testEmailAddress" style="width:40em" value=""/>
            </td>
            <td>
                <label for="numberOfTestEmails">Number of test emailManager:</label>
                <input type="text" id="numberOfTestEmails" name="numberOfTestEmails" style="width:3em" value=""/>
            </td>
        </tr>
        <tr>
            <td colspan="3" align="center">
                <input type="submit" name="submit" value="Send REAL Emails"/>
                <input type="hidden" name="action_id" value="<%=action_id%>"/>
            </td>
        </tr>
    </table>
    <br/>
</form>
</body>
</html>
<%!
    private void composeAndSendEmail(HttpServletRequest request, Mail mail, Volunteer volunteer) {
        String toEmailAddress = request.getParameter("testEmailAddress");
        String[] to = { toEmailAddress };
        String[] cc = {};
        String[] bcc = {};
        String subject = request.getParameter("subject");
        String body = request.getParameter("letterBody");
        body = body.replace("{first_name}", volunteer.getFirstName());
        body = body.replace("{last_name}", volunteer.getLastName());
        body = body.replace("{reservationManager}", volunteer.getReservationsString());
        mail.sendMail("localhost", to, cc, bcc, subject, body);
    }

    private int getNumberOfTestEmails(HttpServletRequest request, Logger logger) {
        int numberOfTestEmails = 1;
        try {
            numberOfTestEmails = Integer.parseInt(request.getParameter("numberOfTestEmails"));
        } catch(Exception e) {
            logger.warn("Invalid value passed for number of test emailManager to send: " + request.getParameter(("numberOfTestEmails")));
        }
        return numberOfTestEmails;
    }
%>
