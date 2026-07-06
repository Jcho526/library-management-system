package com.example.library.service.impl;

import com.example.library.entity.BorrowRecord;
import com.example.library.mapper.BorrowRecordMapper;
import com.example.library.service.BorrowRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class BorrowRecordServiceImpl implements BorrowRecordService {

    private final BorrowRecordMapper borrowRecordMapper;

    @Autowired
    public BorrowRecordServiceImpl(BorrowRecordMapper borrowRecordMapper) {
        this.borrowRecordMapper = borrowRecordMapper;
    }

    @Override
    public List<BorrowRecord> findAllWithDetails() {
        return borrowRecordMapper.findAllWithDetails();
    }

    @Override
    public BorrowRecord findById(Long id) {
        return borrowRecordMapper.findById(id);
    }

    @Override
    public int returnBook(Long id, String remark) {
        BorrowRecord record = borrowRecordMapper.findById(id);
        if (record != null && record.getStatus() != 1) {
            record.setStatus(1); // 1: 已归还
            record.setReturnTime(LocalDateTime.now());
            record.setRemark(remark);
            return borrowRecordMapper.update(record);
        }
        return 0;
    }

    @Override
    public int deleteById(Long id) {
        return borrowRecordMapper.deleteById(id);
    }
}
