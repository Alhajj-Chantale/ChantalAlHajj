<%-- 
    Document   : calendar
    Created on : nov 15, 2017, 08:52:27 PM
    Author     : chajj--%>

<%@include file="header.jsp" %>

<div class="col-md-12">
    <div class="col-md-4"></div>
    <div class="col-md-4">
        <div class="form-group" id="selectedUsers">
            <label class="control-label">Calendars:</label>
            <select class="selectpicker" multiple id="usersList">
                <%        List<String> usersList = new ArrayList<String>();
                    Database dbClassIns = new Database();
                    usersList = dbClassIns.getUsersList();
                    for (int i = 0; i < usersList.size(); i++) {
                        String cell = (String) usersList.get(i);
                        String[] params = cell.split(",");
                %>

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
                        if (j == 0) {
                %>
                <option><%= text%></option>
                <%
                        }
                    }
                %>
                <%
                    }%>

            </select>
        </div>
    </div>
    <div class="col-md-4"></div>
</div>

<div class="clearfix">&nbsp;</div>

<div id="calendar"></div>

<div id="eventModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="eventModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="eventModal">Event</h4>
            </div>
            <div class="modal-body">
                <form>
                    <input type="hidden" id="id" value="" />
                    <div class="form-group required">
                        <label class="required control-label"><abbr title="required">*</abbr> Title:</label>
                        <input type="text" class="form-control" id="title">
                    </div>
                    <div class="form-group required">
                        <label class="required control-label"><abbr title="required">*</abbr> Start:</label>
                        <input type="text" id="start" class="form-control datepicker" data-date-format="mm/dd/yyyy">
                    </div>
                    <div class="form-group">
                        <label class="control-label">End:</label>
                        <input type="text" class="form-control datepicker" id="end">
                    </div>
                    <div class="form-group">
                        <label class="control-label">Location:</label>
                        <input type="text" class="form-control" id="location">
                    </div>
                    <div class="form-group" id="invitiesContainer">
                        <label class="control-label">Invities:</label>
                        <%@include file="users-dropdown.jsp" %>
                    </div>
                    <div id="helpMsgContainer">
                        <p class="help-block text-red" id="errorMsg"></p>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default modalEventCloseBtn" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="eventBtn" onClick="eventBtn();">Save</button>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        var selectedUsers = $('#usersList', '#selectedUsers');
        selectedUsers.change(function () {
            var changedValues = selectedUsers.val();
            var newObjUsers = {};
            for (i in changedValues) {
                newObjUsers[changedValues[i]] = changedValues[i];
            }
            newObjUsers = JSON.stringify(newObjUsers);
            $.ajax({
                url: "user-actions.jsp",
                dataType: 'JSON',
                type: 'POST',
                data: {userAction: "readEvents", users: newObjUsers},
                success: function (response) {
                    var newData = response.data;
                    var newEvents = [];
                    for (var key in newData) {
                        newEvents.push(newData[key]);
                    }
                   $('#calendar').fullCalendar('removeEvents');
                   $('#calendar').fullCalendar('addEventSource', newEvents);
                },
                error: function (xhr, status) {
                    alert("Sorry, there was a problem!");
                }
            });
        });
        selectedUsers.val('<%= request.getUserPrincipal().getName()%>');
        var listUsers = selectedUsers.val();
        var objUsers = {};
        for (i in listUsers) {
            objUsers[listUsers[i]] = listUsers[i];
        }
        objUsers = JSON.stringify(objUsers);
        $.ajax({
            url: "user-actions.jsp",
            dataType: 'JSON',
            type: 'POST',
            data: {userAction: "readEvents", users: objUsers},
            success: function (response) {
                var data = response.data;
                var events = [];
                for (var key in data) {
                    events.push(data[key]);
                }
                $('#calendar').fullCalendar({
                    events: events,
                    header: {
                        left: 'prev,next today',
                        center: 'title',
                        right: 'month,agendaWeek,agendaDay'
                    },
                    editable: true,
                    selectable: true,
                    selectHelper: true,
                    select: function (start, end) {
                        $("#errorMsg").addClass("hide");
                        $("#title", "#eventModal").val('');
                        $("#location", "#eventModal").val('');
                        $("#start", "#eventModal").val(moment(start).format('YYYY-MM-DD HH:mm'));
                        $("#end", "#eventModal").val(moment(end).format('YYYY-MM-DD HH:mm'));
                        $('.selectpicker').selectpicker();
                        $("#eventModal").submit(function () {
                            eventBtn();
                        });
                        $('#eventModal').modal();
                        $("#title", "#eventModal").focus();
                        $('#eventModal').on('shown.bs.modal', function () {
                            $('#title').focus();
                            $('.datepicker').datetimepicker({format: 'Y-m-d H:i'});
                        });
                    },
                    eventDrop: function (event, dayDelta, minuteDelta, allDay, revertFunc) {
                        var start = moment(event.start).format('YYYY-MM-DD HH:mm');
                        var end = moment(event.end).format('YYYY-MM-DD HH:mm');
                        $.ajax({
                            url: "user-actions.jsp",
                            dataType: 'JSON',
                            type: 'POST',
                            data: {userAction: "editEvent", id: event.id, start: start, end: end},
                            success: function (response) {
                            },
                            error: function (xhr, status) {
                                alert("Sorry, there was a problem!");
                            }
                        });
                    },
                    eventResize: function (event, delta, revertFunc) {
                        revertFunc();
                    }
                });
            },
            error: function (xhr, status) {
                alert("Sorry, there was a problem!");
            }
        });
    });
    function eventBtn() {
        var title = $("#title", "#eventModal").val();
        var location = $("#location", "#eventModal").val();
        var start = $("#start", "#eventModal").val();
        var end = $("#end", "#eventModal").val();
        var users = $("#users", "#invitiesContainer").val();
        var msg = "";
        if (!title) {
            msg = "Title is required.";
            document.getElementById("errorMsg").innerHTML = msg;
            $("#errorMsg").removeClass("hide");
        } else if (!start) {
            msg = "Start is required.";
            document.getElementById("errorMsg").innerHTML = msg;
            $("#errorMsg").removeClass("hide");
        } else if (!users) {
            msg = "Invities users is required.";
            document.getElementById("errorMsg").innerHTML = msg;
            $("#errorMsg").removeClass("hide");
        } else {
            // submit event form
            $("#errorMsg").addClass("hide");
            var loggedUser = '<%= request.getUserPrincipal().getName()%>';
            var usersObj = {};
            for (i in users) {
                usersObj[users[i]] = users[i];
            }
            usersObj = JSON.stringify(usersObj);
            $.ajax({
                url: "user-actions.jsp",
                dataType: 'JSON',
                type: 'POST',
                data: {userAction: "addEvent", title: title, start: start, end: end, location: location, users: usersObj, createdBy: loggedUser},
                beforeSend: function (xhr) {
                    $("#errorMsg").addClass("hide");
                    $("#successMsg").addClass("hide");
                    $("#helpMsgContainer").append("<div class='notificationLoader'><img class='loading-image' src='resources/images/icons/loading.png' /></div>");
                },
                success: function (response) {
                    $('.notificationLoader').addClass("hide");
                    var id = response.data;
                    if (id > 0) {
                        $("#errorMsg").addClass("hide");
                        $(".modalEventCloseBtn").click();
                        var eventData;
                        eventData = {
                            id: id,
                            title: title,
                            start: moment(start).format('YYYY-MM-DDTHH:mm:ssZ'), //YYYY-MM-DDTHH:mm:ssZ
                            end: moment(end).format('YYYY-MM-DDTHH:mm:ssZ')
                        };
                        $('#calendar').fullCalendar('renderEvent', eventData, true);
                        $('#calendar').fullCalendar('unselect');
                    } else {
                        $("#errorMsg").removeClass("hide").html("Failed to add event, please refresh the page and try again");
                    }
                },
                error: function (xhr, status) {
                    alert("Sorry, there was a problem!");
                }
            });
        }
    }
</script>

