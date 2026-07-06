package com.example.library.service;

import com.example.library.entity.BorrowRecord;
import java.util.List;

public interface BorrowRecordService {

    List<BorrowRecord> findAllWithDetails();

    BorrowRecord findById(Long id);

    int returnBook(Long id, String remark);
    
    int deleteById(Long id);
}
