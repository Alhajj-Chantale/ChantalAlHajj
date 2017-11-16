<%-- 
    Document   : contact-add
    Created on : nov 15, 2017, 10:00:00 PM
    Author     : chajj--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@include file="header.jsp" %>

<% // load form data    
    String id = request.getParameter("id");
    Database db = new Database();
    List<String> data = new ArrayList<String>();
    data = db.loadContact(id);
    String firstName = "", lastName = "", title = "", gender = "", jobTitle = "",
            email = "", dateOfBirth = "", mobile = "", phone = "", fax = "",
            address1 = "", address2 = "", city = "", state = "", country = "",
            zip = "";
    if (data.size() > 0) {
        for (int i = 0; i < data.size(); i++) {
            String cell = (String) data.get(i);
            String[] params = cell.split(",");
            for (int j = 0; j < params.length; j++) {
                if (params[j].startsWith("[")) {
                    params[j] = params[j].substring(0);
                }
                if (params[j].endsWith("]")) {
                    params[j] = params[j].substring(0, params[j].length() - 1);
                }
                params[j] = params[j].replaceAll("&comma&", ",").substring(1);
                if (j == 0) {
                    firstName = params[j];
                } else if (j == 1) {
                    lastName = params[j];
                } else if (j == 2) {
                    title = params[j];
                } else if (j == 3) {
                    gender = params[j];
                } else if (j == 4) {
                    jobTitle = params[j];
                } else if (j == 5) {
                    email = params[j];
                } else if (j == 6) {
                    dateOfBirth = params[j];
                } else if (j == 7) {
                    mobile = params[j];
                } else if (j == 8) {
                    phone = params[j];
                } else if (j == 9) {
                    fax = params[j];
                } else if (j == 10) {
                    address1 = params[j];
                } else if (j == 11) {
                    address2 = params[j];
                } else if (j == 12) {
                    city = params[j];
                } else if (j == 13) {
                    state = params[j];
                } else if (j == 14) {
                    country = params[j];
                } else if (j == 15) {
                    zip = params[j];
                }
            }
        }
    } else {
        // @to-Do: redirect to contacts list
    }
%>

<div class="container master-container">
    <div class="row">
        <div class="panel panel-primary">
            <div class="panel-heading">Edit Contact</div>
            <div class="panel-body">
                <%@include file="contact-form.jsp" %>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    id = null;
    $(function () {
        $('#dateOfBirth').datepicker();
        $('#dateOfBirth').datepicker("option", "dateFormat", "yy-mm-dd");
        id = '<%= id%>';
        if (!id || id == "null" || id <= 0) {
            var currentURL = getCurrentURLWithoutGetParams();
            var indexOfProjectName = nth_occurrence(currentURL, '/', 4);
            window.location = currentURL.substring(0, indexOfProjectName + 1) + "contacts.jsp";
        } else {
            $('#firstName').val('<%= firstName%>');
            $('#lastName').val('<%= lastName%>');
            document.getElementById("title").value = '<%= title%>';
            $('#gender').val('<%= gender%>');
            $('#jobTitle').val('<%= jobTitle%>');
            $('#email').val('<%= email%>');
            $('#dateOfBirth').val('<%= dateOfBirth%>');
            $('#mobile').val('<%= mobile%>');
            $('#phone').val('<%= phone%>');
            $('#fax').val('<%= fax%>');
            $('#address1').val('<%= address1%>');
            $('#address2').val('<%= address2%>');
            $('#city').val('<%= city%>');
            $('#state').val('<%= state%>');
            $('#country').val('<%= country%>');
            $('#zip').val('<%= zip%>');

        }
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
            var loggedUser = '<%= request.getUserPrincipal().getName()%>'
            var formData = JSON.stringify($("#contactForm").serializeObject());
            $.ajax({
                url: "user-actions.jsp",
                dataType: 'JSON',
                type: 'POST',
                data: {userAction: "editContact", data: formData, loggedUser: loggedUser, id: id},
                success: function (response) {
                    if (response.data == "success") {
                        $("#errorMsg").addClass("hide");
                        $("#successMsg").html('Contact saved successfully').removeClass("hide");
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