<%-- 
    Document   : dashboard
    Created on : nov 15, 2017, 11:39:07 PM
    Author     : chajj--%>


<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.List"%>
<%@include file="header.jsp" %>

<% // load contacts list                    
    Database db = new Database();
    int bannedUsers = db.getTotalBannedUsers();
    int totalUsers = db.getTotalUsers();
    /*
     100% -> totalUsers
     x    <- bannedUsers
     x = (bannedUsers * 100) / totalUsers
     */
    int percentageBanned = ((int) bannedUsers * 100) / totalUsers;
    int percentageActive = 100 - percentageBanned;

    // load users per group
    List<String> users = new ArrayList<String>();
    users = db.getUsersListPerGroups();
    List<String> groupsList = new ArrayList<String>();
    List<String> usersList = new ArrayList<String>();
    String[] row;
    int j = 0;
    for (int i = 0; i < users.size(); i++) {
        String cell = (String) users.get(i);
        if (cell.startsWith("[")) {
            cell = cell.substring(1);
        }
        if (cell.endsWith("]")) {
            cell = cell.substring(0, cell.length() - 1);
        }
        row = cell.split(",");
        groupsList.add(row[0]);
        usersList.add(row[1]);
    }

%>

<div class="container master-container">
    <div class="row">
        <div class="col-md-12">
            <div class="col-md-5">
                <div class="panel panel-primary">
                    <div class="panel-heading">User Status Widget</div>
                    <div class="panel-body">
                        <div id="widget1" style="min-width: 310px; height: 400px; max-width: 600px; margin: 0 auto"></div>
                    </div>
                </div>
            </div>
            <div class="col-md-7">
                <div class="panel panel-primary">
                    <div class="panel-heading">User Groups Widget</div>
                    <div class="panel-body">
                        <table id="widget2">
                            <tr>
                                <td class="first"></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(function () {
        // widget #1
        var percActive = '<%= percentageActive%>' * 1;
        var percBanned = '<%= percentageBanned%>' * 1;
        $('#widget1').highcharts({
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: 'pie',
                width: '360'
            },
            title: {
                text: 'How many Banned / Active Users?'
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                        style: {
                            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        }
                    }
                }
            },
            series: [{
                    name: "Users",
                    colorByPoint: true,
                    data: [{
                            name: "Active",
                            y: percActive
                        }, {
                            name: "Banned",
                            y: percBanned,
                            sliced: true,
                            selected: true
                        }
                    ]
                }]
        });

        // widget #2
        var usersList = "<%= usersList%>";
        var groupsList = "<%= groupsList%>";
        var groupsListArr = [];
        var arr = groupsList.split(",");
        for (i in arr) {
            if (i == 0) {
                arr[0] = arr[0].substr(1);
            } else if (i == (arr.length - 1)) {
                arr[i] = arr[i].substr(0, arr[i].length - 1);
            }
            groupsListArr.push(arr[i]);
        }
        var usersListArr = [];
        var arr = usersList.split(",");
        for (i in arr) {
            arr[i] = arr[i].substr(2);
            if (i == (arr.length - 1)) {
                arr[i] = arr[i].substr(0, arr[i].length - 1);
            }
            usersListArr.push(arr[i]*1);
        }
        var charts = [],
                $containers = $('#widget2 td'),
                datasets = [{
                        name: 'User Groups / #users',
                        data: usersListArr
                    }
                ];


        $.each(datasets, function (i, dataset) {
            charts.push(new Highcharts.Chart({
                chart: {
                    renderTo: $containers[i],
                    type: 'bar',
                    marginLeft: i === 0 ? 100 : 10
                },
                title: {
                    text: dataset.name,
                    align: 'left',
                    x: i === 0 ? 90 : 0
                },
                credits: {
                    enabled: false
                },
                xAxis: {
                    categories: groupsListArr,
                    labels: {
                        enabled: i === 0
                    }
                },
                yAxis: {
                    allowDecimals: false,
                    title: {
                        text: null
                    },
                    min: 0,
                    max: 10
                },
                legend: {
                    enabled: false
                },
                series: [dataset]

            }));
        });
//        $('#highcharts-2').css("width", "500px");
    });
</script>