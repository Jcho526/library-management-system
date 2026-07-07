package com.example.library.controller;

import com.example.library.entity.BorrowRecord;
import com.example.library.service.BorrowRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.example.library.entity.Book;
import com.example.library.entity.User;
import com.example.library.service.BookService;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDateTime;

@RestController
@RequestMapping("/api/borrows")
@CrossOrigin(origins = "*")
public class BorrowRecordController {

    private final BorrowRecordService borrowRecordService;
    private final BookService bookService;

    @Autowired
    public BorrowRecordController(BorrowRecordService borrowRecordService, BookService bookService) {
        this.borrowRecordService = borrowRecordService;
        this.bookService = bookService;
    }

    @GetMapping
    public ResponseEntity<List<BorrowRecord>> getAllBorrowRecords() {
        List<BorrowRecord> records = borrowRecordService.findAllWithDetails();
        return ResponseEntity.ok(records);
    }

    @GetMapping("/search")
    public ResponseEntity<List<BorrowRecord>> searchBorrowRecords(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status) {
        List<BorrowRecord> records = borrowRecordService.search(keyword, status);
        return ResponseEntity.ok(records);
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> addBorrowRecord(@RequestBody BorrowRecord record) {
        Map<String, Object> response = new HashMap<>();
        int result = borrowRecordService.addBorrowRecord(record);
        if (result > 0) {
            response.put("success", true);
            response.put("message", "借阅记录添加成功");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "借阅记录添加失败");
            return ResponseEntity.badRequest().body(response);
        }
    }

    @PostMapping("/borrow")
    public ResponseEntity<Map<String, Object>> borrowBook(@RequestBody Map<String, Long> payload, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        User user = (User) session.getAttribute("currentUser");
        if (user == null) {
            response.put("success", false);
            response.put("message", "未登录");
            return ResponseEntity.status(401).body(response);
        }

        Long bookId = payload.get("bookId");
        if (bookId == null) {
            response.put("success", false);
            response.put("message", "图书ID不能为空");
            return ResponseEntity.badRequest().body(response);
        }

        Book book = bookService.findById(bookId);
        if (book == null) {
             response.put("success", false);
             response.put("message", "图书不存在");
             return ResponseEntity.badRequest().body(response);
        }
        if ("借阅中".equals(book.getBorrowStatus()) || (book.getStock() != null && book.getStock() <= 0)) {
             response.put("success", false);
             response.put("message", "该图书当前不可借阅");
             return ResponseEntity.badRequest().body(response);
        }

        List<BorrowRecord> borrows = borrowRecordService.findByUserId(user.getId());
        long currentBorrowCount = borrows.stream().filter(r -> r.getStatus() != null && r.getStatus() == 0).count();
        if (currentBorrowCount >= (user.getMaxBooks() != null ? user.getMaxBooks() : 5)) {
             response.put("success", false);
             response.put("message", "借阅数量已达上限");
             return ResponseEntity.badRequest().body(response);
        }

        BorrowRecord record = new BorrowRecord();
        record.setBookId(bookId);
        record.setUserId(user.getId());
        record.setStatus(0);
        record.setBorrowTime(LocalDateTime.now());
        record.setDueTime(LocalDateTime.now().plusDays(30));
        
        int result = borrowRecordService.addBorrowRecord(record);
        if (result > 0) {
            if (book.getStock() != null && book.getStock() > 0) {
                book.setStock(book.getStock() - 1);
                bookService.update(book);
            }
            response.put("success", true);
            response.put("message", "借阅成功");
            return ResponseEntity.ok(response);
        } else {
            response.put("success", false);
            response.put("message", "借阅失败");
            return ResponseEntity.badRequest().body(response);
        }
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
