package com.example.PharmacyInfoMap.Dao;

import com.example.PharmacyInfoMap.Dto.ParmacyInfoMapVO;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface ParmacyInfoMapDao {
   void insertParmacyInfo(ParmacyInfoMapVO parmacyInfoMapVO);

   List<Map<String,Object>>  select(ParmacyInfoMapVO parmacyInfoMapVO);

   int selectCnt(ParmacyInfoMapVO parmacyInfoMapVO);
}
