<%-- 
    Document   : users-list
    Created on : nov 15, 2017, 06:24:09 PM
    Author     : chajj--%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="c.hajj.Database"%>
<%@include file="header.jsp" %>

<div class="page-container">
    <div class="panel panel-default">
        <div class="panel-heading">
            Users List &nbsp;&nbsp;&nbsp;<span class="text-red">(Allowed active users: <%= session.getAttribute("licenseNbOfUsers").toString()%>)</span>
            <div class="btn-group pull-right">
                <button class="btn btn-info">Actions</button>
                <button class="btn btn-info dropdown-toggle dropdown-actions-list" data-toggle="dropdown"><span class="caret"></span></button>
                <ul class="dropdown-menu">
                    <li><a href="user-add.jsp">Add user</a></li>
                    <li class="divider"></li>
                    <li><a href="export-excel/users.jsp?exportToExcel=YES">Export to Excel</a></li>
                </ul>
            </div>
        </div>
        <table class="table">
            <thead>
            <th style="width: 400px;">Username "Local Account"</th>
            <th style="width: 400px;">User Group "Role"</th>
            <th style="width: 400px;">Email "Google Account"</th>
            <th style="width: 400px;">Has Google Auth</th>
            <th style="width: 400px;">Is Banned</th>
            <th style="width: 400px;">Actions</th>
            </thead>
            <tbody>
                <%                    List<String> users = new ArrayList<String>();
                    Database db = new Database();
                    users = db.getUsersList();
                    for (int i = 0; i < users.size(); i++) {
                        String cell = (String) users.get(i);
                        String[] params = cell.split(",");
                %>
                <tr>
                    <%
                        for (int j = 0; j < params.length; j++) {
                            String userName = params[0].substring(1);
                            String userRoles = params[1];
                            String text = params[j];
                            if (text.startsWith("[")) {
                                text = text.substring(1);
                            }
                            if (text.endsWith("]")) {
                                text = text.substring(0, text.length() - 1);
                            }
                            if (j == 5) { // "*action*"
%>
                    <td style="width: 550px;">
                        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editUserModal" data-whatever="@mdo" title="Edit User" onclick="editUserDialog('<%= userName%>', '<%= userRoles%>');">
                            <span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
                        </button>
                        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#changePwdModal" data-whatever="@mdo" title="Change Password" onclick="changeUserPasswordDialog('<%= userName%>');">
                            <span class="glyphicon glyphicon-wrench" aria-hidden="true"></span>
                        </button>
                        <%
                            int activeUsers = db.getActiveUsers();
                            String allowedUsers = session.getAttribute("licenseNbOfUsers").toString();
                            String isBanned = params[j - 1].substring(1, 3); // banned come from db as " no"
                            if (isBanned.equals("no")) {
                                isBanned = "no";
                        %>
                        <button type="button" class="btn btn-default" aria-label="Left Align" title="Ban" onclick="banUnbanUser('<%= userName%>', '<%= isBanned%>', '<%= activeUsers%>', '<%= allowedUsers%>');">
                            <span class="glyphicon glyphicon-ban-circle" aria-hidden="true"></span>
                        </button>
                        <%
                        } else {
                            isBanned = "yes";
                        %>
                        <button type="button" class="btn btn-default" aria-label="Left Align" title="Un-Ban" onclick="banUnbanUser('<%= userName%>', '<%= isBanned%>', '<%= activeUsers%>', '<%= allowedUsers%>');">
                            <span class="glyphicon glyphicon-ok-sign" aria-hidden="true"></span>
                        </button>
                        <%
                            }
                        %>
                        <button type="button" class="btn btn-default" data-toggle="modal" data-whatever="@mdo" title="Flag user to change password at next login" onclick="flagChangePass('<%= userName%>');">
                            <span class="glyphicon glyphicon-tags" aria-hidden="true"></span>
                        </button>
                    </td>
                    <%
                    } else {
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

<input type="hidden" id="tempInput" value="" />

<div id="changePwdModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="changePwdModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="changePwdModal">Change Password</h4>
            </div>
            <div class="modal-body">
                <form>
                    <input type="hidden" id="usernameField" value="" />
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">New Password:</label>
                        <input type="password" class="form-control" id="newPwd">
                    </div>
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">Confirm New Password:</label>
                        <input type="password" class="form-control" id="confirmNewPwd">
                    </div>
                    <p class="help-block text-red" id="validationMsg"></p>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default modalCloseBtn" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="changePwdBtn">Save</button>
            </div>
        </div>
    </div>
</div>

<div id="editUserModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="editUserModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="editUserModal">Edit user</h4>
            </div>
            <div class="modal-body">
                <form>
                    <input type="hidden" id="oldUsername" value="" />
                    <div class="form-group">
                        <label class="control-label">Username:</label>
                        <input type="text" class="form-control" id="username">
                    </div>
                    <div class="form-group">
                        <label class="control-label">Use Groups:</label>
                        <%@include file="user-groups-dropdown.jsp" %>
                    </div>
                    <p class="help-block text-red" id="validationEditMsg"></p>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default modalEditUserCloseBtn" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="editUserBtn">Save</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(function () {
        $("#changePwdBtn").click(function () {
            var username = $("#usernameField").val();
            var newPwd = $("#newPwd").val();
            var confirmNewPwd = $("#confirmNewPwd").val();
            var msg = "";
            if (!newPwd) {
                msg = "New password is required.";
            } else if (!confirmNewPwd) {
                msg = "Confirm password is required.";
            } else if (newPwd != confirmNewPwd) {
                msg = "New password does not match the confirm password. Please try again.";
            } else { // check if old password is correct, then update user password in DB
                changeUserPwd(username, newPwd);
            }
            document.getElementById("validationMsg").innerHTML = msg;
        });
        $("#editUserBtn").click(function () {
            var username = $("#username", "#editUserModal").val();
            var roles = $("#roles", '#editUserModal').val();
            var msg = "";
            if (!username) {
                msg = "Username is required.";
            } else if (!roles) {
                msg = "User Groups is required.";
            } else {
                submitEditForm(username, roles);
            }
            document.getElementById("validationEditMsg").innerHTML = msg;
        });
        $('.selectpicker').selectpicker();
    });
</script>

<%@include file="footer.jsp" %>