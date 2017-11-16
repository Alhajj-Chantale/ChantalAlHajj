<%-- 
    Document   : user-groups
    Created on : nov 15, 2017, 12:02:19 AM
    Author     : chajj--%>

<%@page import="java.util.ArrayList"%>
<%@page import="c.hajj.Database"%>
<%@page import="java.util.List"%>
<%
    String exportToExcel = request.getParameter("exportToExcel");
    if (exportToExcel != null && exportToExcel.toString().equalsIgnoreCase("YES")) {
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "inline; filename=user-groups.xls");
    }
%>
<html>
    <body>
        <table class="table">
            <thead>
            <th>Name</th>
        </thead>
        <tbody>
            <%
                List<String> userGroups = new ArrayList<String>();
                Database db = new Database();
                userGroups = db.getUserGroupsList();
                for (int i = 0; i < userGroups.size(); i++) {
                    String cell = (String) userGroups.get(i);
                    String[] params = cell.split(",");
            %>
            <tr>
                <%
                    for (int j = 0; j < params.length; j++) {
                        String name = params[0].substring(1);
                        String text = params[j];
                        if (text.startsWith("[")) {
                            text = text.substring(1);
                        }
                        if (text.endsWith("]")) {
                            text = text.substring(0, text.length() - 1);
                        }
                        if (j == 0) {
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
</body>
</html>
