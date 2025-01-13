// 인기검색어, 내가찾은 검색어
function doKeyword(query) {
	var searchForm = document.search; 
	searchForm.startCount.value = "0";
	searchForm.query.value = query;
	searchForm.collection.value = "ALL";
	searchForm.sort.value = "RANK/DESC";
	searchForm.query.value = query;
	doSearch();
}

// 쿠키값 조회
function getCookie(c_name) {
	var i,x,y,cookies=document.cookie.split(";");
	for (i=0;i<cookies.length;i++) {
		x=cookies[i].substr(0,cookies[i].indexOf("="));
		y=cookies[i].substr(cookies[i].indexOf("=")+1);
		x=x.replace(/^\s+|\s+$/g,"");
	
		if (x==c_name) {
			return unescape(y);
		}
	}
}

// 쿠키값 설정
function setCookie(c_name,value,exdays) {
	var exdate=new Date();
	exdate.setDate(exdate.getDate() + exdays);
	var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
	document.cookie=c_name + "=" + c_value;
}

// 내가 찾은 검색어 조회
function getMyKeyword(keyword, totCount) {
	var MYKEYWORD_COUNT = 6; //내가 찾은 검색어 갯수 + 1
	var myKeyword = getCookie("mykeyword");
	if( myKeyword== null) {
		myKeyword = "";
	}

	var myKeywords = myKeyword.split("^%");

	if( totCount > 0 ) {
		var existsKeyword = false;
		for( var i = 0; i < myKeywords.length; i++) {
			if( myKeywords[i] == keyword) {
				existsKeyword = true;
				break;
			}
		}

		if( !existsKeyword ) {
			myKeywords.push(keyword);
			if( myKeywords.length == MYKEYWORD_COUNT) {
				myKeywords = myKeywords.slice(1,MYKEYWORD_COUNT);
			}
		}
		setCookie("mykeyword", myKeywords.join("^%"), 365);
	}

	showMyKeyword(myKeywords.reverse());
}


// 내가 찾은 검색어 삭제
function removeMyKeyword(keyword) {
	var myKeyword = getCookie("mykeyword");
	if( myKeyword == null) {
		myKeyword = "";
	}

	var myKeywords = myKeyword.split("^%");

	var i = 0;
	while (i < myKeywords.length) {
		if (myKeywords[i] == keyword) {
			myKeywords.splice(i, 1);
		} else { 
			i++; 
		}
	}

	setCookie("mykeyword", myKeywords.join("^%"), 365);

	showMyKeyword(myKeywords);
}
 
// 내가 찾은 검색어 
function showMyKeyword(myKeywords) {
	var str = "<li class=\"tit\"><img src=\"images/tit_mykeyword.gif\" alt=\"내가 찾은 검색어\" /></li>";

	for( var i = 0; i < myKeywords.length; i++) {
		if( myKeywords[i] == "") continue;

		str += "<li class=\"searchkey\"><a href=\"#none\" onClick=\"javascript:doKeyword('"+myKeywords[i]+"');\">"+myKeywords[i]+"</a> <img src=\"images/ico_del.gif\" onClick=\"removeMyKeyword('"+myKeywords[i]+"');\"/></li>";
	}

	$("#mykeyword").html(str);
}

// 오타 조회
function getSpell(query) { 
	$.ajax({
	  type: "POST",
	  url: "./popword/popword.jsp?target=spell&charset=",
	  dataType: "xml",
	  data: {"query" : query},
	  success: function(xml) {
		if(parseInt($(xml).find("Return").text()) > 0) {
			var str = "<div class=\"resultall\">";

			$(xml).find("Data").each(function(){			
				if ($(xml).find("Word").text() != "0" && $(xml).find("Word").text() != query) {
					str += "<span>이것을 찾으셨나요? </span><a href=\"#none\" onClick=\"javascript:doKeyword('"+$(xml).find("Word").text()+"');\">" + $(xml).find("Word").text() + "</a>";
				}			
			});
			
			str += "</div>";

			$("#spell").html(str);
		}
	  }
	});

	return true;
}

// 기간 설정
function setDate(range) {
	var searchForm = document.search;
	var startDate = "";
	var endDate = "";
	
	var currentDate = new Date();
	var year = currentDate.getFullYear();
	var month = currentDate.getMonth() +1;
	var day = currentDate.getDate();

	if (parseInt(month) < 10) {
		month = "0" + month;
	}

	if (parseInt(day) < 10) {
		day = "0" + day;
	}

	var toDate = year + "." + month + "." + day;
	
	// 기간 버튼 이미지 선택
	if (range == "D") {
		startDate = getAddDay(currentDate, -0);
	} else if (range == "W") {
		startDate = getAddDay(currentDate, -6);
	} else if (range == "M") {
		startDate = getAddDay(currentDate, -29);
	} else if (range == "Y") {
		startDate = getAddDay(currentDate, -364);
	} else {
		startDate = "1970.01.01";
		endDate = toDate;
		$("#range1").attr ("src", "images/btn_term12.gif");
	}
	
	if (range != "A" && startDate != "") { 
		year = startDate.getFullYear();
		month = startDate.getMonth()+1; 
		day = startDate.getDate();

		if (parseInt(month) < 10) {
			month = "0" + month;
		}

		if (parseInt(day) < 10) {
			day = "0" + day;
		}

		startDate = year + "." + month + "." + day;				
		endDate = toDate;
	}
	
	searchForm.startDate.value = startDate;
	searchForm.endDate.value = endDate;
	
	$("#range").val(range);
	$("#startDate").val(startDate);
	$("#endDate").val(endDate);
}

