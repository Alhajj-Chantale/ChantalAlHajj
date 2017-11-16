<%-- 
    Document   : login
    Created on : nov 15, 2017, 11:25:27 AM
    Author     : chajj--%>

<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="m.dekmak.License"%>
<%@page import="java.io.File"%>
<%@page import="m.dekmak.GoogleAuth"%>
<%@page import="m.dekmak.Database"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="m.dekmak.ConfigProperties"%>
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
        <script src="resources/js/general.js" type="text/javascript"></script>
    </head>
    <body>
        <% // check license
            License lc = new License();
            String licenseValidation = lc.validate();
            if (!licenseValidation.equals("success")) {
        %>
        <div class="container master-container">
            <div class="container">
                <div class="col-md-2"></div>
                <div class="col-md-8 alert alert-danger fade in text-center" data-alert="alert">
                    <h4>
                        <strong>
                           <%= licenseValidation%>
                        </strong>
                    </h4>
                    <p>Please contact the Administrator to check the license validity.</p>
                </div><div class="col-md-2"></div>
            </div>
        </div>      
        <%        } else {
        %>
        <div class="container master-container">
            <%
                session.setAttribute("licenseNbOfUsers", lc.getNbOfUsers());
                session.setAttribute("licenseProduct", lc.getProduct());
                session.setAttribute("licenseClient", lc.getClient());
                session.setAttribute("licenseExpiresOn", lc.getExpiresOn());
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                java.util.Date today = new java.util.Date();
                String currentDate = new java.sql.Date(today.getTime()).toString();
                Date date1 = sdf.parse(currentDate);
                Date date2 = sdf.parse(lc.getExpiresOn());
                boolean licenseExpired = false;
                if (date1.compareTo(date2) > 0) {
                    licenseExpired = true;
                }
                session.setAttribute("licenseExpired", licenseExpired);
                if (licenseExpired) {
            %>
            <div class="container">
                <div class="col-md-2"></div>
                <div class="col-md-8 alert alert-warning fade in text-center" data-alert="alert">
                    <h4>
                        <strong>
                            Login to access <%= appName%> Web Application
                        </strong>
                    </h4>
                    <p>License expired. Please contact your Administrator to renew the license (Customer Support limited)</p>
                </div>
                <div class="col-md-2"></div>
            </div>
            <%
            } else {
            %>
            <div class="container">
                <div class="col-md-2"></div>
                <div class="col-md-8 alert alert-info fade in text-center" data-alert="alert">
                    <h4>
                        <strong>
                            Login to access <%= appName%> Web Application
                        </strong>
                    </h4>
                    <p>Here you'll see the usage of Simple Form or Login with your Google account</p>
                </div><div class="col-md-2"></div>
            </div>
            <%
                }
            %>
            <div class="row">
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    <div class="panel panel-primary">
                        <div class="panel-heading">Login Form</div>
                        <div class="panel-body">
                            <form accept-charset="UTF-8" method="POST" action="j_security_check" novalidate="novalidate" id="loginForm">
                                <%
                                    /*
                                     * The GoogleAuth handles all the heavy lifting, and contains all "secrets"
                                     * required for constructing a google login url.
                                     */
                                    final GoogleAuth helper = new GoogleAuth();
                                %>
                                <div class="form-group email required user_basic_email">
                                    <label class="email required control-label" for="user_basic_email">
                                        <abbr title="required">*</abbr> Username
                                    </label>
                                    <input class="string email required form-control" name="j_username" id="username" placeholder="Enter username" type="text">
                                </div>
                                <div class="form-group password required user_basic_password">
                                    <label class="password required control-label" for="user_basic_password">
                                        <abbr title="required">*</abbr> Password
                                    </label>
                                    <input class="password required form-control" name="j_password" id="password" placeholder="Password" type="password">
                                </div>
                                <input class="btn btn-default" name="commit" type="submit" value="Login">
                                &nbsp;&nbsp; OR,
                                <a href="<% out.println(helper.buildLoginUrl()); %>" class="btn btn-link">Login with Google Account</a>
                                <div class="clearfix">&nbsp;</div>
                                <%!
                                    String userInfo, userEmail, userId;
                                %>
                                <%
                                    if (request.getParameter("code") != null && request.getParameter("state") != null) {
                                        /*
                                         * Executes after google redirects to the callback url.
                                         * Please note that the state request parameter is for convenience to differentiate
                                         * between authentication methods (ex. facebook oauth, google oauth, twitter, in-house).
                                         * 
                                         * GoogleAuth()#getUserInfoJson(String) method returns a String containing
                                         * the json representation of the authenticated user's information. 
                                         * At this point you should parse and persist the info.
                                         */
                                        userInfo = helper.getUserInfoJson(request.getParameter("code"));
                                        userEmail = helper.getParameterFromUserInfo(userInfo, "email");
                                        userId = helper.getParameterFromUserInfo(userInfo, "id");
                                        Database db = new Database();
                                        String[] ret = db.getUserCredentials(userEmail, userId);
                                        String username = "";
                                        String pass = "";
                                        int index = 0;
                                        for (String key : ret) {
                                            if (ret.length > 1) {
                                                index++;
                                                if (index == 1) {
                                                    username = key;
                                                } else if (index == 2) {
                                                    pass = key;
                                                }
                                            } else { // exception msg
                                                out.println("<p class='help-block text-red'>" + key + "</p>");
                                            }
                                        }
                                        // to avoid the conflict between the request from login form and the request from inside the application
                                        session.setAttribute("isRedirectedFormLoginForm", "1");
                                        if (username != "" && pass != "") {
                                %>
                                <script language="javascript">
                                    var userName = "<%= username%>";
                                    var password = "<%= pass%>";
                                    document.getElementById("username").value = userName;
                                    document.getElementById("password").value = password;
                                    document.getElementById("loginForm").submit();
                                </script>
                                <%
                                } else {
                                %>
                                <p class="help-block text-red">You are trying to login with Google account not exists in our local database.</p>
                                <p class="help-block text-red">This is a Web based Application and not a Website. So, there is no Sign Up process for outsource users.</p>
                                <p class="help-block text-red">Please contact the Administrator of <%= appName%> for more information.</p>
                                <%
                                        }
                                    }
                                %>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-md-4"></div>
            </div>
        </div>
        <%
            }
        %>
    </body>
</html>

