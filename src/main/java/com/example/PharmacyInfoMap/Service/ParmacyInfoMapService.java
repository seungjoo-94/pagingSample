package com.example.PharmacyInfoMap.Service;

import com.example.PharmacyInfoMap.Dto.ParmacyInfoMapVO;

import java.util.List;
import java.util.Map;

public interface ParmacyInfoMapService {
    void insertParmacyInfo(ParmacyInfoMapVO parmacyInfoMapVO);

    List<Map<String, Object>>  select(ParmacyInfoMapVO parmacyInfoMapVO);

    int selectCnt(ParmacyInfoMapVO parmacyInfoMapVO);
}
