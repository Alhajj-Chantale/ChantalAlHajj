<%-- 
    Document   : index
    Created on : nov 15, 2017, 03:37:52 PM
    Author     : chajj--%>

<%@include file="header.jsp" %>
<%!
    String userInfo, userEmail, userId, googleRespone;
%>
<% // check Google response
    Database db = new Database();
    final GoogleAuth helper = new GoogleAuth();
    googleRespone = "";
    /*
     * The GoogleAuth handles all the heavy lifting, and contains all "secrets"
     * required for constructing a google login url.
     */
    /*
     * initial visit to the page
     */
    if (request.getParameter("code") != null && request.getParameter("state") != null && session.getAttribute("isRedirectedFormLoginForm") == null) {
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
        googleRespone = db.updateUserInfo(request.getUserPrincipal().getName(), userEmail, userId);
    }
    if (session.getAttribute("isRedirectedFormLoginForm") != null) {
        session.setAttribute("isRedirectedFormLoginForm", null);
    }
%>
<script type="text/javascript">
    $(function () {
        // Disallow banned users to access the application: send Ajax on every access to home page
        // this request protect the application after the form based Auth
        // and in case the logged use has banned during the session
        killBannedUser('<%= request.getUserPrincipal().getName()%>');
        // to remove the conflict in the Google GET Params between the "login action in login form" and "authenticate action in home page" 
        clearGoogleParamsFromURL('<%= googleRespone%>');
    });
</script>

<div class="col-md-12">
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">Dashboard</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="dashboard.jsp">
                        <img class="img-rounded" src="resources/images/dashboard.png" width="115" height="115" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <p class="text">Visualize your main data for a better monitoring and fast access to the information.</p>
                    <a href="dashboard.jsp" class="btn btn-link no-padding">360° Dashboard</a>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">Contact</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="contacts-list.jsp">
                        <img class="img-rounded" src="resources/images/contact.png" width="115" height="115" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <p class="text">Manage your contacts and related information.</p>
                    <a href="contact-add.jsp" class="btn btn-link no-padding">Add</a>&nbsp;&nbsp; - &nbsp;&nbsp;
                    <a href="contacts-list.jsp" class="btn btn-link no-padding">Search</a>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">Administration & Setup</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="admin-setup.jsp">
                        <img class="img-rounded" src="resources/images/settings.png" width="115" height="115" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <p class="text">Setup your instance by managing your group list, adding users & more.</p>
                    <a href="admin-setup.jsp" class="btn btn-link no-padding">Edit</a>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="col-md-12">
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">Calendar</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="calendar.jsp">
                        <img class="img-rounded" src="resources/images/calendar.png" width="115" height="115" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <p class="text">Share your Calendar with your colleagues for a better Visibility & Collaboration. Schedule Events & more.</p>
                    <a href="calendar.jsp" class="btn btn-link no-padding">Open Calendar</a>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">Task Management</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="#">
                        <img class="img-rounded" src="resources/images/task.png" width="115" height="115" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <p class="text">Build your team's to-do lists. Track Notes History. Manage your Priorities, Due Dates, Resources & more.</p>
                    <a href="#" class="btn btn-link no-padding">Add</a>&nbsp;&nbsp; - &nbsp;&nbsp;
                    <a href="#" class="btn btn-link no-padding">Search</a>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">Accounting Management</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="#">
                        <img class="img-rounded" src="resources/images/accounting.png" width="115" height="115" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <p class="text">Track and Categorize your Expenses & Income. Generate your Invoices and record Payments & more.</p>
                    <a href="#" class="btn btn-link no-padding">Edit</a>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="footer.jsp" %>