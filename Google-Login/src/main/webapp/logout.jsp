<%-- 
    Document   : logout
    Created on : nov 15, 2017, 12:08:27 PM
    Author     : chajj--%>

<%@include file="header.jsp" %>
<%
    session = request.getSession();
    session.invalidate();
%>
<div class="panel panel-warning">
    <div class="panel-heading">
        <h3 class="panel-title">Sign Out from <%= appName %></h3>
    </div>
    <div class="panel-body">
        You have successfully logged out.
        Click <a href="https://localhost:8443/SMB215-OAuth-Google"><b>here</b></a> for another login.
    </div>
</div>
<%@include file="footer.jsp" %>