// 날짜 계산
function getAddDay ( targetDate, dayPrefix )
{
	var newDate = new Date( );
	var processTime = targetDate.getTime ( ) + ( parseInt ( dayPrefix ) * 24 * 60 * 60 * 1000 );
	newDate.setTime ( processTime );
	return newDate;
}

// 정렬
function doSorting(sort) {
	var searchForm = document.search;
	searchForm.sort.value = sort;
	searchForm.reQuery.value = "2";
	var tabInfo = searchForm.collection.value;
	searchForm.tabVal.value = "tab-"+tabInfo;
	console.log(sort);
	searchForm.submit();
}

// 검색
function doSearch() {
	var searchForm = document.search;
	if (searchForm.query.value == "") {
		alert("검색어를 입력하세요.");
		searchForm.query.focus();
		$('#mainselectpicker option:eq(0)').attr('selected','selected');
		return;
	}
	var coll = $("#mainselectpicker option:selected").val();
	//searchForm.collection.value = "ALL";
	searchForm.collection.value = $("#mainselectpicker option:selected").val();
	searchForm.tabVal.value ="tab-"+coll;
	searchForm.Pnum.value = "P1";
	
	searchForm.startDate.value = "";
	searchForm.endDate.value = "";
	searchForm.range.value = "A";
	searchForm.startCount.value = 0;
	searchForm.searchField.value = "ALL";
	searchForm.sort.value = "RANK/DESC";
	searchForm.submit();
}

// 상세 검색
function detailSearch() {
	var searchForm = document.search;
	searchForm.detailField.value = "Y";
	searchForm.writer.value = $('#Writer').val();
	searchForm.dept.value = $('#Dept').val();
	
	//검색 기간 설정 체크
	if($('#term01').is(':checked') == true){
		searchForm.range.value = "A";
		setDate('A');
	}else if($('#term02').is(':checked') == true){
		searchForm.range.value = "D";
		setDate('D');
	}
	else if($('#term03').is(':checked') == true){
		searchForm.range.value = "W";
		setDate('W');
	}
	else if($('#term04').is(':checked') == true){
		searchForm.range.value = "M";
		setDate('M');
	}
	else if($('#term05').is(':checked') == true){
		searchForm.range.value = "Y";
		setDate('Y');
	}
	else if($('#term06').is(':checked') == true){
		doRange();
	}
	
	//검색 영역 설정 체크
	if($('#chk_terms1').is(':checked') == true){
		searchForm.searchField.value = "ALL";
	}else if($('#chk_terms2').is(':checked') == true){
		searchForm.searchField.value = "TITLE";
	}
	else if($('#chk_terms3').is(':checked') == true){
		searchForm.searchField.value = "CONTENTS";
	}
	else if($('#chk_terms4').is(':checked') == true){
		searchForm.searchField.value = "FILE_CONTENTS";
	}
	
	//검색 AND/OR 조건 검색 설정
	if($('#andortxt1').val() != ""){
		searchForm.AOT1.value = $('#andortxt1').val();
		if($("#andor1 option:selected").val() == "AND"){
			searchForm.AO1.value = "AND";
		}else if($("#andor1 option:selected").val() == "OR"){
			searchForm.AO1.value = "OR";
		}
	}
	if($('#andortxt2').val() != ""){
		searchForm.AOT2.value = $('#andortxt2').val();
		if($("#andor2 option:selected").val() == "AND"){
			searchForm.AO2.value = "AND";
		}else if($("#andor2 option:selected").val() == "OR"){
			searchForm.AO2.value = "OR";
		}
	}
	if($('#andortxt3').val() != ""){
		searchForm.AOT3.value = $('#andortxt3').val();
		if($("#andor3 option:selected").val() == "AND"){
			searchForm.AO3.value = "AND";
		}else if($("#andor3 option:selected").val() == "OR"){
			searchForm.AO3.value = "OR";
		}
	}
	
	// if (searchForm.query.value == "") {
	// 	alert("검색어를 입력하세요.");
	// 	searchForm.query.focus();
	// 	return;
	// }
	
	searchForm.collection.value = $("#mainselectpicker option:selected").val();
	searchForm.startCount.value = 0;
	
	//console.log("serialize detailsearch" + $('#search').serialize());
	
	searchForm.submit();
	
}

