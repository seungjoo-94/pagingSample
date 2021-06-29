package com.example.PharmacyInfoMap.Service.Impl;


import com.example.PharmacyInfoMap.Dao.ParmacyInfoMapDao;
import com.example.PharmacyInfoMap.Dao.TestDao;
import com.example.PharmacyInfoMap.Dto.ParmacyInfoMapVO;
import com.example.PharmacyInfoMap.Dto.Test;
import com.example.PharmacyInfoMap.Service.ParmacyInfoMapService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class ParmacyInfoMapServiceImpl implements ParmacyInfoMapService {
    @Resource
    ParmacyInfoMapDao maper;

    @Override
    public void insertParmacyInfo(ParmacyInfoMapVO parmacyInfoMapVO) {
        maper.insertParmacyInfo(parmacyInfoMapVO);
    }

    @Override
    public   List<Map<String,Object>> select(ParmacyInfoMapVO parmacyInfoMapVO){

        return maper.select(parmacyInfoMapVO);
    }

    @Override
    public int selectCnt(ParmacyInfoMapVO parmacyInfoMapVO){

        return maper.selectCnt(parmacyInfoMapVO);
    }
}
