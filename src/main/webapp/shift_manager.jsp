<%@page import="cc.nhf.Shift" %>
<%@page import="cc.nhf.ShiftManager" %>
<%@page import="java.util.ArrayList" %>
<%
    ShiftManager shiftManager = ShiftManager.getInstance();
    ArrayList<Shift> shiftList;
    String name = "";
    String add_or_update = "Add";
    int action_id = -1;
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Edit") && request.getParameter("action_id") != null && !request.getParameter("action_id").equals("")) {
        action_id = Integer.parseInt(request.getParameter("action_id"));
        Shift shift = shiftManager.getShift(action_id);
        name = shift.getName();
        add_or_update = "Update";
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Up")) {
        action_id = Integer.parseInt(request.getParameter("action_id"));
        shiftManager.moveUp(action_id);
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Down")) {
        action_id = Integer.parseInt(request.getParameter("action_id"));
        shiftManager.moveDown(action_id);
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Update")) {
        action_id = Integer.parseInt(request.getParameter("action_id"));
        Shift shift = shiftManager.getShift(action_id);
        shift.setName(request.getParameter("name"));
        shiftManager.updateShift(shift);
        name = "";
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Add")) {
        Shift shift = new Shift();
        shift.setName(request.getParameter("name"));
        shiftManager.addShift(shift);
        name = "";
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Delete")) {
        shiftManager.deleteShift(Integer.parseInt(request.getParameter("action_id")));
    }
    shiftList = shiftManager.getShifts();
%>
<html>
<head>
    <title>Shifts Page</title>
    <%@include file="menu.jsp" %>
    <link rel="stylesheet" type="text/css" href="css/nhf.css"/>
    <link rel="stylesheet" type="text/css" href="css/print.css" media="print"/>
    <script type="text/javascript">
        function confirmDelete() {
            return confirm("Are you sure you want to delete the shift?");
        }
    </script>
</head>
<body style="text-align:center" onload="document.myForm.name.focus()">
<form method="post" name="myForm" action="shift_manager.jsp"
      onkeypress="if (13===event.keyCode) { document.myForm.submit.value='Add'; document.getElementById('submit').click(); return false; }">
    <h1>Shifts</h1>
    <table style="margin-left: auto; margin-right: auto">
        <tr>
            <th>Name</th>
            <th>Action</th>
        </tr>
        <tr>
            <td><label>
                <input type="text" size="38" name="name" value="<%=name %>"/>
            </label></td>
            <td><input type="submit" name="submit" value="<%=add_or_update%>"/></td>
        </tr>
    </table>
    <br/>
    <table style="margin-left: auto; margin-right: auto" id="area_table" border="1">
        <tr>
            <th>Name</th>
            <th class="action">Action&nbsp;Buttons</th>
        </tr>
        <% for (Shift shift : shiftList) { %>
        <tr>
            <td><%=shift.getName().replace(" ","&nbsp;") %>
            <td class="action">
                <input type="submit" name="submit" value="Up"
                       onmousedown="document.myForm.action_id.value=<%=shift.getId()%>;"/>
                <input type="submit" name="submit" value="Down"
                       onmousedown="document.myForm.action_id.value=<%=shift.getId()%>;"/>
                <input type="submit" name="submit" value="Edit"
                       onmousedown="document.myForm.action_id.value=<%=shift.getId()%>;"/>
                <input type='submit' name='submit' value='Delete'
                       onmousedown='document.myForm.action_id.value=<%=shift.getId()%>;'
                       onclick='return confirmDelete();'/>
            </td>
        </tr>
        <% } %>
    </table>
    <input type="hidden" name="action_id" value="<%=action_id%>"/>
</form>
</body>
</html>
