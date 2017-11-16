<%-- 
    Document   : show-my-notifications
    Created on : nov 15, 2017, 03:16:00 PM
    Author     : chajj--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@include file="header.jsp" %>

<div class="container master-container">
    <div class="row">
        <div class="panel panel-default">
            <div class="panel-heading">
                My Notifications
            </div>
            <div class="panel-body">
                <%  // get notifications list                 
                    List<String> notifications = new ArrayList<String>();
                    Database db = new Database();
                    notifications = db.getNotificationsList(request.getUserPrincipal().getName());
                    if (notifications.size() > 0) {
                %>
                <table class="table">
                    <thead>
                    <th style="width: 400px;">Message</th>
                    <th style="width: 400px;">Date</th>
                    <th style="width: 400px;">Status</th>
                    </thead>
                    <tbody>
                        <%
                            for (int i = 0; i < notifications.size(); i++) {
                                String cell = (String) notifications.get(i);
                                String[] params = cell.split(",");
                        %>
                        <tr>
                            <%
                                for (int j = 0; j < params.length; j++) {
                                    String userName = params[0].substring(1);
                                    String text = params[j];
                                    if (text.startsWith("[")) {
                                        text = text.substring(1);
                                    }
                                    if (text.endsWith("]")) {
                                        text = text.substring(0, text.length() - 1);
                                    }
                                    text = text.replaceAll("&comma&", ",");
                            %>
                            <td style="width: 400px;"><%= text%></td>
                            <%
                                }
                            %>
                        </tr>
                        <%
                            }%>

                    </tbody>
                </table>
                <%
                } else {
                %>
                <p>There is no notifications</p>
                <%
                    }
                %>
            </div>
        </div>
    </div>
</div>
<%@include file="footer.jsp" %>