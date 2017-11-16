<%-- 
    Document   : user-profile-change-pwd
    Created on : nov 15, 2017, 02:45:27 PM
    Author     : chajj--%>

<%@include file="header.jsp" %>

<div class="container master-container">
    <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-4">
            <div class="panel panel-primary">
                <div class="panel-heading">Change Password Form</div>
                <div class="panel-body">
                    <form accept-charset="UTF-8" method="POST" action="user-profile-change-pwd.jsp" novalidate="novalidate" id="changePwdForm">
                        <div class="form-group required">
                            <label class="required control-label">
                                <abbr title="required">*</abbr> Old Password
                            </label>
                            <input class="string required form-control" name="oldPassword" id="oldPassword" placeholder="Enter old password" type="password">
                        </div>
                        <div class="form-group required">
                            <label class="required control-label">
                                <abbr title="required">*</abbr> New Password
                            </label>
                            <input class="required form-control" name="newPassword" id="newPassword" placeholder="Enter new password" type="password">
                        </div>
                        <div class="form-group required">
                            <label class="required control-label">
                                <abbr title="required">*</abbr> Confirm New Password
                            </label>
                            <input class="required form-control" name="confirmNewPassword" id="confirmNewPassword" placeholder="Confirm new password" type="password">
                        </div>
                        <input class="btn btn-default" type="button" value="Submit" name="btnSubmit" onclick="profileChangePwd();">
                        <div class="clearfix">&nbsp;</div>
                        <div id="helpMsgContainer">
                        <%    Database db = new Database();
                            if (request.getParameter("oldPassword") != null) {
                                String oldPassword = request.getParameter("oldPassword");
                                String newPassword = request.getParameter("newPassword");
                                String responseMsg = db.updateProfilePassword(userProfileName, oldPassword, newPassword);
                                if (responseMsg.equals("success")) {
                                    out.println("<p class='help-block text-green' id='helpMsg'>User password changed successfully</p>");
                                } else {
                                    out.println("<p class='help-block text-red' id='helpMsg'>" + responseMsg +"</p>");
                                }
                            }
                        %>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-md-4"></div>
    </div>
</div>
<script type="text/javascript">
    function profileChangePwd() {
        var oldPwd = document.getElementById("oldPassword").value;
        var newPassword = document.getElementById("newPassword").value;
        var msg = "";
        var confirmNewPassword = document.getElementById("confirmNewPassword").value;
        if (!oldPwd) {
            msg = "Old password is required.";
        } else if (!newPassword) {
            msg = "New password is required.";
        } else if (!confirmNewPassword) {
            msg = "Confirm password is required.";
        } else if (newPassword != confirmNewPassword) {
            msg = "New password does not match the confirm password. Please try again.";
        } else { // check if old password is correct, then update user password in DB
            document.getElementById("changePwdForm").submit();
        }
        document.getElementById("helpMsgContainer").innerHTML = "<p class='help-block text-red' id='helpMsg'>" + msg + "</p>";
    }
</script>
<%@include file="footer.jsp" %>

