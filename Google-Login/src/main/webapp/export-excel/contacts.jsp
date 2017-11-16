<%-- 
    Document   : users
    Created on : nov 15, 2017, 11:56:28 PM
    Author     : chajj--%>

<%@page import="c.hajj.Database"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%
    String exportToExcel = request.getParameter("exportToExcel");
    if (exportToExcel != null && exportToExcel.toString().equalsIgnoreCase("YES")) {
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "inline; filename=contacts.xls");
    }
%>
<html>
    <table class="table">
        <thead>
        <th>First Name</th>
        <th>Last Name</th>
        <th>Email</th>
        <th>Mobile</th>
        <th>Phone</th>
    </thead>
    <tbody>
        <%
            List<String> contacts = new ArrayList<String>();
            Database db = new Database();
            contacts = db.getContactsList();
            for (int i = 0; i < contacts.size(); i++) {
                String cell = (String) contacts.get(i);
                String[] params = cell.split(",");
        %>
        <tr>
            <%
                for (int j = 0; j < params.length; j++) {
                    String text = params[j];
                    if (text.startsWith("[")) {
                        text = text.substring(1);
                    }
                    if (text.endsWith("]")) {
                        text = text.substring(0, text.length() - 1);
                    }
                    if (j != 6 && j != 0) {
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