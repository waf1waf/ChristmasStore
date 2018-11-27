<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="cc.nhf.Shift" %>
<%@ page import="cc.nhf.ShiftManager" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="static cc.nhf.DatabaseUtil.*" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>
<%@ page import="org.apache.log4j.Logger" %>
<%@ page import="java.util.Objects" %>

<html>
<head>
    <title>Multiple Shift Report</title>
    <%!
        private static final String MASSIVE_QUERY = "SELECT first_name, last_name, n_adults, n_children FROM volunteer, " +
                "  (SELECT shift1.fk_volunteer_id FROM " +
                "(SELECT DISTINCT fk_volunteer_id " +
                " FROM reservation WHERE reservation.fk_shift_id=?) AS shift1, " +
                "(SELECT DISTINCT fk_volunteer_id " +
                " FROM reservation WHERE reservation.fk_shift_id=?) AS shift2 WHERE " +
                "  shift1.fk_volunteer_id=shift2.fk_volunteer_id) AS joint WHERE volunteer.id = joint.fk_volunteer_id;";
    %>
    <link rel="stylesheet" type="text/css" href="css/report.css" media="all"/>
</head>
<body>
<h1 style="text-align: center">Multiple Shift Report - Friday</h1>
<%
    Logger logger = Logger.getLogger(this.getClass());

    try (Connection connection = Objects.requireNonNull(getDataSource()).getConnection()) {

        // Day 1
        for (int shiftId = 1; shiftId < 9; ++shiftId) {
            ResultSet resultSet;
            ArrayList<String> shiftNames;
            try (PreparedStatement preparedStatement = connection.prepareStatement(MASSIVE_QUERY)) {

                preparedStatement.setInt(1, shiftId);
                preparedStatement.setInt(2, shiftId + 1);

                resultSet = preparedStatement.executeQuery();

                shiftNames = new ArrayList<>();
                try {
                    while (resultSet.next()) {
                        int count = resultSet.getInt("n_adults") + resultSet.getInt("n_children");
                        String name = resultSet.getString("last_name") + ", " + resultSet.getString("first_name");
                        if (count > 1) {
                            name += " (" + count + " people)";
                        }
                        if (shiftId != 4) {
                            shiftNames.add(name);
                        }
                    }
                } catch (SQLException e) {
                    logger.error(e.getLocalizedMessage(), e);
                }
                if (!shiftNames.isEmpty()) {
                    ShiftManager shiftManager = ShiftManager.getInstance();
                    Shift shift = shiftManager.getShift(shiftId);
                    Shift nextShift = shiftManager.getShift(shiftId + 1);
                    if (shiftId == 5) {
%>
<h1 style="page-break-before: always; text-align: center">Multiple Shift Report - Saturday</h1>
<table style="text-align: center; width:260px; margin-left: auto; margin-right: auto">
    <% } else { %>
    <table style="text-align: center; width:260px; margin-left: auto; margin-right: auto">
        <% } %>
        <tr>
            <th>Shift <%=shiftId%>: <%=shift.getName()%><br/>&amp;<br/>Shift <%=shiftId + 1%>: <%=nextShift.getName()%>
            </th>
        </tr>
        <%
            Collections.sort(shiftNames);
            for (String name : shiftNames) {
        %>
        <tr>
            <td><%=name%>
            </td>
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
        } catch (Exception e) {
            logger.error(e.getLocalizedMessage());
        }
    %>
</table>
</body>
</html>
