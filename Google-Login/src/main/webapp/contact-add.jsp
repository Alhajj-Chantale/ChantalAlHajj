<%-- 
    Document   : contact-add
    Created on : nov 15, 2017, 10:00:00 PM
    Author     : chajj--%>

<%@include file="header.jsp" %>

<div class="container master-container">
    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading">Add Contact</div>
            <div class="panel-body">
                <%@include file="contact-form.jsp" %>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $(function () {
        $('#dateOfBirth').datepicker();
        $('#dateOfBirth').datepicker("option", "dateFormat", "yy-mm-dd");
        $("#contactForm").submit(function () {
            contactBtn();
        });
    });
    function contactBtn() {
        var firstName = $("#firstName", "#contactForm").val();
        var lastName = $("#lastName", "#contactForm").val();
        var msg = "";
        if (!firstName) {
            msg = "First name is required";
            document.getElementById("errorMsg").innerHTML = msg;
        } else if (!lastName) {
            msg = "Last name is required";
            document.getElementById("errorMsg").innerHTML = msg;
        } else {
            // submit contact form
            $("#errorMsg").addClass("hide");
            var loggedUser = '<%= request.getUserPrincipal().getName()%>';
            var formData = JSON.stringify($("#contactForm").serializeObject());
            $.ajax({
                url: "user-actions.jsp",
                dataType: 'JSON',
                type: 'POST',
                data: {userAction: "addContact", data: formData, loggedUser: loggedUser},
                success: function (response) {
                    if (response.data == "success") {
                        $("#errorMsg").addClass("hide");
                        $("#successMsg").removeClass("hide");
                        setTimeout(function () {
                            window.location.reload();
                        }, 1500);
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