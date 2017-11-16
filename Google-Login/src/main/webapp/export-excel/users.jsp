<%-- 
    Document   : users
    Created on : nov 15, 2017, 11:56:28 PM
    Author     : chajj
--%>

<%@page import="c.hajj.Database"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%
    String exportToExcel = request.getParameter("exportToExcel");
    if (exportToExcel != null && exportToExcel.toString().equalsIgnoreCase("YES")) {
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "inline; filename=users.xls");
    }
%>
<html>
    <table class="table">
        <thead>
        <th>Username "Local Account"</th>
        <th>User Group "Role"</th>
        <th>Email "Google Account"</th>
        <th>Has Google Auth</th>
        <th>Is Banned</th>
    </thead>
    <tbody>
        <%
            List<String> users = new ArrayList<String>();
            Database db = new Database();
            users = db.getUsersList();
            for (int i = 0; i < users.size(); i++) {
                String cell = (String) users.get(i);
                String[] params = cell.split(",");
        %>
        <tr>
            <%
                for (int j = 0; j < params.length; j++) {
                    String userName = params[0].substring(1);
                    String userRoles = params[1];
                    String text = params[j];
                    if (text.startsWith("[")) {
                        text = text.substring(1);
                    }
                    if (text.endsWith("]")) {
                        text = text.substring(0, text.length() - 1);
                    }
                    if (j != 5) {
            %>
            <td><%= text%></td>
            <%
                    }
                }
            %>
        </tr>
        <%
            }%>
    </tbody>
</table>
</html>