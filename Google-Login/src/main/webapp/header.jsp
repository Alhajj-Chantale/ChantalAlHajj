<%-- 
    Document   : header
    Created on : nov 15, 2017, 06:16:14 PM
    Author     : chajj--%>

<%@page import="c.hajj.GoogleAuth"%>
<%@page import="c.hajj.Database"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="m.dekmak.ConfigProperties"%>
<%
    ConfigProperties confProp = new ConfigProperties();
    String appName = confProp.getPropValue("appName");
    String appVersion = confProp.getPropValue("appVersion");
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%= appName%></title>
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/bootstrap.min.css">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/bootstrap-theme.min.css">
        <link type="text/css" rel="stylesheet" href="resources/bootstrap/bootstrap-select.min.css">
        <link type="text/css" rel="stylesheet" href="resources/css/main.css">
        <link type="text/css" rel="stylesheet" href="resources/jquery/jquery-ui.min.css" media="all" />
        <link type="text/css" rel="stylesheet" href="resources/fullcalendar/fullcalendar.css" />
        <link type="text/css" rel="stylesheet" href="resources/jquery/jquery.datetimepicker.css" />

        <script src="resources/jquery/jquery-1.11.3.min.js" type="text/javascript"></script>
        <script src="resources/bootstrap/bootstrap.min.js" type="text/javascript"></script>
        <script src="resources/bootstrap/bootstrap-select.min.js" type="text/javascript"></script>
        <script src="resources/js/general.js" type="text/javascript"></script>
        <script src="resources/js/highcharts.js" type="text/javascript"></script>
        <script src="resources/js/exporting.js" type="text/javascript"></script>
        <script type="text/javascript" src="resources/jquery/jquery-ui.custom.min.js"></script>
        <script type="text/javascript" src="resources/fullcalendar/moment.min.js"></script>
        <script type="text/javascript" src="resources/fullcalendar/fullcalendar.js"></script>
        <script type="text/javascript" src="resources/jquery/jquery-ui.min.js"></script>
        <script type="text/javascript" src="resources/jquery/jquery.datetimepicker.js"></script>
    </head>
    <body>
        <script type="text/javascript">
            var Chat = {};

            Chat.socket = null;

            Chat.connect = (function (host) {
                if ('WebSocket' in window) {
                    Chat.socket = new WebSocket(host);
                } else if ('MozWebSocket' in window) {
                    Chat.socket = new MozWebSocket(host);
                } else {
                    Console.log('Error: WebSocket is not supported by this browser.');
                    return;
                }

                Chat.socket.onopen = function () {
                    Console.log('Info: WebSocket connection opened.');
                    document.getElementById('chat').onkeydown = function (event) {
                        if (event.keyCode == 13) {
                            Chat.sendMessage();
                        }
                    };
                };

                Chat.socket.onclose = function () {
                    document.getElementById('chat').onkeydown = null;
                    Console.log('Info: WebSocket closed.');
                };

                Chat.socket.onmessage = function (message) {
                    Console.log(message.data);
                };
            });

            Chat.initialize = function () {
                if (window.location.protocol == 'http:') {
                    Chat.connect('ws://' + window.location.host + '/examples/websocket/tc7/chat');
                } else {
                    Chat.connect('wss://' + window.location.host + '/examples/websocket/tc7/chat');
                }
            };

            Chat.sendMessage = (function () {
                var message = document.getElementById('chat').value;
                if (message != '') {
                    Chat.socket.send(message);
                    document.getElementById('chat').value = '';
                }
            });

            var Console = {};

            Console.log = (function (message) {
                var console = document.getElementById('console');
                var p = document.createElement('p');
                p.style.wordWrap = 'break-word';
                p.innerHTML = message;
                console.appendChild(p);
                while (console.childNodes.length > 25) {
                    console.removeChild(console.firstChild);
                }
                console.scrollTop = console.scrollHeight;
            });

            Chat.initialize();
            $(document).ready(function () {
                // get counter nb of pending notifications
                setTimeout(function () {
                    getCounterNotifications('<%= request.getUserPrincipal().getName()%>');
                }, 1000); // Display the counter nb after 1 second (1000 millisecond):
                $('[data-toggle="popover"]').popover({
                    placement: 'bottom'
                }).click(function (e) {
                    if ($('.popover').hasClass('in')) {
                        // popover is visible
                        getPendingNotifications('<%= request.getUserPrincipal().getName()%>', $('.popover-content'));
                    }
                });
                // check user if flagged to change his password after login
                checkUserFlagChangePwd('<%= request.getUserPrincipal().getName()%>');
            });
        </script>
        <div class="hide" id="notification-content-template">
            <div>
                <div class="col-md-4"></div>
                <div class="col-md-4">
                    <img class="loading-image" src="resources/images/icons/loading.png" />
                </div>
                <div class="col-md-4"></div>
                <a href="notify.jsp" class="btn btn-link">Notify</a>
                <a href="show-my-notifications.jsp" class="btn btn-link pull-right">Show all</a>
            </div>
        </div>
        <%
            String userProfileName = request.getUserPrincipal().getName();
        %>
        <div class="container">
            <div class="col-md-2"></div>
            <%
                if (session.getAttribute("licenseExpired").toString().equals("true")) {
            %>
            <div class="col-md-8 alert alert-warning fade in text-center" data-alert="alert">
                <h4>
                    <strong>
                        Welcome "<%= userProfileName%>" to <%= appName%>
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
                        Welcome "<%= userProfileName%>" to <%= appName%>
                    </strong>
                </h4>
                <p>Here you'll see the features and full pages of <%= appName%></p>
            </div>
            <%
                }
            %>
            <div class="col-md-2"></div>
        </div>
        <nav id="navbar-example" class="navbar navbar-default navbar-static">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button class="navbar-toggle collapsed" type="button" data-toggle="collapse" data-target=".bs-example-js-navbar-collapse">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="index.jsp"><%= appName%></a>
                </div>
                <div class="collapse navbar-collapse bs-example-js-navbar-collapse">
                    <ul class="nav navbar-nav">
                        <li class="dropdown">
                            <a id="dropDashboard" href="dashboard.jsp" role="button">
                                Dashboard
                            </a>
                        </li>
                        <li class="dropdown">
                            <a id="dropContact" href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                                Contact
                                <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="dropContact">
                                <li><a href="contacts-list.jsp">Contact</a></li>
                                <li class="divider"></li>
                                <li><a href="contact-add.jsp">Add Contact</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a id="dropCal" href="calendar.jsp" role="button">
                                Calendar
                            </a>
                        </li>
                        <li class="dropdown">
                            <a id="dropTask" href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                                Task
                                <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="dropTask">
                                <li><a href="#">My Tasks</a></li>
                                <li class="divider"></li>
                                <li><a href="#">All Tasks</a></li>
                            </ul>
                        </li>
                        <li class="dropdown">
                            <a id="dropStock" href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                                Stock
                            </a>
                        </li>
                        <li class="dropdown">
                            <a id="dropAcc" href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                                Accounting
                            </a>
                        </li>
                        <li class="dropdown">
                            <a id="dropReports" href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                                Reports
                            </a>
                        </li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">
                        <li id="fat-menu" class="dropdown">
                            <a id="drop3" href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
                                <%
                                    out.println(userProfileName);
                                %>
                                <span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu" aria-labelledby="drop3">
                                <li><a href="user-profile-change-pwd.jsp">Change Password</a></li>
                                <li class="divider"></li>
                                <li>
                                    <a href="#" class="header-change-pwd">Change Language</a>
                                </li>
                                <li><a href="#">English</a></li>
                                <li><a href="#">Arabic</a></li>
                                <li><a href="#">Français</a></li>
                                <li class="divider"></li>
                                <li><a href="social-networks.jsp">Social Networks</a></li>
                                <li><a href="admin-setup.jsp">Administration & Setup</a></li>
                                <li class="divider"></li>
                                <li><a href="https://github.com/pascalfares/smb215-15" target="_blank">Help</a></li>
                                <li><a href="#" onclick="aboutApp('<%= appName%>', '<%= appVersion%>', '<%= session.getAttribute("licenseProduct").toString()%>', '<%= session.getAttribute("licenseClient").toString()%>');">About</a></li>
                                <li><a href="https://github.com/pascalfares/smb215-15/issues" target="_blank">Report a bug</a></li>
                                <li class="divider"></li>
                                <li><a href="https://localhost:8443/SMB215-OAuth-Google/logout.jsp">Sign out</a></li>
                            </ul>
                        </li>
                    </ul>
                    <button type="button" class="btn btn-default pull-right" style="margin-top: 10px; margin-left: 15px;" data-toggle="popover" title="Notifications" data-content="" id="notificationBtn">
                        <span class="glyphicon glyphicon-flag" aria-hidden="true" id="notificationSpan"></span>
                    </button>
                    <button type="button" class="btn btn-default pull-right" data-toggle="modal" data-target="#chatModal" data-whatever="@mdo" style="margin-top: 10px;" title="Chat">
                        <span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
                    </button>
                </div><!-- /.nav-collapse -->
            </div><!-- /.container-fluid -->
        </nav>
        <div id="chatModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="chatModal">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="chatModal">Chat Service (Guest Profiles)</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-12">
                                <div class="col-md-1"></div>
                                <div class="col-md-10">
                                    <p>This is a simple chat service. You must define your profile before chatting (by default Guest profiles is defined)</p>
                                    <p>
                                        <input type="text" placeholder="type and press enter to chat" id="chat">
                                    </p>
                                    <div id="console-container">
                                        <div id="console"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default modalChatCloseBtn" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>