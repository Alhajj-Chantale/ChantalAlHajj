<%-- 
    Document   : users-list
    Created on : nov 15, 2017, 06:24:09 PM
    Author     : chajj--%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="m.dekmak.Database"%>
<%@include file="header.jsp" %>

<div class="page-container">
    <div class="panel panel-default">
        <div class="panel-heading">
            Contacts List
            <div class="btn-group pull-right">
                <button class="btn btn-info">Actions</button>
                <button class="btn btn-info dropdown-toggle dropdown-actions-list" data-toggle="dropdown"><span class="caret"></span></button>
                <ul class="dropdown-menu">
                    <li><a href="contact-add.jsp">Add contact</a></li>
                    <li class="divider"></li>
                    <li><a href="export-excel/contacts.jsp?exportToExcel=YES">Export to Excel</a></li>
                </ul>
            </div>
        </div>
        <table class="table">
            <thead>
            <th style="width: 400px;">First Name</th>
            <th style="width: 400px;">Last Name</th>
            <th style="width: 400px;">Email</th>
            <th style="width: 400px;">Mobile</th>
            <th style="width: 400px;">Phone</th>
            <th style="width: 400px;">Actions</th>
            </thead>
            <tbody>
                <% // load contacts list                    
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
                            String id = params[0].substring(1);
                            String text = params[j];
                            if (text.startsWith("[")) {
                                text = text.substring(1);
                            }
                            if (text.endsWith("]")) {
                                text = text.substring(0, text.length() - 1);
                            }
                            if (j == 6) { // "*action*"
%>
                    <td style="width: 400px;">
                        <a href="contact-edit.jsp?id=<%= id%>"><button type="button" class="btn btn-default" data-toggle="modal" data-whatever="@mdo" title="Edit Contact">
                                <span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
                            </button>
                        </a>
                    </td>
                    <%
                    } else if (j != 0) {
                    %>
                    <td style="width: 400px;"><%= text%></td>
                    <%
                            }
                        }
                    %>
                </tr>
                <%
                    }%>

            </tbody>
        </table>
    </div>
</div>

<%@include file="footer.jsp" %>