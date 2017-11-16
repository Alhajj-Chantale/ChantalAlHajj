function aboutApp(appName, appVersion, product, client) {
    alert(appName + "." + appVersion + "\nProduct name: " + product + "\nLicensed to: " + client + "\n\nCredits:\n\u2022 jQuery v1.11.3\n\u2022 jQuery UI v1.11.2\n\u2022 Bootstrap v3.3.5\n\u2022 Bootstrap-select v1.7.2\n\u2022 FullCalendar v2.4.0\n\u2022 Moment JS v2.9.0\n\u2022 jQuery DateTimePicker v2.4.5\n\u2022 Highcharts JS v4.1.8");
}
function getCurrentURLWithoutGetParams()
{
    //get full url
    var url = window.location.href;
    //get url after/  
    var value = url.substring(0, url.indexOf('?'));
    //get the part after before ?
    //value = value.split("?")[0];
    return value;
}

//nth_occurrence('aaaaacabkhjecdddchjke', 'c', 3);
// Returns 16. The index of the third 'c' character.
function nth_occurrence(string, char, nth) {
    var first_index = string.indexOf(char);
    var length_up_to_first_index = first_index + 1;

    if (nth == 1) {
        return first_index;
    } else {
        var string_after_first_occurrence = string.slice(length_up_to_first_index);
        var next_occurrence = nth_occurrence(string_after_first_occurrence, char, nth - 1);

        if (next_occurrence === -1) {
            return -1;
        } else {
            return length_up_to_first_index + next_occurrence;
        }
    }
}

function clearGoogleParamsFromURL(googleRespone) {
    var currentURL = getCurrentURLWithoutGetParams();
    if (currentURL) {
        var indexOfProjectName = nth_occurrence(currentURL, '/', 4);
        window.location = currentURL.substring(0, indexOfProjectName + 1) + "social-networks.jsp?googleRespone=" + googleRespone;
    }

}

function banUnbanUser(username, isBanned, activeUsers, allowedUsers) {
    var userAction = "";
    var banUser = "";
    var confirmed = "";
    if (isBanned == 'no') { // ban user
        if (confirm("Are you sure do you want to ban \"" + username + "\" user?")) {
            confirmed = 1;
            userAction = "banUser";
            banUser = "yes";
        }
    } else { // unban user
        allowedUsers = allowedUsers * 1;
        if (allowedUsers > activeUsers) { // check license users
            if (confirm("Are you sure do you want to unban \"" + username + "\" user?")) {
                confirmed = 1;
                userAction = "unbanUser";
                banUser = "no";
            }
        } else {
            alert("License users exceeded. You cannot unban users.");
        }
    }
    if (confirmed == 1) {
        $.ajax({
            url: "user-actions.jsp",
            dataType: 'JSON',
            type: 'POST',
            data: {userAction: userAction, username: username, banUser: banUser},
            success: function (response) {
                alert(response.data);
                location.reload();
            },
            error: function (xhr, status) {
                alert("Sorry, there was a problem!");
            }
        });
    }
}

