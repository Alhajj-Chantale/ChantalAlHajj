<%-- 
    Document   : users-dropdown
    Created on : nov 15, 2017, 11:19:58 PM
    Author     : chajj--%>

<%@page import="java.util.ArrayList"%>
<%@page import="c.hajj.Database"%>
<%@page import="java.util.List"%>

<select class="selectpicker" multiple id="users">
    <%
        List<String> users = new ArrayList<String>();
        Database dbClass = new Database();
        users = dbClass.getUsersList();
        for (int i = 0; i < users.size(); i++) {
            String cell = (String) users.get(i);
            String[] params = cell.split(",");
    %>

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
    <option><%= text%></option>
    <%
            }
        }
    %>
    <%
    }%>

</select>