function detailReset(){
	//$("#search")[0].reset();
	$('#andor1 option:eq(0)').attr('selected','selected');
	$('#andor2 option:eq(0)').attr('selected','selected');
	$('#andor3 option:eq(0)').attr('selected','selected');
	
	$('#andortxt1').attr('value',"");
	$('#andortxt2').attr('value',"");
	$('#andortxt3').attr('value',"");
	
	$('#term01').attr('checked',true);
	
	$('#Dept').attr('value',"");
	$('#Writer').attr('value',"");
	
	$("input[name='scFleid']").attr('checked',false);
	
	$('#chk_terms1').attr('checked',true);
}

//검색 결과 갯수
function resultCnt(cnt) {
	var searchForm = document.search; 
	
	searchForm.collectionviewcount.value = cnt;
	console.log("searchForm.collectionviewcount.value" + searchForm.collectionviewcount.value);
	console.log("serialize" + $('#search').serialize());
	
	searchForm.submit();

    searchForm.collectionviewcount.value = cnt;
}

function resultCnt2(cnt) {
	var searchForm = document.search; 
	
	searchForm.collectionviewcount.value = cnt;
	console.log("searchForm.collectionviewcount.value" + searchForm.collectionviewcount.value);
	console.log("serialize" + $('#search').serialize());
	
	var tabInfo = searchForm.collection.value;
	searchForm.tabVal.value = "tab-"+tabInfo;
	
	searchForm.submit();
	
	searchForm.collectionviewcount.value = cnt;
}

// 컬렉션별 검색
function doCollection(coll) {
	var searchForm = document.search;
	var k = searchForm.K.value;
	var empcode = searchForm.EMPCODE.value;
	var deptid = searchForm.DID.value;
	//var divisioncode = searchForm.DIVISIONCODE.value;
	var uid = searchForm.UID.value;
	
	searchForm.collection.value = coll;
	searchForm.reQuery.value = "2";
	if(coll == "ALL"){
		searchForm.tabVal.value ="tab-ALL";
	}else{
		searchForm.tabVal.value ="tab-"+coll;
	}
	searchForm.K.value = k;
	searchForm.EMPCODE.value = empcode;
	searchForm.DID.value = deptid;
	//searchForm.DIVISIONCODE.value = divisioncode;
	searchForm.UID.value = uid;
	searchForm.Pnum.value = "P1";
	searchForm.submit();
}
	
// 엔터 체크	
function pressCheck() {   
	if (event.keyCode == 13) {
		return doSearch();
	}else{
		return false;
	}
}



// 결과내 재검색
function checkReSearch() {
	var searchForm = document.search;
	var query = searchForm.query;
	var reQuery = searchForm.reQuery;
	var temp_query = "";

	if (document.getElementById("reChk").checked == true) {
		temp_query = query.value;
		reQuery.value = "1";
		query.value = "";
		query.focus();
	} else {
		query.value = trim(temp_query);
		reQuery.value = "";
		temp_query = "";
	}
}

// 페이징
function doPaging(count,page) {
	
	var searchForm = document.search;
	var tabInfo = searchForm.collection.value;
	searchForm.tabVal.value = "tab-"+tabInfo;
	//console.log("searchForm.Pnum.value1 : " + searchForm.Pnum.value);
	searchForm.Pnum.value = "P"+page;
	//console.log("searchForm.Pnum.value2 : " + searchForm.Pnum.value);
	searchForm.startCount.value = count;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 기간 적용
function doRange() {
	var searchForm = document.search;
	
	if($("#startDate").val() != "" || $("#endDate").val() != "") {
		if($("#startDate").val() == "") {
			alert("시작일을 입력하세요.");
			$("#startDate").focus();
			return;
		}

		if($("#endDate").val() == "") {
			alert("종료일을 입력하세요.");
			$("#endDate").focus();
			return;
		}

		if(!compareStringNum($("#startDate").val(), $("#endDate").val(), ".")) {
			alert("기간이 올바르지 않습니다. 시작일이 종료일보다 작거나 같도록 하세요.");
			$("#startDate").focus();
			return;
		}		
	}

	searchForm.startDate.value = $("#startDate").val();
	searchForm.endDate.value = $("#endDate").val();
	searchForm.range.value = "R";
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 영역
function doSearchField(field) {
	var searchForm = document.search;
	searchForm.searchField.value = field;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 문자열 숫자 비교
function compareStringNum(str1, str2, repStr) {
	var num1 =  parseInt(replaceAll(str1, repStr, ""));
	var num2 = parseInt(replaceAll(str2, repStr, ""));

	if (num1 > num2) {
		return false;
	} else {
		return true;
	}
}

// Replace All
function replaceAll(str, orgStr, repStr) {
	return str.split(orgStr).join(repStr);
}

// 공백 제거
function trim(str) {
	return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}

function checkOnlyOne(element) {
  
  const checkboxes = document.getElementsByName("scFleid");
  
  checkboxes.forEach((cb) => {
    cb.checked = false;
  })
  
  element.checked = true;
}