function changeUserPasswordDialog(username) {
    $("#newPwd").val("");
    $("#confirmNewPwd").val("");
    $("#usernameField").val(username);
    $('#changePwdModal').on('show.bs.modal', function (event) {
        var modal = $(this);
        modal.find('.modal-title').text("Change password for \"" + username + "\"");
    });
}
function changeUserPwd(username, newPwd) {
    $.ajax({
        url: "user-actions.jsp",
        dataType: 'JSON',
        type: 'POST',
        data: {userAction: "changePassword", username: username, newPassword: newPwd},
        success: function (response) {
            alert(response.data);
            $(".modalCloseBtn").click();
        },
        error: function (xhr, status) {
            alert("Sorry, there was a problem!");
        }
    });

}
function editUserDialog(username, roles) {
    roles = roles.substr(1);
    var rolesAr = roles.split('; ');
    var tempAr = [];
    for (i in rolesAr) {
        tempAr.push(rolesAr[i]);
    }
    $('.selectpicker').selectpicker('val', tempAr);
    $('.selectpicker').selectpicker('render');
    $("#username", '#editUserModal').val(username);
    $("#oldUsername", '#editUserModal').val(username);
    $('#editUserModal').on('show.bs.modal', function (event) {
        var modal = $(this);
        modal.find('.modal-title').text("Edit user \"" + username + "\"");
    });
}
function submitEditForm(username, roles) {
    var oldUsername = $("#oldUsername", '#editUserModal').val();
    var rolesObj = {};
    for (i in roles) {
        rolesObj[roles[i]] = roles[i];
    }
    var rolesObj = JSON.stringify(rolesObj);
    $.ajax({
        url: "user-actions.jsp",
        dataType: 'JSON',
        type: 'POST',
        data: {userAction: "editUser", oldUsername: oldUsername, newUsername: username, newRoles: rolesObj},
        success: function (response) {
            alert(response.data);
            $(".modalEditUserCloseBtn").click();
            location.reload();
        },
        error: function (xhr, status) {
            alert("Sorry, there was a problem!");
        }
    });

}
function editGroupDialog(name) {
    $("#name", '#editGroupModal').val(name);
    $("#oldName", '#editGroupModal').val(name);
    $('#editGroupModal').on('show.bs.modal', function (event) {
        var modal = $(this);
        modal.find('.modal-title').text("Edit user group \"" + name + "\"");
    });
}
function submitEditGroupForm(name) {
    var oldName = $("#oldName", '#editGroupModal').val();
    if (oldName == name) {
        alert("no changes!!!");
        $(".modalEditGroupCloseBtn").click();
    } else {
        $.ajax({
            url: "user-actions.jsp",
            dataType: 'JSON',
            type: 'POST',
            data: {userAction: "editUserGroup", oldName: oldName, newName: name},
            success: function (response) {
                alert(response.data);
                $(".modalEditGroupCloseBtn").click();
                location.reload();
            },
            error: function (xhr, status) {
                alert("Sorry, there was a problem!");
            }
        });
    }


}
function disconnectGoogleAccount(username, gooleUrl, appName) {
    $.ajax({
        url: "user-actions.jsp",
        dataType: 'JSON',
        type: 'POST',
        data: {userAction: "disconnectGoogleAccount", username: username},
        success: function (response) {
            if (response.data == "success") {
                $(".btn-google-connect").removeClass("btn-default").addClass("btn-info").html("Connect").attr("onclick", "").attr("href", gooleUrl);
                $(".googleText").html("Your " + appName + " account is not connected to Google");
            } else {
                alert("Sorry, there was a problem when updating data in DB!");
            }
        },
        error: function (xhr, status) {
            alert("Sorry, there was a problem!");
        }
    });
}
function killBannedUser(username) {
    $.ajax({
        url: "user-actions.jsp",
        dataType: 'JSON',
        type: 'POST',
        data: {userAction: "killBannedUser", username: username},
        success: function (response) {
            if (response.data == "isBanned") {
                alert("Your account has been banned. Sorry you cannot access the application again. Please check your Administrator.");
                window.location = window.location.href;
            }
        },
        error: function (xhr, status) {
        }
    });
}
function getPendingNotifications(username, containerList) {
    $.ajax({
        url: "user-actions.jsp",
        dataType: 'JSON',
        type: 'POST',
        data: {userAction: "getPendingNotifications", username: username},
        beforeSend: function (xhr) {
            containerList.html($('#notification-content-template').html());
        },
        success: function (response) {
            if (response.data != "") {
                var data = response.data;
                var row = data.split('%row-separator%');
                containerList.html('');
                var counter = -1;
                for (i in row) {
                    counter = counter + 1;
                    var line = row[i];
                    line = line.substr(1);
                    line = line.substr(0, line.length - 1);
                    var col = line.split(',');
                    var message = col[0];
                    message = message.replace("&comma&", ",");
                    message = message.substr(0, 13);
                    if (message != "") {
                        containerList.append('<div class="col-md-12 notificationRow"><div class="col-md-6 notificationMessageCell"><p>' + message + '</p></div><div class="col-md-3"><p>' + col[1] + '</p></div></div>');
                    }
                }
                if (counter > 0) {
                    var oldCounter = $('#notificationCounterNb', '#notificationBtn').html();
                    oldCounter = oldCounter * 1;
                    var newCounter = oldCounter - counter;
                    if (newCounter > 0) {
                        $('#notificationCounterNb', '#notificationBtn').html(newCounter);
                    } else {
                        $('#notificationSpan', '#notificationBtn').html('');
                    }
                }
            } else {
                containerList.html('<div class="col-md-12 notificationRow"><p>There is no pending notifications</p></div>');
                $('#notificationSpan', '#notificationBtn').html('');
            }
            containerList.append('<a href="notify.jsp" class="btn btn-link">Notify</a><a href="show-my-notifications.jsp" class="btn btn-link pull-right">Show all</a>');
        },
        error: function (xhr, status) {
        }
    });
}
function getCounterNotifications(username) {
    $.ajax({
        url: "user-actions.jsp",
        dataType: 'JSON',
        type: 'POST',
        data: {userAction: "getCounterNotifications", username: username},
        beforeSend: function (xhr) {
        },
        success: function (response) {
            var counter = response.data * 1;
            if (counter > 0) {
                $('#notificationSpan', '#notificationBtn').html('&nbsp;<span class="text-red" id="notificationCounterNb">' + response.data + '</span>');
            }
        },
        error: function (xhr, status) {
        }
    });
}
function collapse(d, c) {
    jQuery("#" + c).toggleClass("hide");
    if (jQuery("#" + c).hasClass("hide")) {
        old_class = "glyphicon glyphicon-chevron-down";
        new_class = "glyphicon glyphicon-chevron-right"
    } else {
        old_class = "glyphicon glyphicon-chevron-right";
        new_class = "glyphicon glyphicon-chevron-down";
    }
    jQuery("#" + d).find("i").removeClass(old_class).addClass(new_class);
}
$.fn.serializeObject = function ()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function () {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};
function flagChangePass(username) {
    if (confirm("The user \"" + username + "\" will be enforced to change his password on his next login?")) {
        $.ajax({
            url: "user-actions.jsp",
            dataType: 'JSON',
            type: 'POST',
            data: {userAction: "flagChangeUserPass", username: username},
            success: function (response) {
                location.reload();
            },
            error: function (xhr, status) {
                alert("Sorry, there was a problem!");
            }
        });
    }

}
function checkUserFlagChangePwd(username) {
    $.ajax({
        url: "user-actions.jsp",
        dataType: 'JSON',
        type: 'POST',
        data: {userAction: "checkUserFlagChangePwd", username: username},
        success: function (response) {
            if (response.data == "yes") {
                var currentURL = window.location.href;
                if (currentURL.substring(currentURL.lastIndexOf("/") + 1) != "user-profile-change-pwd.jsp") {
                    alert("Your account has been flagged to change your password. Sorry you cannot access the application again. Please check your Administrator, or change your password.");
                    var indexOfProjectName = nth_occurrence(currentURL, '/', 4);
                    window.location = currentURL.substring(0, indexOfProjectName + 1) + "user-profile-change-pwd.jsp";
                }
            }
        },
        error: function (xhr, status) {
        }
    });
}