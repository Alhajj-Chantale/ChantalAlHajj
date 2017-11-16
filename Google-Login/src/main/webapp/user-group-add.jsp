<%-- 
    Document   : user-add
    Created on : nov 15, 2017, 7:27:00 PM
    Author     : chajj--%>

<%@include file="header.jsp" %>

<div class="container master-container">
    <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-4">
            <div class="panel panel-primary">
                <div class="panel-heading">Add User Group</div>
                <div class="panel-body">
                    <form accept-charset="UTF-8" method="POST" action="" novalidate="novalidate" id="addUserGroupForm">
                        <div class="form-group required">
                            <label class="required control-label">
                                <abbr title="required">*</abbr> Name
                            </label>
                            <input class="string required form-control" name="username" id="name" placeholder="Enter your group name" type="text">
                        </div>
                        <input class="btn btn-default" type="button" value="Submit" name="btnSubmit" onclick="addUserGroupBtn();">
                        <a href="user-groups-list.jsp" class="pull-right btn btn-link">Back to list</a>
                        <div class="clearfix">&nbsp</div>
                        <div id="helpMsgContainer">
                            <p class="help-block text-green hide" id="successMsg">User group added successfully</p>
                            <p class="help-blolck text-red" id="errorMsg"></p>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-md-4"></div>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        $("#addUserGroupForm").submit(function () {
            addUserGroupBtn();
        });
    });
    function addUserGroupBtn() {
        var name = $("#name", "#addUserGroupForm").val();
        var msg = "";
        if (!name) {
            msg = "Name is required.";
            document.getElementById("errorMsg").innerHTML = msg;
        }else {
            // submit user group form
            $("#errorMsg").addClass("hide");
            $.ajax({
                url: "user-actions.jsp",
                dataType: 'JSON',
                type: 'POST',
                data: {userAction: "addUserGroup", name: name},
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
        }
    }
</script>
<%@include file="footer.jsp" %>