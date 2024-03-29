﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="WebRole1.Dashboard" %>


<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta charset="utf-8" />
    <script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.1.1.min.js"></script>
    <!--<link rel="stylesheet" type="text/css" href="StyleSheet1.css">-->
</head>

<body>
    <div id="top">
        <h1>Dashboard</h1>
        <h3>Only the clear button will restart all data</h3>
        <h3>You can only crawl CNN.com and BleacherReport.com</h3>
        <br />
        <br />

        <h2>Crawl Website</h2>
        <input id="crawl-input" type="text">
        <button id="crawl-submit">Submit</button>
        <p id="crawlMsg"></p>
        <ul id="crawl-ul"></ul>
        <p>Crawled Urls: <span id="crawlTitle"></span></p>
        <br />
        <br />

        
        <button id="start">Start</button>
        <button id="stop">Stop</button>
        <button id="clear">Clear</button>
        <button id="update">Update Stats</button>
        <br />
        <br />
        <br />

        <%--<h4>Search Title</h4>
        <input id="input" type="text">
        <button id="submit">Submit</button>
        <p>Title: <span id="searchTitle"></span></p>
        <br />--%>

        <p>State: <b><span id="state"></span></b></p>
        <p>Memory: <span id="mem"></span></p>
        <p>CPU Utilization: <span id="cpu"></span></p>
        <p>URLs Crawled: <span id="urls"></span></p>
        <p>Queue Size: <span id="queue"></span></p>
        <p>Table Size: <span id="table"></span></p>
        <p>Wiki # of Titles: <span id="wikiNum"></span></p>
        <p>Wiki Last Title: <span id="wikiLast"></span></p>
        
        <p>Last 10 URLs Crawled: <span id="ul-label"></span></p>
        <ul id="ul"></ul>

        <p>Last 10 Errors: <span id="errors-label"></span></p>
        <ul id="errors"></ul>
    </div>

    <script>
        $(document).ready(function () {
            showStats();

            $("#update").click(function () {
                console.log("update clicked");
                showStats();
            });

            $("#start").click(function () {
                console.log("start clicked");
                start();
            });

            $("#stop").click(function () {
                console.log("stop clicked");
                stop();
            });

            $("#clear").click(function () {
                console.log("clear clicked");
                clear();
            });

            $("#submit").click(function () {
                console.log("submit clicked");
                searchTitle();
            });

            $("#crawl-submit").click(function () {
                console.log("crawl-submit clicked");
                crawl();
            });

            function crawl() {
                var input = $('#crawl-input').val().trim();
                $("#crawl-input").val("");
                var url = "Admin.asmx/AddtoCrawler";
                $.ajax({
                    data: JSON.stringify({ input: input }),
                    dataType: "json",
                    url: url,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        //var obj = JSON.parse(result.d);
                        console.log(result.d);
                        if (result.d == "Duplicate") {
                            $("#crawlMsg").text("Already crawled");
                        } else if (result.d == "Can't") {
                            $("#crawlMsg").text("You can only crawl CNN.com and BleacherReport.com");
                        } else {
                            $("#crawlMsg").text("");
                            $("#crawlTitle").text(result.d);
                        }
                        //$("#crawl-ul").append($("<li>").text(input));
                    }
                })
            }

            //function searchTitle() {
            //    var input = $('#input').val().trim();
            //    //$("#input").val("");
            //    var url = "Admin.asmx/getTitle";
            //    $.ajax({
            //        data: JSON.stringify({ url: input }),
            //        dataType: "json",
            //        url: url,
            //        type: "POST",
            //        contentType: "application/json; charset=utf-8",
            //        success: function (result) {
            //            //console.log(result);
            //            $("#searchTitle").text(result.d);
            //        }
            //    })
            //}
        
            function showStats() {
                var url = "Admin.asmx/getStats";
                $.ajax({
                    data: JSON.stringify(),
                    dataType: "json", 
                    url: url,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        var obj = JSON.parse(result.d)[0];
                        //console.log(obj);
                        var obj2 = JSON.parse(result.d)[1];
                        //console.log(obj2)
                        $('#state').text(obj.state);
                        $('#mem').text(obj.MemCounter + "MB");
                        $('#cpu').text(obj.CPUCounter + "%");
                        $('#urls').text(obj.URLcounter);
                        $('#queue').text(obj.queueSize);
                        $('#table').text(obj.tableSize);
                        $('#wikiNum').text(obj2.wikiTitles);
                        $('#wikiLast').text(obj2.wikiLastTitle);

                        $("#ul").html("");
                        var lastTen = obj.lastTen;
                        if (lastTen == "") {
                            $("#ul-label").html("None");
                        } else {
                            var lastTenSub = lastTen.substring(0, lastTen.length - 2);
                            var lastTenArray = lastTenSub.split("; ");
                            $("#ul-label").html("");
                            lastTenArray.forEach(function (item) {
                                $("#ul").append($("<li>").text(item));
                            });
                        }
                        showErrors();
                    }
                });
            }

            function showErrors() {
                var url = "Admin.asmx/getErrors";
                $.ajax({
                    data: JSON.stringify(),
                    dataType: "json",
                    url: url,
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    success: function (result) {
                        //console.log(result);
                        var obj = JSON.parse(result.d);
                        //console.log(obj);
                        if (result.d == "Error occured") {
                            $("#errors-label").html("None");
                        }
                        else
                        {
                            $("#errors-label").html("");
                            $.each(obj, function () {
                                //console.log(this.url);
                                //console.log(this.message);
                                $("#errors-label").append($("<li>").text(this.message));
                            })
                        }
                    }, 
                }).fail(function (e) {
                    //console.log("error");
                    //console.log(e);
                });
            }

            function start() {
                var url = "Admin.asmx/StartCrawling";
                $.ajax({
                    url: url,
                    success: delay(function (result) {
                        showStats();
                    }, 1000)
                });
            }

            function stop() {
                var url = "Admin.asmx/StopCrawling";
                $.ajax({
                    url: url,
                    success: delay(function (result) {
                        showStats();
                    }, 1000)
                });
            }

            function clear() {
                var url = "Admin.asmx/ClearIndex";
                $.ajax({
                    url: url,
                    success: delay(function (result) {
                        showStats();
                    }, 1000)
                });
            }

            var delay = (function () {
                var timer = 0;
                return function (callback, ms) {
                    clearTimeout(timer);
                    timer = setTimeout(callback, ms);
                };
            })();
       });
    </script>
</body>
</html>
