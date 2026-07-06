package com.example.library.mapper;

import com.example.library.entity.BorrowRecord;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BorrowRecordMapper {

    List<BorrowRecord> findAllWithDetails();
    
    BorrowRecord findById(Long id);

    int update(BorrowRecord record);
    
    int deleteById(Long id);
}
