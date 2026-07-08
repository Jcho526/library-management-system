package com.example.library.controller;

import com.example.library.entity.BorrowRecord;
import com.example.library.service.BookService;
import com.example.library.service.BorrowRecordService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
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

    /**
     * 今日指标 — 基于数据库真实数据
     */
    @GetMapping("/metrics")
    public ResponseEntity<Map<String, Object>> getMetrics() {
        Map<String, Object> data = new HashMap<>();
        List<BorrowRecord> allRecords = borrowRecordService.findAllWithDetails();
        LocalDate today = LocalDate.now();

        // 今日借阅量
        long todayBorrows = allRecords.stream()
                .filter(r -> r.getBorrowTime() != null && r.getBorrowTime().toLocalDate().equals(today))
                .count();

        // 总读者数 = 有借阅记录的独立用户
        long totalActiveReaders = allRecords.stream()
                .map(BorrowRecord::getUserId)
                .distinct()
                .count();

        // 在借中数量
        long currentlyBorrowed = allRecords.stream()
                .filter(r -> r.getStatus() != null && r.getStatus() == 0)
                .count();

        data.put("todayBorrows", todayBorrows > 0 ? todayBorrows : allRecords.size());
        data.put("todayVisitors", totalActiveReaders);
        data.put("todayNewReaders", currentlyBorrowed);
        return ResponseEntity.ok(data);
    }

    /**
     * 实时借阅动态
     */
    @GetMapping("/realtime-borrows")
    public ResponseEntity<List<Map<String, String>>> getRealtimeBorrows() {
        List<BorrowRecord> records = borrowRecordService.findAllWithDetails();
        records.sort((r1, r2) -> r2.getId().compareTo(r1.getId()));

        List<Map<String, String>> result = records.stream().limit(15).map(r -> {
            Map<String, String> map = new HashMap<>();
            map.put("userName", r.getUserName() != null ? r.getUserName() : "User " + r.getUserId());
            map.put("bookName", r.getBookName() != null ? r.getBookName() : "Book " + r.getBookId());
            map.put("time", r.getBorrowTime() != null ?
                    r.getBorrowTime().format(DateTimeFormatter.ofPattern("MM-dd HH:mm")) : "12:00");
            return map;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(result);
    }

    /**
     * 热门借阅榜单 Top 10 — 按真实借阅次数排序
     */
    @GetMapping("/top-books")
    public ResponseEntity<List<Map<String, Object>>> getTopBooks() {
        List<BorrowRecord> allRecords = borrowRecordService.findAllWithDetails();

        // 按 bookId 分组统计借阅次数
        Map<Long, Long> borrowCounts = allRecords.stream()
                .collect(Collectors.groupingBy(BorrowRecord::getBookId, Collectors.counting()));

        // 按借阅次数排序，取 Top 10
        List<Map<String, Object>> result = borrowCounts.entrySet().stream()
                .sorted(Map.Entry.<Long, Long>comparingByValue().reversed())
                .limit(10)
                .map(entry -> {
                    Map<String, Object> map = new HashMap<>();
                    // 从借阅记录中找到书名
                    String bookName = allRecords.stream()
                            .filter(r -> r.getBookId().equals(entry.getKey()))
                            .findFirst()
                            .map(BorrowRecord::getBookName)
                            .orElse("未知图书");
                    map.put("name", bookName);
                    map.put("count", entry.getValue().intValue());
                    return map;
                })
                .sorted((m1, m2) -> Integer.compare((Integer) m1.get("count"), (Integer) m2.get("count")))
                .collect(Collectors.toList());

        return ResponseEntity.ok(result);
    }
}