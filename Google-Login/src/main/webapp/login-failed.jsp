<%-- 
    Document   : login-failed
    Created on : nov 15, 2017, 10:36:27 AM
    Author     : chajj--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="c.hajj.ConfigProperties"%>
<%
    ConfigProperties confProp = new ConfigProperties();
    String appName = confProp.getPropValue("appName");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%= appName%></title>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/bootstrap.min.css">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/bootstrap-theme.min.css">
        <link type="text/css" rel="stylesheet" href="resources/css/main.css">
        <script src="resources/jquery/jquery-1.11.3.min.js" type="text/javascript"></script>
        <script src="resources/bootstrap/bootstrap.min.js" type="text/javascript"></script>
    </head>
    <body>
        <div class="container master-container">
            <div class="container">
                <div class="col-md-2"></div>
                <%
                    if (session.getAttribute("licenseExpired").toString().equals("true")) {
                %>
                <div class="col-md-8 alert alert-warning fade in text-center" data-alert="alert">
                    <h4>
                        <strong>
                            Login to access <%= appName%> Web Application
                        </strong>
                    </h4>
                    <p>License expired. Please contact your Administrator to renew the license (Customer Support limited)</p>
                </div>
                <%
                } else {
                %>
                <div class="col-md-8 alert alert-info fade in text-center" data-alert="alert">
                    <h4>
                        <strong>
                            Login to access <%= appName%> Web Application
                        </strong>
                    </h4>
                    <p>Here you'll see the usage of Simple Form or Login with your Google account</p>
                </div>
                <%
                    }
                %>
                <div class="col-md-2"></div>
            </div>
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    <div class="panel panel-danger">
                        <div class="panel-heading">User credentials are incorrect</div>
                        <div class="panel-body">
                            <a class="btn btn-default" href="javascript:;" onclick="window.history.back();">Retry again</a>
                        </div>
                    </div>
                </div>
                <div class="col-md-4"></div>
            </div>
        </div>
    </body>
</html>

