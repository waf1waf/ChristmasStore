<%@ page import="cc.nhf.*" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="java.util.ArrayList" %>
<%
    Logger logger = Logger.getLogger("done.jsp");
    VolunteerManager volunteerManager = VolunteerManager.getInstance();
    if (null != session.getAttribute("volunteerId")) {
        Volunteer volunteer = volunteerManager.getVolunteer((Integer) session.getAttribute("volunteerId"));
        String s = volunteer.getFirstName() + " " + volunteer.getLastName() + " <" + volunteer.getEmailAddress() + ">";
        logger.debug("to: " + s);
        String[] to = {s};
        String[] cc = {};
        String[] bcc = {"Wayne Franklin <waf1waf@gmail.com>"};
        String subject = "Thank You for Volunteering!";
        StringBuilder body = new StringBuilder("Thank you for volunteering to help with The Christmas Store!\n\n");
        ReservationManager reservationManager = ReservationManager.getInstance();
        ArrayList<Reservation> reservationList = reservationManager.getReservationsByVolunteer(volunteer.getId());
        logger.debug("reservationManager: " + reservationList);
        for (Reservation reservation : reservationList) {
            Area area = reservation.getArea();
            body.append("You have scheduled ");
            body.append(reservation.getCount());
            body.append(reservation.getCount() == 1 ? " volunteer" : " volunteers");
            body.append(" to work in the ");
            body.append(area.getName());
            body.append(" area on ");
            Shift shift = reservation.getShift();
            if (shift != null)
                body.append(shift.getName());
            body.append(".\n");
        }
        body.append("\nPlease check in at NHF West, 816 E. Williams St. in Apex, right next to New Horizons Fellowship.  There you will receive your volunteer badge and be directed to your Area Leader, who will show you where you will be serving and what you will be doing.\n\n");
        body.append("If you will not be able to work your shift, please contact New Horizons Fellowship at (919) 303-5266 or reply to this email as soon as possible.\n\n");
        body.append("--\nMorgan Whaley\nChristmas Store Administrator");

        Mail mail = new MailREST();
        boolean sent = mail.sendMail("localhost", to, cc, bcc, subject, body.toString());
        logger.info("after sendMail: sent = " + sent);
    }
    if (null != session.getAttribute("NewTeam")) {
        session.invalidate();
        response.sendRedirect("/index.jsp");
    }
%>
<html>
<head>
    <title>Thank You Page</title>
    <link rel="stylesheet" type="text/css" href="css/nhf.css"/>
    <link rel="stylesheet" type="text/css" href="css/print.css" media="print"/>
</head>
<body>
<h1><img src="img/thank_you.png" alt="Thank You!"/></h1>

<div style="width:800px;margin-left:auto;margin-right:auto">
    <p style="text-align:center;width:800px">Thank you for volunteering to help with The Christmas Store.

    <p>
</div>
<div style="width:800px;margin-left:auto;margin-right:auto">
    <p style="text-align:center;width:800px">You should receive a confirmation email in the next few minutes.</p>
</div>
<div style="width:800px;margin-left:auto;margin-right:auto">
    <p style="text-align:center;width:800px"><a href="index.jsp">
        <button>Return to Christmas Store Sign-Up</button>
    </a>
</div>
</body>
</html>
