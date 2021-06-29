<%@ page language="java" contentType="text/html; charset=EUC-KR"
         pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>조회</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

    <!-- Custom styles for this template -->
    <link href="css/map.css" rel="stylesheet">

    <!--jquery-->
    <script scr="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

    <script>
        let dataList = []; // ajax로 처리한 결과 데이터를 담는 배열
        let totalData; //총 데이터 수
        let totalPage;
        let dataPerPage; //한 페이지에 나타낼 데이터 수
        let pageCount = 10; // 한 화면에 나타낼 데이터수
        let globalCurrentPage=1;
        let last;


    function selList(){

        dataPerPage = $("#dataPerPage").val(); // 한 페이지에 나타낼 데이터 수를 선택하는 셀렉트박스 값을 가져온다.
        var jsonData = {"searchTxt" : $('#txt1').val()}; // 검색 조건

        $.ajax({
            type : "POST",
            url : "/selectPharmacyInfoList.do",
            dataType : 'json',
            data : jsonData,
            async:false,
            error : function() {
                alert("서버에서 처리중 에러가 발생하였습니다.");
            },
            success : function(data) {
                dataList=[];
                totalData=data.resultListCnt; // 데이터 총 개수
                $.each(data.resultList, function(i, v) {
                    dataList.push(v); // 데이터를 배열에 담아준다.
                });
            }
        });

        // 테이블에 데이터를 표출하기 위해 displayData(현재 페이지, 한 페이지에 나타낼 수 있는 데이터 수) 함수를 호출한다.
        displayData(1, dataPerPage);

        //페이징 처리 및 표시 함수 호출 paging(전체 데이터 수,  한 페이지에 나타낼 수 있는 데이터 수, 한 화면에 나타낼 페이지 수 , 현재페이지)
        paging(totalData, dataPerPage, pageCount, 1);
}
        $(document).ready(function () {

            selList()
            // 페이지당 글 개수 변경시
            $("#dataPerPage").on("change", function(){
                dataPerPage = $("#dataPerPage").val();
                //전역 변수에 담긴 globalCurrent 값을 이용하여 페이지 이동없이 글 표시개수 변경
                displayData(1, dataPerPage);
                paging(totalData, dataPerPage, pageCount, 1);
            });

        });

        $(document).on('click', 'button[name=btn]', function(){

            selList();
        });


        //현재 페이지(currentPage)와 페이지당 글 개수(dataPerPage) 반영
        function displayData(currentPage, dataPerPage) {
            let chartHtml = "";

            //currentPage와 dataPerPage를 number로 변환
            currentPage = Number(currentPage);
            dataPerPage = Number(dataPerPage);

            $("#dataTableBody").empty();
            //데이터가 존재할 경우
            if(totalData>0){
                var pageSize=(currentPage - 1) * dataPerPage + dataPerPage;

                // 마지막 페이지일 경우
                if(totalPage==currentPage){
                    alert();
                    pageSize=dataList.length;
                }

                for (var i=(currentPage - 1) * dataPerPage; i < pageSize; i++) {
                        chartHtml +=
                            "<tr><td>" +
                            dataList[i].instNm +
                            "</td><td>" +
                            dataList[i].reprsntTelno +
                            "</td><td>" +
                            dataList[i].refineLotonoAddr +
                            "</td><td>월요일 : "+dataList[i].mon+", 화요일 : "+dataList[i].tues
                            +"<br/>수요일 :"+dataList[i].wed+",목요일 :"+dataList[i].thur
                            +"<br/>금요일 :"+dataList[i].fri+", 토요일 :"+dataList[i].sat+"<br/>일요일 :"+dataList[i].sun
                            +", 공휴일 :"+dataList[i].holiday+"</td></td>";
                }
            }else{
                chartHtml='<tr>'+
                    '<td colspan="4" align="center">데이터없음</td>'+
                    '</tr>';
            }

            $("#dataTableBody").html(chartHtml);
        }


        function paging(totalData, dataPerPage, pageCount, currentPage) {
            totalPage = Math.ceil(totalData / dataPerPage); // 총 페이지 수 : 총 게시글 / 한 페이지에 보여질 데이터 수

            //총 페이지 수가 한 화면에 보여질 페이지 수보다 적을 경우
            if(totalPage<pageCount){
                pageCount=totalPage;
            }

            // 현재페이지/한페이지에 나타낼 페이지 수
           let pageGroup = Math.ceil(currentPage/pageCount); // 페이지 그룹(페이지 1~10 -> 1, 11~20 -> 2....)

             last = pageGroup * pageCount; //화면에 보여질 마지막 페이지 번호(10,20,30....)


            if (last > totalPage) {
                last = totalPage;
            }

            let first = last - (pageCount - 1); //화면에 보여질 첫번째 페이지 번호
            let next = last + 1;
            let prev = first - 1;

            let pageHtml = "";

            if (prev > 0) {
                pageHtml += "<li><a href='#' id='prev'> 이전 </a></li>";
            }

            //페이징 번호 표시
            for (var i = first; i <= last; i++) {
                if (currentPage == i) {
                    pageHtml +=
                        "<li class='on'><a href='#' id='" + i + "'>" + i + "</a></li>";
                } else {
                    pageHtml += "<li><a href='#' id='" + i + "'>" + i + "</a></li>";
                }
            }

            if (last < totalPage) {
                pageHtml += "<li><a href='#' id='next'> 다음 </a></li>";
            }


            $("#pagingul").html(pageHtml);

            let displayCount = "";
            displayCount = "현재 "+currentPage+" - " + totalPage + " 페이지 / " + totalData + "건";
            $("#cntText").text(displayCount);

            // 데이터 없을 경우 페이징 표시 숨기기
            if(totalData > 0){
                $("#pagingul").show();
            } else{
                $("#pagingul").hide();
            }

            //페이징 번호 클릭 이벤트
            $("#pagingul li a").click(function () {
                let $id = $(this).attr("id");
                selectedPage = $(this).text();

                if ($id == "next"){selectedPage = next;}
                if ($id == "prev"){selectedPage = prev;}


                globalCurrentPage = selectedPage;
                //페이징 표시 함수 호출
                paging(totalData, dataPerPage, pageCount, selectedPage);
                //테이블 데이터 표실 함수 호출
                displayData(selectedPage, dataPerPage);
            });
        }


    </script>

</head>

<body>
<div class="container">

    <div class="row marketing">
        <div class="row">
            <div class="col-md-12">
                <div class="page-header">
                    <h2 >고양시, 부천시 약국 정보 조회</h2>
                </div>
                    <div class="form-group">
                        <label for="txt1">주소:</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="txt1">
                            <span class="input-group-btn">
		                <button class="btn btn-default" name="btn" type="button">검색</button>
	                    </span>
                        </div>
                    </div>
            </div>
        </div>
        <label id="cntText" style="float: right;margin-top: 10px;"></label>
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>약국명</th>
                <th>전화번호</th>
                <th>지번</th>
                <th>영업일</th>
            </tr>
            </thead>
            <tbody id="dataTableBody"></tbody>
        </table>
        <div class="paging" style="text-align: center">
        <ul id="pagingul"  style="list-style: none;padding-left: 0px;"></ul>
        <select id="dataPerPage" class="form-control" style="width: 150px;margin-bottom: 10px;float: right;">
            <option value="10">10개씩보기</option>
            <option value="15">15개씩보기</option>
            <option value="20">20개씩보기</option>
        </select>
        </div>
    </div>

</div> <!-- /container -->
</body>
</html>