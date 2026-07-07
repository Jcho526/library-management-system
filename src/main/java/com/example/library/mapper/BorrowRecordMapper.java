package com.example.library.mapper;

import com.example.library.entity.BorrowRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BorrowRecordMapper {

    List<BorrowRecord> findAllWithDetails();

    List<BorrowRecord> search(@Param("keyword") String keyword, @Param("status") Integer status);

    List<BorrowRecord> findByUserId(@Param("userId") Long userId);

    BorrowRecord findById(Long id);

    int insert(BorrowRecord record);

    int update(BorrowRecord record);
    
    int deleteById(Long id);
}
