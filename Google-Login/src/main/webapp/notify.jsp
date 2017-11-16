<%-- 
    Document   : notify
    Created on : nov 15, 2017, 11:08:00 PM
    Author     : chajj--%>

<%@include file="header.jsp" %>

<div class="container master-container">
    <div class="row">
        <div class="col-md-4"></div>
        <div class="col-md-4">
            <div class="panel panel-primary">
                <div class="panel-heading">Notify</div>
                <div class="panel-body">
                    <form accept-charset="UTF-8" method="POST" action="" novalidate="novalidate" id="notifyForm">
                        <div class="form-group required">
                            <label class="required control-label">
                                <abbr title="required">*</abbr> Message
                            </label>
                            <textarea class="string required form-control" name="message" id="message" rows="7"></textarea>
                        </div>
                        <div class="form-group required">
                            <label class="required control-label">
                                <abbr title="required">*</abbr> Users
                            </label>
                            <%@include file="users-dropdown.jsp" %>
                        </div>
                        <div class="form-group required">
                            <input class="" name="sendByEmail" id="sendByEmail" type="checkbox">
                            <label class="control-label">
                                Send notification by Email
                            </label>
                        </div>
                        <input class="btn btn-default" type="button" value="Send" name="btnSubmit" onclick="notifyBtn();">
                        <div id="helpMsgContainer">
                            <p class="help-block text-green hide" id="successMsg">Notification added successfully</p>
                            <p class="help-block text-red" id="errorMsg"></p>
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
        $('.selectpicker').selectpicker();
        $("#notifyForm").submit(function () {
            notifyBtn();
        });
    });
    function notifyBtn() {
        var message = $("#message", "#notifyForm").val();
        var users = $("#users", '#notifyForm').val();
        var msg = "";
        if (!message) {
            msg = "Message is required.";
            document.getElementById("errorMsg").innerHTML = msg;
        } else if (!users) {
            msg = "Users is required.";
            document.getElementById("errorMsg").innerHTML = msg;
        } else {
            // submit form
            $("#errorMsg").addClass("hide");
            var usersObj = {};
            for (i in users) {
                usersObj[users[i]] = users[i];
            }
            var usersObj = JSON.stringify(usersObj);
            var sendByEmail = $('#sendByEmail').is(':checked') ? "yes" : "no";
            $.ajax({
                url: "user-actions.jsp",
                dataType: 'JSON',
                type: 'POST',
                data: {userAction: "notifyUser", message: message, users: usersObj, sendByEmail: sendByEmail},
                beforeSend: function (xhr) {
                    $("#errorMsg").addClass("hide");
                    $("#successMsg").addClass("hide");
                    $("#helpMsgContainer").append("<div class='notificationLoader'><img class='loading-image' src='resources/images/icons/loading.png' /></div>");
                },
                success: function (response) {
                    $('.notificationLoader').addClass("hide");
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