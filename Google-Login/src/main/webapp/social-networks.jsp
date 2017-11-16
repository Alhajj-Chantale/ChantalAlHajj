<%-- 
    Document   : oauth
    Created on : nov 15, 2017, 11:06:14 PM
    Author     : chajj--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@include file="header.jsp" %>

<%    Database db = new Database();
    final GoogleAuth helper = new GoogleAuth();
    String googleRespone = "";
    if (session.getAttribute("isRedirectedFormLoginForm") == null) {
        if (request.getParameter("googleRespone") != null && request.getParameter("googleRespone") != "") {
            googleRespone = request.getParameter("googleRespone");
            if (googleRespone.equals("success")) {
                googleRespone = "Updates saved successfully. <br /> <br /> Now you can login with your google account instead of your local username account.";
            } else if (googleRespone.equals("error")) {
                googleRespone = "Exception error when trying to update data in database. Please try again.";
            }
        }
    }

%>

<div class="container master-container">
    <div class="row">
        <div class="col-md-12">
            <div class="panel panel-info">
                <div class="panel-heading">
                    <h4 class="socail-title">Social Networks</h4>
                    <p class="socail-sub-title">Change your social network accounts to easily share content. Moreover you can login with help of them</p>
                </div>
                <div class="panel-body">
                    <div class="google-container">
                        <div class="col-md-3 social-brand-container">
                            <div class="col-md-3">
                                <img src="resources/images/google.png" />
                            </div>
                            <div class="col-md-6">
                                <h3>Google</h3>
                            </div>
                        </div>
                        <div class="clearfix">&nbsp;</div>
                        <hr />
                        <div class="col-md-12">
                            <div class="col-md-10">
                                <%                                    // get user details
                                    String[] userDetails = db.getUserDetails(request.getUserPrincipal().getName());
                                    String db_username = "";
                                    String db_is_google_auth = "";
                                    String db_email = "";
                                    String btnStatus = "";
                                    int index = 0;
                                    for (String key : userDetails) {
                                        if (userDetails.length > 1) {
                                            index++;
                                            if (index == 1) {
                                                db_username = key;
                                            } else if (index == 2) {
                                                db_is_google_auth = key;
                                            } else if (index == 3) {
                                                db_email = key;
                                            }
                                        } else { // exception msg
                                            out.println("<p class='help-block text-red'>" + key + "</p>");
                                        }
                                    }
                                    // check if the page are redirected from google with aith login
                                    if (googleRespone != "") {
                                        btnStatus = "connected";
                                %>
                                <p class="googleText info"><%= googleRespone%></p>
                                <%
                                } else if (db_is_google_auth.equals("yes")) {// user has google authentication
                                    btnStatus = "connected";
                                %>
                                <p class="googleText">Your are connected with Google account (<%= db_email%>)</p>
                                <%
                                } else {// no redirect from ggole and no connection with google from db
                                    btnStatus = "disconnected";
                                %>
                                <p class="googleText">Your <%= appName%> account is not connected to Google</p>
                                <%
                                    }
                                %>
                            </div>
                            <div class="col-md-2">
                                <%
                                    String googleUrl = helper.buildLoginUrl();
                                    if (btnStatus.equals("connected")) {
                                %>
                                <a href="javascript:;" onclick="disconnectGoogleAccount('<%= db_username%>', '<%= googleUrl%>', '<%= appName%>');" class="btn btn-default pull-right btn-google-connect">Disconnect</a>
                                <%
                                } else {
                                %>
                                <a href="<%= googleUrl%>" class="btn btn-info pull-right btn-google-connect">Connect</a>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix">&nbsp;</div>
                    <div class="facebok-container">
                        <div class="col-md-3 social-brand-container">
                            <div class="col-md-3">
                                <img src="resources/images/facebook.png" />
                            </div>
                            <div class="col-md-6">
                                <h3>Facebook</h3>
                            </div>
                        </div>
                        <div class="clearfix">&nbsp;</div>
                        <hr />
                        <div class="col-md-12">
                            <div class="col-md-10">
                                <p>Your <%= appName%> account is not connected to Facebook</p>
                            </div>
                            <div class="col-md-2">
                                <%
                                    out.println("<a href='javascript:;' class='btn btn-info pull-right'>Connect</a>");
                                %>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix">&nbsp;</div>
                    <div class="facebok-container">
                        <div class="col-md-3 social-brand-container">
                            <div class="col-md-3">
                                <img src="resources/images/twitter.png" />
                            </div>
                            <div class="col-md-6">
                                <h3>Twitter</h3>
                            </div>
                        </div>
                        <div class="clearfix">&nbsp;</div>
                        <hr />
                        <div class="col-md-12">
                            <div class="col-md-10">
                                <p>Your <%= appName%> account is not connected to Twitter</p>
                            </div>
                            <div class="col-md-2">
                                <%
                                    out.println("<a href='javascript:;' class='btn btn-info pull-right'>Connect</a>");
                                %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>

<%@include file="footer.jsp" %>