<%@ page language="java" contentType="text/html; charset=EUC-KR"
         pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>��ȸ</title>

    <!-- Bootstrap core CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.2/css/bootstrap.min.css">

    <!-- Custom styles for this template -->
    <link href="css/map.css" rel="stylesheet">

    <!--jquery-->
    <script scr="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

    <script>
        let dataList = []; // ajax�� ó���� ��� �����͸� ��� �迭
        let totalData; //�� ������ ��
        let totalPage;
        let dataPerPage; //�� �������� ��Ÿ�� ������ ��
        let pageCount = 10; // �� ȭ�鿡 ��Ÿ�� �����ͼ�
        let globalCurrentPage=1;
        let last;


    function selList(){

        dataPerPage = $("#dataPerPage").val(); // �� �������� ��Ÿ�� ������ ���� �����ϴ� ����Ʈ�ڽ� ���� �����´�.
        var jsonData = {"searchTxt" : $('#txt1').val()}; // �˻� ����

        $.ajax({
            type : "POST",
            url : "/selectPharmacyInfoList.do",
            dataType : 'json',
            data : jsonData,
            async:false,
            error : function() {
                alert("�������� ó���� ������ �߻��Ͽ����ϴ�.");
            },
            success : function(data) {
                dataList=[];
                totalData=data.resultListCnt; // ������ �� ����
                $.each(data.resultList, function(i, v) {
                    dataList.push(v); // �����͸� �迭�� ����ش�.
                });
            }
        });

        // ���̺� �����͸� ǥ���ϱ� ���� displayData(���� ������, �� �������� ��Ÿ�� �� �ִ� ������ ��) �Լ��� ȣ���Ѵ�.
        displayData(1, dataPerPage);

        //����¡ ó�� �� ǥ�� �Լ� ȣ�� paging(��ü ������ ��,  �� �������� ��Ÿ�� �� �ִ� ������ ��, �� ȭ�鿡 ��Ÿ�� ������ �� , ����������)
        paging(totalData, dataPerPage, pageCount, 1);
}
        $(document).ready(function () {

            selList()
            // �������� �� ���� �����
            $("#dataPerPage").on("change", function(){
                dataPerPage = $("#dataPerPage").val();
                //���� ������ ��� globalCurrent ���� �̿��Ͽ� ������ �̵����� �� ǥ�ð��� ����
                displayData(1, dataPerPage);
                paging(totalData, dataPerPage, pageCount, 1);
            });

        });

        $(document).on('click', 'button[name=btn]', function(){

            selList();
        });


        //���� ������(currentPage)�� �������� �� ����(dataPerPage) �ݿ�
        function displayData(currentPage, dataPerPage) {
            let chartHtml = "";

            //currentPage�� dataPerPage�� number�� ��ȯ
            currentPage = Number(currentPage);
            dataPerPage = Number(dataPerPage);

            $("#dataTableBody").empty();
            //�����Ͱ� ������ ���
            if(totalData>0){
                var pageSize=(currentPage - 1) * dataPerPage + dataPerPage;

                // ������ �������� ���
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
                            "</td><td>������ : "+dataList[i].mon+", ȭ���� : "+dataList[i].tues
                            +"<br/>������ :"+dataList[i].wed+",����� :"+dataList[i].thur
                            +"<br/>�ݿ��� :"+dataList[i].fri+", ����� :"+dataList[i].sat+"<br/>�Ͽ��� :"+dataList[i].sun
                            +", ������ :"+dataList[i].holiday+"</td></td>";
                }
            }else{
                chartHtml='<tr>'+
                    '<td colspan="4" align="center">�����;���</td>'+
                    '</tr>';
            }

            $("#dataTableBody").html(chartHtml);
        }


        function paging(totalData, dataPerPage, pageCount, currentPage) {
            totalPage = Math.ceil(totalData / dataPerPage); // �� ������ �� : �� �Խñ� / �� �������� ������ ������ ��

            //�� ������ ���� �� ȭ�鿡 ������ ������ ������ ���� ���
            if(totalPage<pageCount){
                pageCount=totalPage;
            }

            // ����������/���������� ��Ÿ�� ������ ��
           let pageGroup = Math.ceil(currentPage/pageCount); // ������ �׷�(������ 1~10 -> 1, 11~20 -> 2....)

             last = pageGroup * pageCount; //ȭ�鿡 ������ ������ ������ ��ȣ(10,20,30....)


            if (last > totalPage) {
                last = totalPage;
            }

            let first = last - (pageCount - 1); //ȭ�鿡 ������ ù��° ������ ��ȣ
            let next = last + 1;
            let prev = first - 1;

            let pageHtml = "";

            if (prev > 0) {
                pageHtml += "<li><a href='#' id='prev'> ���� </a></li>";
            }

            //����¡ ��ȣ ǥ��
            for (var i = first; i <= last; i++) {
                if (currentPage == i) {
                    pageHtml +=
                        "<li class='on'><a href='#' id='" + i + "'>" + i + "</a></li>";
                } else {
                    pageHtml += "<li><a href='#' id='" + i + "'>" + i + "</a></li>";
                }
            }

            if (last < totalPage) {
                pageHtml += "<li><a href='#' id='next'> ���� </a></li>";
            }


            $("#pagingul").html(pageHtml);

            let displayCount = "";
            displayCount = "���� "+currentPage+" - " + totalPage + " ������ / " + totalData + "��";
            $("#cntText").text(displayCount);

            // ������ ���� ��� ����¡ ǥ�� �����
            if(totalData > 0){
                $("#pagingul").show();
            } else{
                $("#pagingul").hide();
            }

            //����¡ ��ȣ Ŭ�� �̺�Ʈ
            $("#pagingul li a").click(function () {
                let $id = $(this).attr("id");
                selectedPage = $(this).text();

                if ($id == "next"){selectedPage = next;}
                if ($id == "prev"){selectedPage = prev;}


                globalCurrentPage = selectedPage;
                //����¡ ǥ�� �Լ� ȣ��
                paging(totalData, dataPerPage, pageCount, selectedPage);
                //���̺� ������ ǥ�� �Լ� ȣ��
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
                    <h2 >����, ��õ�� �౹ ���� ��ȸ</h2>
                </div>
                    <div class="form-group">
                        <label for="txt1">�ּ�:</label>
                        <div class="input-group">
                            <input type="text" class="form-control" id="txt1">
                            <span class="input-group-btn">
		                <button class="btn btn-default" name="btn" type="button">�˻�</button>
	                    </span>
                        </div>
                    </div>
            </div>
        </div>
        <label id="cntText" style="float: right;margin-top: 10px;"></label>
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>�౹��</th>
                <th>��ȭ��ȣ</th>
                <th>����</th>
                <th>������</th>
            </tr>
            </thead>
            <tbody id="dataTableBody"></tbody>
        </table>
        <div class="paging" style="text-align: center">
        <ul id="pagingul"  style="list-style: none;padding-left: 0px;"></ul>
        <select id="dataPerPage" class="form-control" style="width: 150px;margin-bottom: 10px;float: right;">
            <option value="10">10��������</option>
            <option value="15">15��������</option>
            <option value="20">20��������</option>
        </select>
        </div>
    </div>

</div> <!-- /container -->
</body>
</html>