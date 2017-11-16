<%-- 
    Document   : admin-setup
    Created on : nov 15, 2017, 9:35:55 PM
    Author     : chajj--%>

<%@include file="header.jsp" %>

<%
Database db = new Database();
String submitSuccessResp = "";
String submitErrorResp = "";
if (request.getParameter("username") != null) {
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String responseMsg = "";
    responseMsg = db.updateSystemPreferencesKey("smtpUsername", username);
    if (responseMsg.equals("success")) {
        responseMsg = db.updateSystemPreferencesKey("smtpPassword", password);
    }
    if (responseMsg.equals("success")) {
        submitSuccessResp = "success";
    } else {
        submitErrorResp = responseMsg;
    }
}
String smtpUsername = db.getSystemPreferencesValue("smtpUsername");
String smtpPassword = db.getSystemPreferencesValue("smtpPassword");
%>
<div class="col-md-12">
    <form accept-charset="UTF-8" method="POST" action="system-preferences.jsp" novalidate="novalidate" id="susPreForm">
        <div class="col-md-4"></div>
        <div class="col-md-4">
            <div class="panel panel-primary">
                <div class="panel-heading">SMTP Outgoing Mail - GMAIL Settings</div>
                <div class="panel-body">
                    <div class="form-group required">
                        <label class="required control-label">
                            <abbr title="required">*</abbr> Username
                        </label>
                        <input class="string required form-control" name="username" id="username" type="text" value="<%= smtpUsername %>">
                    </div>
                    <div class="form-group required">
                        <label class="required control-label">
                            <abbr title="required">*</abbr> Password
                        </label>
                        <input class="required form-control" name="password" id="password" type="password" value="<%= smtpPassword %>">
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4"></div>
        <div class="clearfix">&nbsp;</div>
        <div class="panel panel-primary">
            <div class="panel-heading">Save</div>
            <div class="panel-body">

                <input class="btn btn-default" type="button" value="Save all values" name="btnSubmit" onclick="sysPrefBtn();">
                <div class="clearfix">&nbsp;</div>
                <div id="helpMsgContainer">
                    <%    // on page submit
                        if (request.getParameter("username") != null) {
                            if (submitSuccessResp.equals("success")) {
                                out.println("<p class='help-block text-green' id='helpMsg'>System Preferences updated successfully</p>");
                            } else if (submitErrorResp != "") {
                                out.println("<p class='help-block text-red' id='helpMsg'>" + submitErrorResp + "</p>");
                            }
                        }
                    %>
                </div>
            </div>
        </div>
    </form>
</div>
<script type="text/javascript">
    function sysPrefBtn() {
        var username = document.getElementById("username").value;
        var password = document.getElementById("password").value;
        var msg = "";
        if (!username) {
            msg = "Username is required.";
        } else if (!password) {
            msg = "Password is required.";
        } else {
            document.getElementById("susPreForm").submit();
        }
        document.getElementById("helpMsgContainer").innerHTML = "<p class='help-block text-red' id='helpMsg'>" + msg + "</p>";
    }
</script>
<%@include file="footer.jsp" %>