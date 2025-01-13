<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="./common/api/WNSearch.jsp" %>
<% request.setCharacterEncoding("UTF-8");%>
<%@ page import ="java.net.InetAddress"%>
<%
    /*
     * subject: 검색 메인 페이지
     * @original author: SearchTool
     */
    String directCollection = request.getParameter("collection");

    //실시간 검색어 화면 출력 여부 체크
    boolean isRealTimeKeyword = false;
    //오타 후 추천 검색어 화면 출력 여부 체크
    boolean useSuggestedQuery = true;
    String suggestQuery = "";

    //디버깅 보기 설정
    boolean isDebug = false;

    int TOTALVIEWCOUNT = 3;    //통합검색시 출력건수


    String START_DATE = "1990.01.01";    // 기본 시작일

    // 결과 시작 넘버
    int startCount = parseInt(getCheckReqXSS(request, "startCount", "0"), 0);    //시작 번호
    String query = getCheckReqXSS(request, "query", "");                        //검색어
    String collection = getCheckReqXSS(request, "collection", "ALL");            //컬렉션이름
    String rt = getCheckReqXSS(request, "rt", "");                                //결과내 재검색 체크필드
    String rt2 = getCheckReqXSS(request, "rt2", "");                            //결과내 재검색 체크필드
    String reQuery = getCheckReqXSS(request, "reQuery", "");                    //결과내 재검색 체크필드
    String realQuery = getCheckReqXSS(request, "realQuery", "");                //결과내 검색어
    String sort = getCheckReqXSS(request, "sort", "RANK/DESC");                    //정렬필드
    String range = getCheckReqXSS(request, "range", "A");                        //기간관련필드
    String startDate = getCheckReqXSS(request, "startDate", START_DATE);        //시작날짜
    String endDate = getCheckReqXSS(request, "endDate", getCurrentDate());        //끝날짜
    String writer = getCheckReqXSS(request, "writer", "");                        //작성자
    String dept = getCheckReqXSS(request, "dept", "");                            //부서
    String searchField = getCheckReqXSS(request, "searchField", "");            //검색필드
    String detailField = getCheckReqXSS(request, "detailField", "N");            //상세검색 유무
    String AO1 = getCheckReqXSS(request, "AO1", "");
    String AO2 = getCheckReqXSS(request, "AO2", "");
    String AO3 = getCheckReqXSS(request, "AO3", "");
    String AOT1 = getCheckReqXSS(request, "AOT1", "");
    String AOT2 = getCheckReqXSS(request, "AOT2", "");
    String AOT3 = getCheckReqXSS(request, "AOT3", "");
    String strOperation = "";                                                //operation 조건 필드
    String exquery = "";                                                    //exquery 조건 필드
    String collectionQuery = "";
    String apprWriterCollectionQuery = "";
    String etcWriterCollectionQuery = "";

    String Pnum = getCheckReqXSS(request, "Pnum", "P1");
    int totalCount = 0;
    int COLLECTIONVIEWCOUNT = parseInt(getCheckReqXSS(request, "collectionviewcount", "10"), 10);   //더보기시 출력건수

    String K = getCheckReqXSS(request, "K", ""); //링크오픈시 필요한 키값
    String EMPCODE = getCheckReqXSS(request, "EMPCODE", ""); //사번
    String DEPTID = getCheckReqXSS(request, "DID", ""); //부서 코드
    String UID = getCheckReqXSS(request, "UID", ""); //부서 코드

    String[] searchFields = null;

    // 상세검색 검색 필드 설정이 되었을때
    if (!searchField.equals("")) {

    } else {
        searchField = "ALL";
    }

    // 상세검색 and or 체크
    if (!AOT1.equals("+")) {
        if (AO1.equals("AND")) {
            query = query + " " + AOT1;
        } else if (AO1.equals("OR")) {
            query = query + "|" + AOT1;
        }
    }

    if (!AOT2.equals("+")) {
        if (AO2.equals("AND")) {
            query = query + " " + AOT2;
        } else if (AO2.equals("OR")) {
            query = query + "|" + AOT2;
        }
    }

    if (!AOT3.equals("+")) {
        if (AO3.equals("AND")) {
            query = query + " " + AOT3;
        } else if (AO3.equals("OR")) {
            query = query + "|" + AOT3;
        }
    }

    String[] collections = null;
    if (collection.equals("ALL")) { //통합검색인 경우
        collections = COLLECTIONS;
    } else {                        //개별검색인 경우
        collections = new String[]{collection};
    }


    if (reQuery.equals("1")) {
        realQuery = query + " " + realQuery;
    } else if (!reQuery.equals("2")) {
        realQuery = query;
    }

    //테스트용
    int flag = 0;

    WNSearch wnsearch = new WNSearch(isDebug, false, collections, searchFields);

    int viewResultCount = COLLECTIONVIEWCOUNT;
    if (collection.equals("ALL") || collection.equals(""))
        viewResultCount = TOTALVIEWCOUNT;

    for (int i = 0; i < collections.length; i++) {
        exquery = "";

        wnsearch.setCollectionInfoValue(collections[i], PAGE_INFO, startCount + "," + viewResultCount);

        //검색어가 없으면 DATE_RANGE 로 전체 데이터 출력
        if (!query.equals("") && collections[i].equals("form")) {
            wnsearch.setCollectionInfoValue(collections[i], SORT_FIELD, sort);
        } else {
            wnsearch.setCollectionInfoValue(collections[i], DATE_RANGE, START_DATE.replaceAll("[.]", "/") + ",2030/12/31,-");
            wnsearch.setCollectionInfoValue(collections[i], SORT_FIELD, "RANK/DESC,DATE/DESC,DATE/ASC");
        }

        if (!sort.equals("")) {
            wnsearch.setCollectionInfoValue(collections[i], SORT_FIELD, sort);
        }

        //searchField 값이 있으면 설정, 없으면 기본검색필드
        if (!searchField.equals("") && searchField.indexOf("ALL") == -1) {
            wnsearch.setCollectionInfoValue(collections[i], SEARCH_FIELD, searchField);
        }

        //operation 설정
        if (!strOperation.equals("")) {
            wnsearch.setCollectionInfoValue(collections[i], FILTER_OPERATION, strOperation);
        }

        if (detailField.equals("Y")) {
            // 작성자
            if (collections[i].equals("appr")) {

                if (!writer.equals("+") && !writer.equals("none") && !writer.equals(" ") && !writer.equals("")) {
                    apprWriterCollectionQuery = "<USERNM:contains:" + writer + ">";
                }
            } else if (collections[i].equals("board")) {
                if (!writer.equals("+") && !writer.equals("none") && !writer.equals(" ") && !writer.equals("")) {
                    etcWriterCollectionQuery = "<POSTER_NAME:contains:" + writer + ">";
                }
            }

            collectionQuery = collections[i].equals("appr") ? apprWriterCollectionQuery : etcWriterCollectionQuery;
            //부서
            if (!dept.equals("+") && !dept.equals("none") && !dept.equals(" ") && !dept.equals("")) {
                if (collections[i].equals("appr")) {
                    collectionQuery += " <DEPT:contains:" + dept + ">";
                }
            }
        }

        //exquery 설정
        if (!exquery.equals("")) {
            wnsearch.setCollectionInfoValue(collections[i], EXQUERY_FIELD, exquery);
        }
        //collectionquery 설정
        if (!collectionQuery.equals("")) {
            wnsearch.setCollectionInfoValue(collections[i], COLLECTION_QUERY, collectionQuery);
        }

        //기간 설정 , 날짜가 모두 있을때
        if (!startDate.equals("") && !endDate.equals("") && !collections[i].equals("form")) {
            wnsearch.setCollectionInfoValue(collections[i], DATE_RANGE, startDate.replaceAll("[.]", "/") + "," + endDate.replaceAll("[.]", "/") + ",-");
        }
    }

    wnsearch.search(realQuery, isRealTimeKeyword, CONNECTION_CLOSE, useSuggestedQuery);

    // 디버그 메시지 출력
    String debugMsg = wnsearch.printDebug() != null ? wnsearch.printDebug().trim() : "";
    if (!debugMsg.trim().equals("")) {
        log.debug(debugMsg);
    }

    // 전체건수 구하기
    if (collection.equals("ALL")) {
        for (int i = 0; i < collections.length; i++) {
            totalCount += wnsearch.getResultTotalCount(collections[i]);
        }
    } else {
        //개별건수 구하기
        totalCount = wnsearch.getResultTotalCount(collection);
    }

    String thisCollection = "";
    if (useSuggestedQuery) {
        suggestQuery = wnsearch.suggestedQuery;
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>통합검색</title>
    <link rel="stylesheet" type="text/css" href="css/default.css">
    <link rel="stylesheet" type="text/css" href="css/search_sty.css">
    <link rel="stylesheet" type="text/css" href="css/jquery-ui.css">
    <link rel="stylesheet" type="text/css" href="ark/css/ark.css" media="screen">
    <script type="text/javascript" src="js/jquery.min.js"></script>
    <script type="text/javascript" src="js/jquery-ui.min.js"></script>
    <script type="text/javascript" src="ark/js/beta.fix.js"></script>
    <script type="text/javascript" src="ark/js/ark.js"></script>
    <script type="text/javascript" src="js/datepicker.js"></script>
    <script type="text/javascript" src="js/search.js"></script><!--  검색관련 js -->
    <script type="text/javascript">

        $(document).ready(function () {


            // 기간 달력 설정
            $("#startDate").datepicker({
                dateFormat: "yy.mm.dd",
                changeMonth: true,
                changeYear: true,
                showButtonPanel: true
            });
            $("#endDate").datepicker({
                dateFormat: "yy.mm.dd",
                changeMonth: true,
                changeYear: true,
                showButtonPanel: true
            });
            //Getter
            var changeMonth_start = $("#startDate").datepicker("option", "changeMonth");
            var changeYear_start = $("#startDate").datepicker("option", "changeYear");
            var showButtonPanel_start = $("#startDate").datepicker("option", "showButtonPanel");
            //Setter
            $("#startDate").datepicker("option", "changeMonth", true);
            $("#startDate").datepicker("option", "changeYear", true);
            $("#startDate").datepicker("option", "showButtonPanel", true);
            //Getter
            var changeMonth_end = $("#endDate").datepicker("option", "changeMonth");
            var changeYear_end = $("#endDate").datepicker("option", "changeYear");
            var showButtonPanel_end = $("#endDate").datepicker("option", "showButtonPanel");
            //Setter
            $("#endDate").datepicker("option", "changeMonth", true);
            $("#endDate").datepicker("option", "changeYear", true);
            $("#endDate").datepicker("option", "showButtonPanel", true);

            // 내가 찾은 검색어
            getMyKeyword("<%=query%>", <%=totalCount%>);

            $('.select_sch_box1 .btn_option').click(function () {
                var btnOp = $('.select_sch_box1 .ico_comm');
                if (btnOp.hasClass('is_active') === true) {
                    $('.select_sch_box1 .ico_comm').removeClass('is_active');
                    $('.select_sch_box1 .option_inner_box').css("display", "none");
                } else {
                    $('.select_sch_box1 .ico_comm').addClass('is_active');
                    $('.select_sch_box1 .option_inner_box').css("display", "block");
                }
            })

            $('#detail').click(function () {
                var dtlBtn = $('.layer_pop');
                if (dtlBtn.css('display') === 'none') {
                    $('.layer_pop').css("display", "block");
                } else {
                    $('.layer_pop').css("display", "none");
                }
            })
            $('#btnBlue').click(function () {

            })


            if ("<%=range%>" == "A") {
                $('#term01').attr('checked', true);
            } else if ("<%=range%>" == "D") {
                $('#term02').attr('checked', true);
            } else if ("<%=range%>" == "W") {
                $('#term03').attr('checked', true);
            } else if ("<%=range%>" == "M") {
                $('#term04').attr('checked', true);
            } else if ("<%=range%>" == "Y") {
                $('#term05').attr('checked', true);
            } else if ("<%=range%>" == "R") {
                $('#term06').attr('checked', true);
            }

            if ("<%=dept%>" != "") {
                $('#Dept').attr('value', "<%=dept%>");
            }

            if ("<%=writer%>" != "") {
                $('#Writer').attr('value', "<%=writer%>");
            }

            $("input[name='scFleid']").attr('checked', false);

            if ("<%=searchField%>" == "ALL") {
                $('#chk_terms1').attr('checked', true);
            } else if ("<%=searchField%>" == "TITLE") {
                $('#chk_terms2').attr('checked', true);
            } else if ("<%=searchField%>" == "CONTENTS") {
                $('#chk_terms3').attr('checked', true);
            } else if ("<%=searchField%>" == "FILE_CONTENTS") {
                $('#chk_terms4').attr('checked', true);
            }


            if ("<%=collection%>" == "ALL") {
                $('#mainselectpicker option:eq(0)').attr('selected', 'selected');
            } else if ("<%=collection%>" == "form") {
                $('#mainselectpicker option:eq(1)').attr('selected', 'selected');
            } else if ("<%=collection%>" == "appr") {
                $('#mainselectpicker option:eq(2)').attr('selected', 'selected');
            } else if ("<%=collection%>" == "bbs") {
                $('#mainselectpicker option:eq(3)').attr('selected', 'selected');
            }
			
			$("#mainselectpicker").val("<%=collection%>");
        });


        function openSanc(docid, empNo) {
            var gwurl = "https://gwdev.safety.or.kr";
            var empcode = empNo;
            var popWidth = 580;
            var popHeight = 330;
            var popupX = (window.screen.width / 2) - (popWidth / 2);
            var popupY = (window.screen.height / 2) - (popHeight / 2) - 100;
            var _options = "menubar=no, toolbar=no, location=no, status=no";

            console.log("opensanc == " + gwurl + "/qdb-linkage/DocViewer.do?docid=" + docid + "&empcode=" + empcode + "&type=sanc", "openSanc", "width=" + popWidth + ", height=" + popHeight + ", left=" + popupX + ", top=" + popupY + ", " + _options)

            window.open(gwurl + "/qdb-linkage/DocViewer.do?docid=" + docid + "&empcode=" + empcode + "&type=sanc", "openSanc", "width=" + popWidth + ", height=" + popHeight + ", left=" + popupX + ", top=" + popupY + ", " + _options);


            function newFunction() {
                return "openSancDev";
            }
        }

        function openBbs(headerid, K) {
            var gwurl = "https://gwdev.safety.or.kr";
            var popWidth = 1050;
            var popHeight = 725;
            var popupX = (window.screen.width / 2) - (popWidth / 2);
            var popupY = (window.screen.height / 2) - (popHeight / 2) - 50;
            var _options = "menubar=no, toolbar=no, location=no, status=no";

            console.log("openBbs == " + gwurl + "/servlet/HIServlet?SLET=bbs.BBSMtrlRead.java&BMID=" + headerid + "&K=" + K + "&MET=NOTIVIEW&BRDID=&IFN=1&flagCus=&LMET=NCLOSE&popup=true", "openBbs", "width=" + popWidth + ", height=" + popHeight + ", left=" + popupX + ", top=" + popupY + ", " + _options);
            window.open(gwurl + "/servlet/HIServlet?SLET=bbs.BBSMtrlRead.java&BMID=" + headerid + "&K=" + K + "&MET=NOTIVIEW&BRDID=&IFN=1&flagCus=&LMET=NCLOSE&popup=true", "openBbs", "width=" + popWidth + ", height=" + popHeight + ", left=" + popupX + ", top=" + popupY + ", " + _options);
        }

        //2023-05-23 hrpark 한글 서식은 한글 기안기로, html은 html 기안기로 열리게
        function openform(headerid, K, wordtype) {

            if (wordtype == 7) {		//html 서식
                var gwurl = "https://gwdev.safety.or.kr";
                var popWidth = 1050;
                var popHeight = 725;
                var popupX = (window.screen.width / 2) - (popWidth / 2);
                var popupY = (window.screen.height / 2) - (popHeight / 2) - 50;
                var _options = "menubar=no, toolbar=no, location=no, status=no";

                window.open(gwurl + "/bms/cz/cb/wrt/retrieveDoccrdWritng.act?FORMID=" + headerid + "&K=" + K + "&WORDTYPE=" + wordtype, "openform", "width=" + popWidth + ", height=" + popHeight + ", left=" + popupX + ", top=" + popupY + ", " + _options);
                //getMyDocument(gwurl+"/bms/cz/cb/wrt/retrieveDoccrdWritng.act?FORMID="+headerid+"&K="+K+"&WORDTYPE="+wordtype,'1');
            } else {
                doCallGian("", headerid, wordtype);
            }
        }

        function checkBrowser() {
            var agent = navigator.userAgent.toLowerCase(), name = navigator.appName, browser;

            browser = 'ie';
            if (name === 'Microsoft Internet Explorer'
                || agent.indexOf('trident') > -1 || agent.indexOf('edge/') > -1 || agent.indexOf('edg/') > -1) {
                browser = 'ie';
                if (name === 'Microsoft Internet Explorer') { // IE old version (IE 10 or Lower)
                    //agent = /msie ([0-9]{1,}[\.0-9]{0,})/.exec(agent);
                    //browser += parseInt(agent[1]);
                    browser = 'ie';
                } else { // IE 11+
                    if (agent.indexOf('trident') > -1) { // IE 11
                        //browser += 11;
                        browser = 'ie';
                    } else if (agent.indexOf('edge/') > -1) { // Edge
                        browser = 'edge';
                    } else if (agent.indexOf('edg/') > -1) { // Edge
                        browser = 'edge';
                    }
                }
            } else if (agent.indexOf('safari') > -1) { // Chrome or Safari
                if (agent.indexOf('opr') > -1) { // Opera
                    browser = 'opera';
                } else if (agent.indexOf('chrome') > -1) { // Chrome
                    browser = 'chrome';
                } else { // Safari
                    browser = 'safari';
                }
            } else if (agent.indexOf('firefox') > -1) { // Firefox
                browser = 'firefox';
            }
            return browser;
        }

        function doCallGian(formname, formid, wordType) {
            var url = "/bms/com/hs/gwweb/appr/hstCmd.act";
            var param = {
                USERID: "<%=UID%>",
                K: "<%=K%>",
                FORMNAME: "",
                WEBIP: this.location.protocol + '//' + this.location.host,
                FORMID: formid,
                WORDTYPE: wordType,
                USERAGENT: checkBrowser() // HSO-8427
            };

            $.ajax({
                type: "post",
                dataType: "json",
                url: url,
                data: param,
                async: false,
                success: function (obj) {
                    if (obj && obj.ok) {
                        if (obj.clientURL) {
                            if (window.console) {
                                console.log('clientURL=' + obj.clientURL);
                            }
                            loadToIFrame(obj.clientURL);
                        }
                    } else {
                        alert(obj.message);
                    }
                },
                error: function (xhr, status, error) {
                    alert(error);
                }
            });
        }

        function loadToIFrame(url) {

            var iframe = document.getElementById("hiddenClientloader");
            if (iframe == null) {
                iframe = document.createElement('iframe');
                iframe.id = "hiddenClientloader";
                iframe.name = "hiddenClientloader";
                iframe.style.visibility = 'hidden';
                iframe.width = '0';
                iframe.height = '0';
                iframe.src = "about:blank"
                document.body.appendChild(iframe);
            }
            iframe.src = url;
        }

    </script>

</head>
<body>
<div class="wrapper">
    <form name="search" id="search" action="<%=request.getRequestURI()%>" method="POST">
        <input type="hidden" name="startCount" value="0">
        <input type="hidden" name="sort" value="<%=sort%>">
        <input type="hidden" name="collection" value="<%=collection%>">
        <input type="hidden" name="range" value="<%=range%>">
        <input type="hidden" name="startDate" value="<%=startDate%>">
        <input type="hidden" name="endDate" value="<%=endDate%>">
        <input type="hidden" name="searchField" value="<%=searchField%>">
        <input type="hidden" name="reQuery"/>
        <input type="hidden" name="realQuery" value="<%=realQuery%>"/>
        <input type="hidden" name="collectionviewcount" value="10"/>
        <input type="hidden" name="writer" value="<%=writer%>"/>
        <input type="hidden" name="dept" value="<%=dept%>"/>
        <input type="hidden" name="detailField" value="N"/>
        <input type="hidden" name="AO1" value=" "/> <!-- and or 1 항목 여부-->
        <input type="hidden" name="AO2" value=" "/> <!-- and or 2 항목 여부-->
        <input type="hidden" name="AO3" value=" "/> <!-- and or 3 항목 여부-->
        <input type="hidden" name="AOT1" value=" "/> <!-- and or text 1 -->
        <input type="hidden" name="AOT2" value=" "/> <!-- and or text 2 -->
        <input type="hidden" name="AOT3" value=" "/> <!-- and or text 3 -->
        <input type="hidden" name="tabVal" value="tab-ALL"/> <!-- and or text 3 -->
        <input type="hidden" name="K" value="<%=K%>"/>
        <input type="hidden" name="EMPCODE" value="<%=EMPCODE%>"/>
        <input type="hidden" name="DID" value="<%=DEPTID%>"/>
        <input type="hidden" name="UID" value="<%=UID%>"/>
        <input type="hidden" name="Pnum" value="<%=Pnum%>"/>

        <div class="header_wrap">
            <div class="header">
                <div class="top">
                    <ul>
                        <!--<li class="logo"><a href="./search_page.jsp"><img src="images/logo.png" alt="아주대학교의료원" style="visibility:hidden;"/></a></li>-->
                        <li class="logo"><a href="#"><img src="images/logo.png" alt="대한산업안전협회"/></a></li>
                    </ul>
                    <!-- ARK search suggest -->
                </div>
                <!-- sch_wrap -->
                <div class="sch_wrap">
                    <div class="sch_word_wrap">
                        <!-- 셀렉트 박스 -->
                        <div class="select_sch_box1">
                            <select class="mainselectpicker" id="mainselectpicker" onchange="">
                                <option value="ALL">전체</option>
                                <option value="appr">전자결재</option>
                                <option value="board">게시판</option>
\                            </select>
                        </div>
                        <!-- //셀렉트 박스 -->
                        <div class="sch_box">
                            <input name="query" id="query" type="text" value="<%=query%>"
                                   onKeypress="javascript:pressCheck((event),this);" autocomplete="off"/>
                            <!-- 자동완성 열고 닫기 -->
                            <a href="#" class="sch_btn" onClick="setArkOn();"><span class="ico_comm">자동완성 열기</span></a>
                            <!-- [D] 클릭 시 is_active 클래스 추가 -->
                            <!-- //자동완성 열고 닫기 -->
                        </div>
                        <div id="ark"></div>
                    </div>

                    <div class="sch_opt">
                        <a href="#" class="btn gray" onClick="javascript:doSearch();">
                            <span>검색</span>
                        </a>
                        <!-- 상세검색 : 버튼 클릭시, active 클래스 사용 -->
                        <a href="#" class="btn blue" id="detail">
                            <span>상세검색</span>
                        </a>
                        <!--// 상세검색 -->
                        <!-- 체크박스  -->
                        <div class="chk_box_group">
                            <div class="chk_box">
                                <input type="checkbox" class="inp_chk2" name="reChk" id="reChk"
                                       onClick="checkReSearch();"
                                       style="clip:unset;position:unset;width: 20px;height: 15.86px;">
                                <label for="total" class="sc_name">
                                    <span class="txt_box">결과 내 재검색</span>
                                </label>
                            </div>
                            <!--<div class="chk_box">
                                <input name="reChk" id="reChk" class="inp_chk" onClick="checkReSearch();" type="checkbox" />
                                <label for="total" class="sc_name">
                                    <span class="chk_img"></span>
                                    <span class="txt_box">결과 내 재검색</span>
                                </label>
                            </div>-->
                        </div>
                        <!--// 체크박스 -->
                    </div>

                    <!--//자동완성 -->
                </div>
            </div>
        </div>
    </form>
    <!--div id="search_auto">
        <div class="auto">
            <div id="ark_wrap">
                <div id="ark_up"><img id="ark_img_up"></div>
                <div id="ark_down"><img id="ark_img_down"></div>
                <div id="ark_sub_wrap"/></div>
            <div>
        </div>
    </div-->
    <!-- content_wrap -->
    <div class="content_wrap">
        <!-- container -->
        <div class="container">
            <!-- 검색옵션 -->
            <div class="layer_pop">

                <div class="inp_txt_box">
                    <strong class="inp_tit">검색어</strong>
                    <div class="cont_btn_group">
                        <!-- 셀렉트 박스 -->
                        <div class="select_sch_box">
                            <select class="selectpicker1" id="andor1" onchange="">
                                <option value="AND" selected="selected">AND</option>
                                <option value="OR">OR</option>
                            </select>
                        </div>
                        <!-- //셀렉트 박스 -->
                        <input type="text" class="inp_txt" id="andortxt1" title="검색어 입력">
                    </div>

                    <div class="cont_btn_group">
                        <!-- 셀렉트 박스 -->
                        <div class="select_sch_box">
                            <select class="selectpicker1" id="andor2" onchange="">
                                <option value="AND" selected="selected">AND</option>
                                <option value="OR">OR</option>
                            </select>
                        </div>
                        <!-- //셀렉트 박스 -->
                        <input type="text" class="inp_txt" id="andortxt2" title="검색어 입력">
                    </div>

                    <div class="cont_btn_group">
                        <!-- 셀렉트 박스 -->
                        <div class="select_sch_box">
                            <select class="selectpicker1" id="andor3" onchange="">
                                <option value="AND" selected="selected">AND</option>
                                <option value="OR">OR</option>
                            </select>
                        </div>
                        <!-- //셀렉트 박스 -->
                        <input type="text" class="inp_txt" id="andortxt3" title="검색어 입력">
                    </div>

                </div>

                <div class="inp_txt_box">
                    <strong class="inp_tit">부서</strong>
                    <div class="cont_btn_group">
                        <input type="text" class="inp_txt" id="Dept" title="검색어 입력">
                    </div>

                    <strong class="inp_tit" style="margin-top: 26px;">작성자</strong>
                    <div class="cont_btn_group">
                        <input type="text" class="inp_txt" id="Writer" title="검색어 입력">
                    </div>
                </div>

                <div class="inp_txt_box">
                    <strong class="inp_tit">검색기간</strong>
                    <div class="cont_btn_group terms">
                        <div class="terms_area">
                            <input type="radio" class="inp_radio" id="term01" name="terms1" value="1" checked="">
                            <label for="term01" class="inp_name">전체</label>
                            <input type="radio" class="inp_radio" id="term02" name="terms1" value="2">
                            <label for="term02" class="inp_name">1일</label>
                            <input type="radio" class="inp_radio" id="term03" name="terms1" value="3">
                            <label for="term03" class="inp_name">1주일</label>
                            <input type="radio" class="inp_radio" id="term04" name="terms1" value="4">
                            <label for="term04" class="inp_name">1개월</label>
                            <input type="radio" class="inp_radio" id="term05" name="terms1" value="5">
                            <label for="term05" class="inp_name">1년</label>
                        </div>
                        <div class="terms_area">
                            <input type="radio" class="inp_radio" id="term06" name="terms1" value="6">
                            <label for="term06" class="inp_name direct">직접선택</label>
                            <span class="inp_area calendar">
								<div class="inp_calendar">
									<input name="startDate" id="startDate" class="inp_txt" type="text"
                                           value="<%=startDate%>" title="시작일 선택" readonly="true"/>
									<a href="#" class="btn_calendar"><span class="ico_comm ico_calendar"></span></a>
								</div>
								<div class="inp_calendar">
									<input name="endDate" id="endDate" class="inp_txt" type="text" title="종료일 선택"
                                           value="<%=endDate%>" readonly="true"/>
									<a href="#" class="btn_calendar"><span class="ico_comm ico_calendar"></span></a>
								</div>
								<input type="hidden" name="range" id="range" value="<%=range%>">
							</span>
                        </div>
                    </div>
                </div>


                <div class="inp_txt_box">
                    <strong class="inp_tit">검색영역</strong>
                    <div class="cont_btn_group terms">
                        <div class="terms_area">
                            <input type="checkbox" name="scFleid" class="inp_chk" id="chk_terms1" checked=""
                                   onclick='checkOnlyOne(this)'>
                            <label for="chk_terms1" class="sc_name">
                                <span class="chk_img terms"></span>
                                <span class="txt_box">전체</span>
                            </label>
                            <input type="checkbox" name="scFleid" class="inp_chk" id="chk_terms2"
                                   onclick='checkOnlyOne(this)'>
                            <label for="chk_terms2" class="sc_name">
                                <span class="chk_img terms"></span>
                                <span class="txt_box">제목</span>
                            </label>
                            <input type="checkbox" name="scFleid" class="inp_chk" id="chk_terms3"
                                   onclick='checkOnlyOne(this)'>
                            <label for="chk_terms3" class="sc_name">
                                <span class="chk_img terms"></span>
                                <span class="txt_box">내용</span>
                            </label>
                            <input type="checkbox" name="scFleid" class="inp_chk" id="chk_terms4"
                                   onclick='checkOnlyOne(this)'>
                            <label for="chk_terms4" class="sc_name">
                                <span class="chk_img terms"></span>
                                <span class="txt_box">첨부파일</span>
                            </label>
                        </div>
                    </div>
                </div>

                <div class="layer_bottom">
                    <button type="button" class="btn blue" onclick="detailReset();">초기화</button>
                    <button type="button" class="btn gray" onclick="detailSearch();">적용</button>
                </div>
            </div>

            <% if (collection.equals("ALL")) { %>
                <p class="result_txt">
                    <span class="point">‘<%=query%>’</span>에 대한 통합 검색결과는 <span class="point">총 <%=numberFormat(totalCount)%> 건</span> 입니다.</p>
            <% } else { %>
                <p class="result_txt">
                    <span class="point">‘<%=query%>’</span>에 대한 <%=wnsearch.getCollectionKorName(collection)%> 검색결과는 <span class="point">총 <%=numberFormat(totalCount)%> 건</span> 입니다.</p>
            <% } %>

            <!-- tab_menu_wrap -->
            <div class="tab_menu_wrap" id="tabWrap">
                <!-- tab_menu_list -->
                <ul class="tab_menu_list">
                    <% if (collection.equals("ALL")) { %>
                        <li class="tab_menu_item active" id="tab-ALL">
                            <a href="#none" class="tab_menu_link" onClick="javascript:doCollection('ALL');">전체</a>
                        </li>
                    <% } else { %>
                        <li class="tab_menu_item" id="tab-ALL">
                            <a href="#none" class="tab_menu_link" onClick="javascript:doCollection('ALL');">전체</a>
                        </li>
                    <% } %>
                    
                    <% for (int i = 0; i < COLLECTIONS.length; i++) { %>
                        <% if (collection.equals(COLLECTIONS[i])) { %>
                            <li class="tab_menu_item active" id="tab-<%=COLLECTIONS[i]%>">
                                <a href="#none" class="tab_menu_link" onClick="javascript:doCollection('<%=COLLECTIONS[i]%>');"><%=wnsearch.getCollectionKorName(COLLECTIONS[i])%></a>
                            </li>
                        <% } else { %>
                            <li class="tab_menu_item" id="tab-<%=COLLECTIONS[i]%>">
                                <a href="#none" class="tab_menu_link" onClick="javascript:doCollection('<%=COLLECTIONS[i]%>');"><%=wnsearch.getCollectionKorName(COLLECTIONS[i])%></a>
                            </li>
                        <% } %>
                    <% } %>
                </ul>
                <!--// tab_menu_list -->
            </div>

            <div class="cont_box">
                <% if (totalCount > 0) { %>
                    <!-- 전체 -->
                    <%-- <div id="cont_box-1" class="tab_cont active">
                        <div class="tab_cont_box">
                            <% if (totalCount > 0) { } %>
                        </div>
                    </div> --%>

                    <!-- 전자결재양식 -->
                    <%-- <% if (collection.equals("ALL")) { %>
                        <div id="cont_box-3-line" class="tab_cont">
                            <div class="tab_cont_box">
                                <%@ include file="./result/result_appr.jsp" %>
                            </div>
                        </div>
                    <% } else { %>
                        <div id="cont_box-3" class="tab_cont">
                            <div class="tab_cont_box">
                                <%@ include file="./result/result_appr.jsp" %>
                            </div>
                        </div>
                    <% } %> --%>

                    <!-- 전자결재 -->
                    <div id="cont_box-1" class="tab_cont">
                        <div class="tab_cont_box">
                            <%@ include file="result/result_appr.jsp" %>
                        </div>
                    </div>

                    <!-- 게시판 -->
                    <div id="cont_box-2" class="tab_cont">
                        <div class="tab_cont_box">
                            <%@ include file="result/result_board.jsp" %>
                        </div>
                    </div>

                <% } else { %>
                    <div id="cont_box_noresult" class="tab_cont active">
                        <div class="tab_cont_box">
                            <div id="spell">
                                <script>getSpell('<%=suggestQuery%>');</script>
                            </div>
                            <div class="no_result">
                                <p class="result_tit">입력하신 검색어와 일치하는 정보를 찾지 못했습니다.</p>
                                <ul class="result_list">
                                    <li>입력하신 검색어의 철자가 정확한지 확인해 보세요.</li>
                                    <li>검색어의 단어 수를 줄이거나, 보다 일반적인 단어로 검색해 보세요.</li>
                                    <li>두 단어 이상의 검색어인 경우, 정확하게 띄어쓰기를 하셨는지 확인해 보세요.</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>
<script>
    $(document).ready(function () {

        //$('ul.tab_menu_list li').click(function() {
        //	var tab_id = $(this).attr('data-tab');
        //	$('ul.tab_menu_list li').removeClass('active');
        //	$('.tab_cont').removeClass('active');
        //	$(this).addClass('active');
        //	$("#" + tab_id).addClass('active');
        //})

        //var resultcnt = $('input[name=collectionviewcount]').val();
        //if(resultcnt == '10'){
        //    $('#10').attr('selected','selected');
        //} else if(resultcnt == '20'){
        //    $('#20').attr('selected','selected');
        //}
    });
</script>
</body>
</html>
<%
    if (wnsearch != null) {
        wnsearch.closeServer();
    }
%>
