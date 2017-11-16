<%-- 
    Document   : user-add
    Created on : nov 15, 2017, 7:27:00 PM
    Author     : çhajj--%>

<%@include file="header.jsp" %>

<div class="container master-container">
    <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-4">
            <div class="panel panel-primary">
                <div class="panel-heading">Add User</div>
                <div class="panel-body">
                    <p>
                        <span class="text-red">Allowed active users: <%= session.getAttribute("licenseNbOfUsers").toString()%></span>
                    </p>
                    <form accept-charset="UTF-8" method="POST" action="" novalidate="novalidate" id="addUserForm">
                        <div class="form-group required">
                            <label class="required control-label">
                                <abbr title="required">*</abbr> Username
                            </label>
                            <input class="string required form-control" name="username" id="username" placeholder="Enter your username" type="text">
                        </div>
                        <div class="form-group required">
                            <label class="required control-label">
                                <abbr title="required">*</abbr> User Groups
                            </label>
                            <%@include file="user-groups-dropdown.jsp" %>
                        </div>
                        <div class="form-group required">
                            <label class="required control-label">
                                <abbr title="required">*</abbr> Password
                            </label>
                            <input class="required form-control" name="password" id="password" placeholder="Enter your password" type="password">
                        </div>
                        <div class="form-group required">
                            <label class="required control-label">
                                <abbr title="required">*</abbr> Confirm New Password
                            </label>
                            <input class="required form-control" name="confirmNewPassword" id="confirmNewPassword" placeholder="Confirm new password" type="password">
                        </div>
                        <input class="btn btn-default" type="button" value="Submit" name="btnSubmit" onclick="addUserBtn();">
                        <a href="users-list.jsp" class="pull-right btn btn-link">Back to list</a>
                        <div id="helpMsgContainer">
                            <p class="help-block text-green hide" id="successMsg">User added successfully</p>
                            <p class="help-block text-red" id="errorMsg"></p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-md-4"></div>
    </div>
</div>
<%
    Database db = new Database();
    int activeUsers = db.getActiveUsers();
    String allowedUsers = session.getAttribute("licenseNbOfUsers").toString();
%>
<script type="text/javascript">
    $(function () {
        $('.selectpicker').selectpicker();
        $("#addUserForm").submit(function () {
            addUserBtn();
        });
    });
    function addUserBtn() {
        var activeUsers = '<%= activeUsers%>';
        var allowedUsers = '<%= allowedUsers%>';
        allowedUsers = allowedUsers * 1;
        var username = $("#username", "#addUserForm").val();
        var roles = $("#roles", '#addUserForm').val();
        var newPassword = document.getElementById("password").value;
        var msg = "";
        var confirmNewPassword = document.getElementById("confirmNewPassword").value;
        $("#errorMsg").removeClass("hide");
        $("#successMsg").addClass("hide");
        if (!username) {
            msg = "Username is required.";
            document.getElementById("errorMsg").innerHTML = msg;
        } else if (!roles) {
            msg = "User Groups is required.";
            document.getElementById("errorMsg").innerHTML = msg;
        } else if (!newPassword) {
            msg = "Password is required.";
            document.getElementById("errorMsg").innerHTML = msg;
        } else if (!confirmNewPassword) {
            msg = "Confirm password is required.";
            document.getElementById("errorMsg").innerHTML = msg;
        } else if (newPassword != confirmNewPassword) {
            msg = "Password field does not match the confirm password. Please try again.";
            document.getElementById("errorMsg").innerHTML = msg;
        } else {
            if (allowedUsers > activeUsers) {
                // submit user form
                $("#errorMsg").addClass("hide");
                var rolesObj = {};
                for (i in roles) {
                    rolesObj[roles[i]] = roles[i];
                }
                var rolesObj = JSON.stringify(rolesObj);
                $.ajax({
                    url: "user-actions.jsp",
                    dataType: 'JSON',
                    type: 'POST',
                    data: {userAction: "addUser", username: username, roles: rolesObj, password: newPassword},
                    success: function (response) {
                        if (response.data == "success") {
                            $("#errorMsg").addClass("hide");
                            $("#successMsg").removeClass("hide");
                        } else {
                            $("#successMsg").addClass("hide");
                            $("#errorMsg").removeClass("hide").html(response.data);
                        }
                    },
                    error: function (xhr, status) {
                        alert("Sorry, there was a problem!");
                    }
                });
            } else {
                msg = "License users exceeded. You cannot add more users.";
                document.getElementById("errorMsg").innerHTML = msg;
            }
        }
    }
</script>
<%@include file="footer.jsp" %>