<%-- 
    Document   : admin-setup
    Created on : nov 15, 2015=7, 9:35:55 PM
    Author     : chajj
--%>

<%@include file="header.jsp" %>

<div class="col-md-12">
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">Manage Users</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="users-list.jsp">
                        <img class="img-rounded" src="resources/images/users_list.png" width="128" height="128" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <a href="users-list.jsp" class="btn btn-link pull-right admin-links">Manage Users</a>
                    <div class="clearfix">&nbsp;</div>
                    <div class="clearfix">&nbsp;</div>
                    <a href="user-add.jsp" class="btn btn-link pull-right admin-links">Add User</a>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">Manage User Groups</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="user-groups-list.jsp">
                        <img class="img-rounded" src="resources/images/user_groups_list.png" width="128" height="128" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <a href="user-groups-list.jsp" class="btn btn-link pull-right admin-links">List Groups</a>
                    <div class="clearfix">&nbsp;</div>
                    <div class="clearfix">&nbsp;</div>
                    <a href="user-group-add.jsp" class="btn btn-link pull-right admin-links">Add Group</a>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">System Preferences</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="system-preferences.jsp">
                        <img class="img-rounded" src="resources/images/system_preferences.png" width="128" height="128" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <div class="clearfix">&nbsp;</div>
                    <a href="system-preferences.jsp" class="btn btn-link pull-right admin-links">Default Values</a>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">License</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="#">
                        <img class="img-rounded" src="resources/images/license.png" width="128" height="128" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <button type="button" class="btn btn-link pull-right admin-links" data-toggle="modal" data-target="#checkLicenseModal" data-whatever="@mdo" title="Check License">
                        <span>Check License</span>
                    </button>
                    <div class="clearfix">&nbsp;</div>
                    <div class="clearfix">&nbsp;</div>
                    <button type="button" class="btn btn-link pull-right admin-links" data-toggle="modal" data-target="#updateLicenseModal" data-whatever="@mdo" title="Update License">
                        <span>Update License</span>
                    </button>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">Audit Reports</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="#">
                        <img class="img-rounded" src="resources/images/lists.png" width="128" height="128" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <div class="clearfix">&nbsp;</div>
                    <a href="#" class="btn btn-link pull-right admin-links">Login Report</a>
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="panel panel-primary">
            <div class="panel-heading">Money / Stock Settings</div>
            <div class="panel-body">
                <div class="col-md-4 no-padding">
                    <a href="#">
                        <img class="img-rounded" src="resources/images/accounting.png" width="128" height="128" />
                    </a>
                </div>
                <div class="col-md-8">
                    <div class="clearfix">&nbsp;</div>
                    <a href="#" class="btn btn-link pull-right admin-links">Accounting Settings</a>
                    <div class="clearfix">&nbsp;</div>
                    <div class="clearfix">&nbsp;</div>
                    <a href="#" class="btn btn-link pull-right admin-links">Stock Settings</a>
                </div>
            </div>
        </div>
    </div>
</div>
<%    Database db = new Database();
%>
<div id="checkLicenseModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="checkLicenseModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="checkLicenseModal">License Data</h4>
            </div>
            <div class="modal-body">
                <div class='row'>
                    <div class='col-md-12'>
                        <div class='row'>
                            <div class='col-md-6'>
                                <h4>Product: <span style='font-size: 16px;'><%= session.getAttribute("licenseProduct").toString()%></span></h4>
                            </div>
                            <div class='col-md-6'>
                                <h4>Client: <span style='font-size: 16px;'><%= session.getAttribute("licenseClient").toString()%></span></h4>
                            </div>
                        </div>
                        <div class='row'>
                            <div class='col-md-6'>
                                <h4>Allowed users: <span style='font-size: 16px;'><%= session.getAttribute("licenseNbOfUsers").toString()%></span></h4>
                            </div>
                            <div class='col-md-6'>
                                <h4>Active users: <span style='font-size: 16px;'><%= db.getActiveUsers()%></span></h4>
                            </div>
                        </div>
                        <div class='row'>
                            <div class='col-md-6'>
                                <h4>Expires on: <span style='font-size: 16px;'><%= session.getAttribute("licenseExpiresOn").toString()%></span></h4>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default checkLicenseModalCloseBtn" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<div id="updateLicenseModal" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="updateLicenseModal">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="updateLicenseModal">Update License</h4>
            </div>
            <div class="modal-body">
                <div class='row'>
                    <div class='col-md-12'>
                        <h4>To renew the license or upgrade nb of users, please contact the support team (support@smb215.com) for more details.</h4>
                        <br />
                        <h4>When you purchase and receive the license file, you can upload it in the root of the application or replace the content of the current file.</h4>
                        <br />
                        <h4 class='text-red'>Note that, you cannot change the content of license file without checking the provider.</h4>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default updateLicenseModalCloseBtn" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<%@include file="footer.jsp" %>