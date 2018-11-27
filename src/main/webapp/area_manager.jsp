<%@ page import="cc.nhf.Area" %>
<%@ page import="cc.nhf.AreaManager" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.apache.log4j.Logger" %>
<%
    Logger logger = Logger.getLogger(this.getClass());
    AreaManager areaManager = AreaManager.getInstance();
    String areaName = "";
    String areaDescription = "";
    int minimumAge = 18;
    String add_or_update = "Add";
    int action_id = 0;
    String action_id_string = request.getParameter("action_id");
    if (action_id_string != null && !action_id_string.isEmpty())
        action_id = Integer.parseInt(action_id_string);
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Edit") && request.getParameter("action_id") != null && !request.getParameter("action_id").equals("")) {
        Area area = areaManager.getAreaById(action_id);
        areaName = area.getName();
        areaDescription = area.getDescription();
        minimumAge = area.getMinimumAge();
        add_or_update = "Update";
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Update")) {
        areaManager.updateArea(Integer.parseInt(request.getParameter("action_id")), request.getParameter("areaName"), request.getParameter("areaDescription"), Integer.parseInt(request.getParameter("minimumAge")));
        areaName = areaDescription = "";
        minimumAge = 18;
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Add")) {
        areaManager.addArea(request.getParameter("areaName"), request.getParameter("areaDescription"), Integer.parseInt(request.getParameter("minimumAge")));
        areaName = areaDescription = "";
        minimumAge = 18;
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Delete")) {
        logger.error("Delete area: " + action_id);
        areaManager.deleteArea(action_id);
    }
    ArrayList<Area> areaList = areaManager.getAreas();
%>
<html>
<head>
    <title>Area Page</title>
    <%@include file="menu.jsp" %>
    <link rel="stylesheet" type="text/css" href="css/nhf.css"/>
    <link rel="stylesheet" type="text/css" href="css/print.css" media="print"/>
    <script type="text/javascript">
        function confirmDelete(name) {
            return confirm("Are you sure you want to delete " + name + "?");
        }
        function validate(objForm) {
            if ('delete' === document.getElementById('submit').value)
                return true;
            if (0 === objForm.areaName.value.length) {
                alert("action_id: " + document.myForm.action_id.value);
                alert("submit: " + document.myForm.elements['submit'].value);
                alert("Please enter area name");
                objForm.areaName.focus();
                return false;
            }
            if (0 === objForm.areaDescription.value.length) {
                alert("Please enter description");
                objForm.areaDescription.focus();
                return false;
            }
            return true;
        }
    </script>
</head>
<body onload="document.myForm.areaName.focus()">
<form method="post" name="myForm" action="area_manager.jsp" onsubmit="return validate(this);">
    <h1>Areas</h1>
    <table>
        <tr>
            <th>Area Name</th>
            <th>Area Description</th>
            <th>Minimum Age</th>
            <th>Action</th>
        </tr>
        <tr>
            <td><label>
                <input type="text" name="areaName" value="<%=areaName%>"/>
            </label></td>
            <td><label>
                <textarea rows="3" cols="60" name="areaDescription"><%=areaDescription%></textarea>
            </label></td>
            <td>
                <label>
                    <select name="minimumAge">
                        <%
                            for (int i = 12; i <= 18; ++i) {
                                if (minimumAge == i) {
                        %>
                        <option value="<%=i%>" selected><%=i%>
                        </option>
                        <% } else { %>
                        <option value="<%=i%>"><%=i%>
                        </option>
                        <% } %>
                        <% } %>
                    </select>
                </label>
            </td>
            <td><input type="submit" name="submit" value="<%=add_or_update%>"/></td>
        </tr>
    </table>
    <br/>
    <table id="area_table">
        <tr>
            <th class="areaName">Area&nbsp;Name</th>
            <th class="areaDescription">Area&nbsp;Description</th>
            <th class="minimumAge">Minimum&nbsp;Age</th>
            <th class="action">Action&nbsp;Buttons</th>
        </tr>
        <% for (Area area : areaList) {
            int id = area.getId();
            String name = area.getName();
        %>
        <tr>
            <td class="areaName"><%=name%></td>
            <td class="areaDescription"><%=area.getDescription()%></td>
            <td class="minimumAge"><%=area.getMinimumAge()%></td>
            <td class="action">
                <input type="submit" name="submit" value="Edit"
                       onmousedown='document.myForm.action_id.value=<%=id%>;'/>
                <input type="submit" name="submit" value="Delete"
                       onmousedown="document.myForm.action_id.value=<%=id%>;"
                       onclick="return confirmDelete('<%=name%>')"/>
            </td>
        </tr>
        <% } %>
    </table>
    <br/>
    <input type="hidden" name="action_id" value="<%=action_id%>"/>
</form>
</body>
</html>
