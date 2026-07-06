package com.example.library.controller;

import com.example.library.entity.BorrowRecord;
import com.example.library.service.BorrowRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/borrows")
@CrossOrigin(origins = "*")
public class BorrowRecordController {

    private final BorrowRecordService borrowRecordService;

    @Autowired
    public BorrowRecordController(BorrowRecordService borrowRecordService) {
        this.borrowRecordService = borrowRecordService;
    }

    @GetMapping
    public ResponseEntity<List<BorrowRecord>> getAllBorrowRecords() {
        List<BorrowRecord> records = borrowRecordService.findAllWithDetails();
        return ResponseEntity.ok(records);
    }

    @PutMapping("/{id}/return")
    public ResponseEntity<Map<String, Object>> returnBook(@PathVariable Long id, @RequestBody Map<String, String> body) {
        Map<String, Object> response = new HashMap<>();
        String remark = body.get("remark");
        int result = borrowRecordService.returnBook(id, remark);
        if (result > 0) {
            response.put("success", true);
            response.put("message", "归还成功");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "归还失败或已归还");
            return ResponseEntity.badRequest().body(response);
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteBorrowRecord(@PathVariable Long id) {
        Map<String, Object> response = new HashMap<>();
        int result = borrowRecordService.deleteById(id);
        if (result > 0) {
            response.put("success", true);
            response.put("message", "借阅记录删除成功");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "借阅记录删除失败");
            return ResponseEntity.badRequest().body(response);
        }
    }
}
