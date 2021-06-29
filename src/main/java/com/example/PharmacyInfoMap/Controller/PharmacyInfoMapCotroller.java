package com.example.PharmacyInfoMap.Controller;


import com.example.PharmacyInfoMap.Dto.ParmacyInfoMapVO;
import com.example.PharmacyInfoMap.Service.ParmacyInfoMapService;
import com.example.PharmacyInfoMap.Service.TestService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.ibatis.transaction.TransactionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.file.AccessDeniedException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
public class PharmacyInfoMapCotroller {
    @Autowired
    ParmacyInfoMapService parmacyInfoMapService;

    /**
     * 약국정보 api db저장
     * */
    @GetMapping("/getParmacyInfo")
    @ResponseBody
    public String  getParmacyInfo() throws IOException, ParseException {
        // 고양시, 부천시
        String[] sidoCode={"41280","41190"};
        String[] sidoCnt={"409","350"};

        String serviceKey = "f757cf1ea4a84ae1b5e0d089b9b9a782";
        String urlStr = " https://openapi.gg.go.kr/ParmacyInfo";
        for(int j=0; j< sidoCode.length; j++){
        urlStr += "?" + URLEncoder.encode("KEY", "UTF-8") + "=" + serviceKey;
        urlStr += "&" + URLEncoder.encode("Type", "UTF-8") + "=json";
        urlStr += "&" + URLEncoder.encode("pIndex", "UTF-8") + "=1";
        urlStr += "&" + URLEncoder.encode("pSize", "UTF-8") + "="+sidoCnt[j];
        urlStr += "&" + URLEncoder.encode("SIGUN_CD", "UTF-8") + "="+sidoCode[j];
        System.out.print(urlStr);
        URL url = new URL(urlStr);
        System.out.println(url);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        //System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        String result = sb.toString();

        JSONParser parser = new JSONParser();

        JSONObject obj = (JSONObject) parser.parse(result);

        JSONArray ParmacyInfo = (JSONArray) obj.get("ParmacyInfo");

        JSONObject tmp = (JSONObject) ParmacyInfo.get(1);

        JSONArray rows = (JSONArray) tmp.get("row");
        List<ParmacyInfoMapVO> PharmacyTestVoList = new ArrayList<ParmacyInfoMapVO>();
        ParmacyInfoMapVO parmacyInfoMapVO = new ParmacyInfoMapVO();

        for (int i = 0; i < rows.size(); i++) {

            JSONObject item = (JSONObject) rows.get(i);
            parmacyInfoMapVO.setInstNm((String) item.get("INST_NM")); //약국명
            parmacyInfoMapVO.setRefineWgs84Logt((String) item.get("REFINE_WGS84_LOGT")); //경도
            parmacyInfoMapVO.setRefineWgs84Lat((String) item.get("REFINE_WGS84_LAT")); //위도
            parmacyInfoMapVO.setRefineRoadnmAddr((String) item.get("REFINE_ROADNM_ADDR")); //도로명
            parmacyInfoMapVO.setReprsntTelno((String) item.get("REPRSNT_TELNO")); //약국번호
            parmacyInfoMapVO.setRefineLotonoAddr((String)item.get("REFINE_LOTNO_ADDR")); //지번
            parmacyInfoMapVO.setSimplOtlnmapCont((String)item.get("SIMPL_OTLNMAP_CONT")); //위치설명
            parmacyInfoMapVO.setMonEndTreatTm((String)item.get("MON_END_TREAT_TM")); //월요일 마감시간
            parmacyInfoMapVO.setTuesEndTreatTm((String)item.get("TUES_END_TREAT_TM")); //화요일 마감시간
            parmacyInfoMapVO.setWedEndTreatTm((String)item.get("WED_END_TREAT_TM")); //수요일 마감시간
            parmacyInfoMapVO.setThurEndTreatTm((String)item.get("THUR_END_TREAT_TM")); //목요일 마감시간
            parmacyInfoMapVO.setFriEndTreatTm((String)item.get("FRI_END_TREAT_TM")); //금요일 마감시간
            parmacyInfoMapVO.setSatEndTreatTm((String)item.get("SAT_END_TREAT_TM")); //토요일 마감시간
            parmacyInfoMapVO.setSunEndTreatTm((String)item.get("SUN_END_TREAT_TM")); //일요일 마감시간
            parmacyInfoMapVO.setHolidayEndTreatTm((String)item.get("HOLIDAY_END_TREAT_TM")); //공휴일 마감시간
            parmacyInfoMapVO.setMonBeginTreatTm((String)item.get("MON_BEGIN_TREAT_TM")); //월요일 오픈시간
            parmacyInfoMapVO.setTuesBeginTreatTm((String)item.get("TUES_BEGIN_TREAT_TM")); //화요일 오픈시간
            parmacyInfoMapVO.setWedBeginTreatTm((String)item.get("WED_BEGIN_TREAT_TM")); //수요일 오픈시간
            parmacyInfoMapVO.setThurBeginTreatTm((String)item.get("THUR_BEGIN_TREAT_TM")); //목요일 오픈시간
            parmacyInfoMapVO.setFriBeginTreatTm((String)item.get("FRI_BEGIN_TREAT_TM")); //금요일 오픈시간
            parmacyInfoMapVO.setSatBeginTreatTm((String)item.get("SAT_BEGIN_TREAT_TM")); //토요일 오픈시간
            parmacyInfoMapVO.setSunBeginTreatTm((String)item.get("SUN_BEGIN_TREAT_TM")); //일요일 오픈시간
            parmacyInfoMapVO.setHolidayBeginTreatTm((String)item.get("HOLIDAY_BEGIN_TREAT_TM")); //공휴일 오픈시간

            parmacyInfoMapService.insertParmacyInfo(parmacyInfoMapVO);
        }

        }
        return "{\"code\": \"0\",\"message\": \"success\"}";
    }

    @GetMapping("/viewPharmacyInfoMap")
    public String viewPharmacyInfoMap(ModelMap model, ParmacyInfoMapVO parmacyInfoMapVO) throws JsonProcessingException {
       model.addAttribute("pharmacyInfo",new ObjectMapper().writeValueAsString(parmacyInfoMapService.selectParmacyInfoList()));

        return "sample/ajaxSample";
    }

    @RequestMapping(value = "/selectPharmacyInfoList.do",method = RequestMethod.POST)
    @ResponseBody
    public Map<String,Object> selectPharmacyInfoList(ParmacyInfoMapVO parmacyInfoMapVO)  {
        Map<String,Object> resultMap = new HashMap<String,Object>();
        try{
            resultMap.put("resultList", parmacyInfoMapService.select(parmacyInfoMapVO));
            resultMap.put("resultListCnt", parmacyInfoMapService.selectCnt(parmacyInfoMapVO));
        }catch(Exception e) {
            resultMap.put("resultMsg", "알 수 없는 오류가 발생했습니다.");
        }
        return resultMap;

    }

}