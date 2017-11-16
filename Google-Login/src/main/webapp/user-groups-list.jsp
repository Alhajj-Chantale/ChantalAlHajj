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
            User Groups List
            <div class="btn-group pull-right">
                <button class="btn btn-info">Actions</button>
                <button class="btn btn-info dropdown-toggle dropdown-actions-list" data-toggle="dropdown"><span class="caret"></span></button>
                <ul class="dropdown-menu">
                    <li><a href="user-group-add.jsp">Add user group</a></li>
                    <li class="divider"></li>
                    <li><a href="export-excel/user-groups.jsp?exportToExcel=YES">Export to Excel</a></li>
                </ul>
            </div>
        </div>
        <table class="table">
            <thead>
            <th style="width: 400px;">Name</th>
            <th style="width: 400px;">Actions</th>
            </thead>
            <tbody>
                <%                    List<String> userGroups = new ArrayList<String>();
                    Database db = new Database();
                    userGroups = db.getUserGroupsList();
                    for (int i = 0; i < userGroups.size(); i++) {
                        String cell = (String) userGroups.get(i);
                        String[] params = cell.split(",");
                %>
                <tr>
                    <%
                        for (int j = 0; j < params.length; j++) {
                            String name = params[0].substring(1);
                            String text = params[j];
                            if (text.startsWith("[")) {
                                text = text.substring(1);
                            }
                            if (text.endsWith("]")) {
                                text = text.substring(0, text.length() - 1);
                            }
                            if (j == 1) { // "*action*"
                    %>
                    <td style="width: 400px;">
                        <button type="button" class="btn btn-default" data-toggle="modal" data-target="#editGroupModal" data-whatever="@mdo" title="Edit Group" onclick="editGroupDialog('<%= name%>');">
                            <span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
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

<div id="editGroupModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="editGroupModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="editGroupModal">Edit user group</h4>
            </div>
            <div class="modal-body">
                <form>
                    <input type="hidden" id="oldName" value="" />
                    <div class="form-group">
                        <label class="control-label">Name:</label>
                        <input type="text" class="form-control" id="name">
                    </div>
                    <p class="help-block text-red" id="validationEditMsg"></p>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default modalEditGroupCloseBtn" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="editGroupBtn">Save</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(function () {
        $("#editGroupBtn").click(function () {
            var username = $("#name", "#editGroupModal").val();
            var msg = "";
            if (!username) {
                msg = "Username is required.";
            } else {
                submitEditGroupForm(username);
            }
            document.getElementById("validationEditMsg").innerHTML = msg;
        });
    });
</script>

<%@include file="footer.jsp" %>