<%-- 
    Document   : user-groups-dropdown
    Created on : nov 15, 2017, 11:34:58 PM
    Author     : chajj--%>

<%@page import="java.util.ArrayList"%>
<%@page import="m.dekmak.Database"%>
<%@page import="java.util.List"%>

<select class="selectpicker" multiple id="roles">
    <%
        List<String> userGroups = new ArrayList<String>();
        Database dbClass = new Database();
        userGroups = dbClass.getUserGroupsList();
        for (int i = 0; i < userGroups.size(); i++) {
            String cell = (String) userGroups.get(i);
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
