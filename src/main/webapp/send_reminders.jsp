<%@ page import="cc.nhf.*" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="java.nio.file.Files" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.util.ArrayList" %>
<%
    String jspPath = session.getServletContext().getRealPath("/");
    String textFilePath = jspPath + "reminder.txt";
    String template = new String(Files.readAllBytes(Paths.get(textFilePath)));
    Logger logger = Logger.getLogger("send_reminders.jsp");
    VolunteerManager volunteerManager = VolunteerManager.getInstance();
    int i = 0;
    for (Volunteer volunteer : volunteerManager.getVolunteers()) {
        if (++i > 2) break;
        String body = template;
        String toEmailAddress; //volunteer.getFirstName() + " " + volunteer.getLastName() + " <" + volunteer.getEmailAddress() + ">";
        toEmailAddress = "Wayne Franklin <waf1waf@gmail.com>";
        String[] to = {toEmailAddress};
        String[] cc = {};
        String[] bcc = {};
        String subject = "Christmas Store Reminder";
        body = body.replace("{first_name}", volunteer.getFirstName());
        body = body.replace("{last_name}", volunteer.getLastName());

        StringBuilder reservationParagraph = new StringBuilder();
        ReservationManager reservationManager = ReservationManager.getInstance();
        ArrayList<Reservation> reservationList = reservationManager.getReservationsByVolunteer(volunteer.getId());
        for (Reservation reservation : reservationList) {
            Area area = reservation.getArea();
            reservationParagraph.append("You have scheduled ").append(reservation.getCount()).append(reservation.getCount() == 1 ? " volunteer" : " volunteerManager").append(" to work in the ").append(area.getName()).append(" area on ").append(reservation.getShift().getName()).append(".\n");
        }

        body = body.replace("{reservationManager}", reservationParagraph.toString());

        System.out.println("---------------------------------------------------------------------");
        System.out.println("To: " + toEmailAddress);
        System.out.println(body);

        Mail mail = new MailREST();
        boolean sent = mail.sendMail("localhost", to, cc, bcc, subject, body);
        if (sent) {
            logger.debug("sent reminder to " + toEmailAddress);
        } else {
            logger.warn("FAILED to send reminder to " + toEmailAddress);
        }
    }
%>
<html>
    <head>
        <title>Reminders Page</title>
        <link rel="stylesheet" type="text/css" href="css/nhf.css"/>
        <link rel="stylesheet" type="text/css" href="css/print.css" media="print"/>
    </head>
    <body>
        <h1>Done</h1>
    </body>
</html>
