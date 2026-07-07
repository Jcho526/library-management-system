package com.example.library.controller;

import com.example.library.entity.Book;
import com.example.library.entity.BorrowRecord;
import com.example.library.service.BookService;
import com.example.library.service.BorrowRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/dashboard")
@CrossOrigin(origins = "*")
public class DashboardController {

    private final BorrowRecordService borrowRecordService;
    private final BookService bookService;

    @Autowired
    public DashboardController(BorrowRecordService borrowRecordService, BookService bookService) {
        this.borrowRecordService = borrowRecordService;
        this.bookService = bookService;
    }

    @GetMapping("/metrics")
    public ResponseEntity<Map<String, Object>> getMetrics() {
        Map<String, Object> data = new HashMap<>();
        // Mock data for today's visitors and new readers
        data.put("todayBorrows", new Random().nextInt(500) + 100);
        data.put("todayVisitors", new Random().nextInt(1000) + 200);
        data.put("todayNewReaders", new Random().nextInt(50) + 10);
        return ResponseEntity.ok(data);
    }

    @GetMapping("/realtime-borrows")
    public ResponseEntity<List<Map<String, String>>> getRealtimeBorrows() {
        List<BorrowRecord> records = borrowRecordService.findAllWithDetails();
        // Sort by id descending (assuming newer records have higher IDs)
        records.sort((r1, r2) -> r2.getId().compareTo(r1.getId()));
        
        List<Map<String, String>> result = records.stream().limit(10).map(r -> {
            Map<String, String> map = new HashMap<>();
            map.put("userName", r.getUserName() != null ? r.getUserName() : "User " + r.getUserId());
            map.put("bookName", r.getBookName() != null ? r.getBookName() : "Book " + r.getBookId());
            map.put("time", r.getBorrowTime() != null ? r.getBorrowTime().format(DateTimeFormatter.ofPattern("HH:mm")) : "12:00");
            return map;
        }).collect(Collectors.toList());
        
        return ResponseEntity.ok(result);
    }

    @GetMapping("/top-books")
    public ResponseEntity<List<Map<String, Object>>> getTopBooks() {
        List<Book> books = bookService.findAll();
        // Mock top books by taking some books and assigning random high borrow counts
        books.sort((b1, b2) -> b2.getId().compareTo(b1.getId()));
        
        List<Map<String, Object>> result = books.stream().limit(10).map(b -> {
            Map<String, Object> map = new HashMap<>();
            map.put("name", b.getBookName());
            map.put("count", new Random().nextInt(200) + 30);
            return map;
        }).sorted((m1, m2) -> Integer.compare((Integer) m1.get("count"), (Integer) m2.get("count"))).collect(Collectors.toList());
        
        return ResponseEntity.ok(result);
    }
}
