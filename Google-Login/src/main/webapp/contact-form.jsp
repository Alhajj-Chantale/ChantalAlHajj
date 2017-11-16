<%-- 
    Document   : contact-form
    Created on : nov 15, 2017, 10:52:55 PM
    Author     : chajj--%>

<form accept-charset="utf-8" method="post" id="contactForm" class="form-horizontal" novalidate="" action="">
    <div class="clearfix">&nbsp;</div>
    <div onclick="collapse('personal_info_toggle', 'personal_info_div');" id="personal_info_toggle" class="col-md-12 f_head">
        <div class="col-md-5">
            <div class="col-md-1">
                <i class="glyphicon glyphicon-chevron-down">&nbsp;</i>
            </div>
            <div class="col-md-11">
                <h4>Personal Information</h4>
            </div>
        </div>
    </div>
    <div class="clearfix">&nbsp;</div>
    <div id="personal_info_div" class="col-md-12 no-padding">
        <div class="col-md-12 no-padding">
            <div class="form-group col-md-6">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12 required">First Name</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" required="required" maxlength="255" id="firstName" name="firstName">
                </div>
            </div>
            <div class="form-group col-md-6">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12 required">Last Name</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" required="required" maxlength="255" id="lastName" name="lastName">
                </div>
            </div>
        </div>
        <div class="col-md-12 no-padding">
            <div class="form-group col-md-6">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12 col-xs-12">Title</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <select id="title" name="title">
                        <option selected="selected" value="">Choose Title</option>
                        <option value="Dr">Dr</option>
                        <option value="Judge">Judge</option>
                        <option value="Me">Me</option>
                        <option value="Miss">Miss</option>
                        <option value="Mr">Mr</option>
                        <option value="Mrs">Mrs</option>
                        <option value="Sen">Sen</option>
                    </select>
                </div>
            </div>
            <div class="form-group col-md-6">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12">Gender</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <select id="gender" name="gender">
                        <option selected="selected" value="">Choose Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                    </select>         
                </div>
            </div>
        </div>
        <div class="col-md-12 no-padding">
            <div class="form-group col-md-6">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12">Job Title</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" maxlength="255" id="jobTitle" name="jobTitle">
                </div>
            </div>
            <div class="form-group col-md-6">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12">Email</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" maxlength="255" id="email" name="email">
                </div>
            </div>
        </div>
        <div class="col-md-12 no-padding">
            <div class="form-group col-md-6">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12">Date Of Birth</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <input type="text" autocomplete="off" class="form-control datepicker" value="" title="YYYY-MM-DD" placeholder="YYYY-MM-DD" id="dateOfBirth" name="dateOfBirth">
                </div>
            </div>
            <div class="form-group col-md-6">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12">Mobile</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" maxlength="255" id="mobile" name="mobile">
                </div>
            </div>
        </div>
        <div class="col-md-12 no-padding">
            <div class="form-group col-md-6">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12">Phone</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" maxlength="255" id="phone" name="phone">
                </div>
            </div>

            <div class="form-group col-md-6">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12">Fax</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" maxlength="255" id="fax" name="fax">
                </div>
            </div>
        </div>
    </div>
    <div onclick="collapse('address_toggle', 'address_div');" id="address_toggle" class="col-md-12 f_head">
        <div class="col-md-3">
            <div class="col-md-2">
                <i class="glyphicon glyphicon-chevron-right">&nbsp;</i>
            </div>
            <div class="col-md-6">
                <h4>Address</h4>
            </div>
        </div>
    </div>
    <div class="clearfix">&nbsp;</div>
    <div id="address_div" class="col-md-12 no-padding hide">
        <div class="col-md-9 col-xs-12">
            <div class="form-group">
                <label class="control-label no-padding-right col-lg-2 col-md-1 col-sm-2 col-xs-12">Address1</label>
                <div class="col-md-9 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" maxlength="255" id="address1" name="address1">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label no-padding-right col-lg-2 col-md-1 col-sm-2 col-xs-12">Address2</label>
                <div class="col-md-9 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" maxlength="255" id="address2" name="address2">
                </div>
            </div>
        </div>
        <div class="col-md-12">
            <div class="form-group col-md-6 no-padding">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12">City</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" maxlength="255" id="city" name="city">
                </div>
            </div>
            <div class="form-group col-md-6 no-padding">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12">State</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" maxlength="255" id="state" name="state">
                </div>
            </div>

        </div>
        <div class="col-md-12">
            <div class="form-group col-md-6 no-padding">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12">Country</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <%@include file="countries-dropdown.jsp" %>
                </div>
            </div>
            <div class="form-group col-md-6 no-padding">
                <label class="control-label no-padding-right col-lg-3 col-sm-2 col-xs-12">Zip</label>
                <div class="col-lg-8 col-sm-7 col-xs-12">
                    <input type="text" class="form-control" value="" maxlength="32" id="zip" name="zip">
                </div>
            </div>
        </div>
    </div>
    <div class="col-md-12">
        <div class="col-md-1"></div>
        <div class="col-md-2">
            <input class="btn btn-info" onclick="contactBtn();" value="Save" type="button" />
        </div>
        <div class="col-md-1">
            <a href="contacts-list.jsp" class="pull-right btn btn-link">Back to list</a>
        </div>
    </div>
    <div class="clearfix">&nbsp;</div>
    <div class="col-md-12">
        <div class="col-md-1"></div>
        <div class="col-md-6">
            <div id="helpMsgContainer">
                <p class="help-block text-green hide" id="successMsg">Contact added successfully</p>
                <p class="help-block text-red" id="errorMsg"></p>
            </div>
        </div>
    </div>
</form>