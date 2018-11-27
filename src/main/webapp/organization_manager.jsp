<%@ page import="cc.nhf.Organization" %>
<%@ page import="cc.nhf.OrganizationManager" %>
<%@ page import="java.util.ArrayList" %>
<%
    OrganizationManager organizationManager = OrganizationManager.getInstance();
    String organizationName = "";
    String add_or_update = "Add";
    int action_id = 0;
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Edit") && request.getParameter("action_id") != null && !request.getParameter("action_id").equals("")) {
        action_id = Integer.parseInt(request.getParameter("action_id"));
        Organization organization = organizationManager.getOrganization(action_id);
        if (organization == null) {
            add_or_update = "Add";
        } else {
            organizationName = organization.getName();
            add_or_update = "Update";
        }
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Update")) {
        organizationManager.updateOrganization(Integer.parseInt(request.getParameter("action_id")), request.getParameter("organizationName"));
        organizationName = "";
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Add")) {
        organizationManager.addOrganization(request.getParameter("organizationName"));
        organizationName = "";
    }
    if (request.getParameter("submit") != null && request.getParameter("submit").equals("Delete")) {
        organizationManager.deleteOrganization(Integer.parseInt(request.getParameter("action_id")));
    }
    ArrayList<Organization> organizationList = organizationManager.getOrganizations();
%>
<html>
<head>
    <title>Organization Page</title>
    <%@include file="menu.jsp" %>
    <link rel="stylesheet" type="text/css" href="css/nhf.css"/>
    <link rel="stylesheet" type="text/css" href="css/print.css" media="print"/>
    <script type="text/javascript">
        function confirmDelete(name) {
            return confirm("Are you sure you want to delete " + name + "?");
        }
        function validate(objForm) {
            if (0 === objForm.organizationName.value.length) {
                alert("Please enter organization name");
                objForm.organizationName.focus();
                return false;
            }
            return true;
        }
    </script>
</head>
<body onload="document.myForm.organizationName.focus()">
<form method="post" name="myForm" action="organization_manager.jsp"
      onkeypress="if (13===event.keyCode) { document.myForm.submit.value='Add'; document.getElementById('submit').click(); return false; }"
      onsubmit="validate(this);">
    <h1>Organizations</h1>
    <table>
        <tr>
            <th>Organization Name</th>
            <th>Action Button</th>
        </tr>
        <tr>
            <td><label for="organizationName"></label><input type="text" size="36" name="organizationName"
                                                             id="organizationName" value="<%=organizationName%>"/></td>
            <td><input type="submit" name="submit" id="submit" value="<%=add_or_update%>"/></td>
        </tr>
    </table>
    <br/>
    <table id="organization_table">
        <tr>
            <th class="id">Org ID</th>
            <th class="organizationName">Organization&nbsp;Name</th>
            <th class="action">Action&nbsp;Buttons</th>
        </tr>
        <%
            for (Organization organization : organizationList) {
                if (!organization.getName().startsWith("-")) {
        %>
        <tr>
            <td><%= organization.getId()%>
            </td>
            <td class="organizationName"><%=organization.getName() %>
            </td>
            <td class="action">
                <input type="submit" name="submit" value="Edit"
                       onmousedown="document.myForm.action_id.value=<%=organization.getId() %>;"/>
                <input type="submit" name="submit" value="Delete"
                       onmousedown="document.myForm.action_id.value=<%=organization.getId() %>;"
                       onclick="return confirmDelete('<%=organization.getName() %>');"/>
            </td>
        </tr>
        <%
                }
            }
        %>
    </table>
    <br/>
    <input type="hidden" name="action_id" value="<%=action_id%>"/>
</form>
</body>
</html>
