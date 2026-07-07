package com.example.library.service;

import com.example.library.entity.BorrowRecord;
import java.util.List;

public interface BorrowRecordService {

    List<BorrowRecord> findAllWithDetails();

    List<BorrowRecord> search(String keyword, Integer status);

    List<BorrowRecord> findByUserId(Long userId);

    BorrowRecord findById(Long id);

    int addBorrowRecord(BorrowRecord record);

    int returnBook(Long id, String remark);

    int deleteById(Long id);
}
